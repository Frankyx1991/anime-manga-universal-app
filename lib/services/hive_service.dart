import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/content_entry.dart';

class HiveService {
  static const String _contentBoxName = 'content_library';
  static const String _preferencesBoxName = 'user_preferences';
  static const String _historyBoxName = 'watch_history';
  static const String _encryptionKeyName = 'hive_encryption_key';
  
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Inicializar Hive con cifrado AES-256
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Registrar adaptadores (se generarán con build_runner)
    Hive.registerAdapter(ContentEntryAdapter());

    // Generar o recuperar clave de cifrado
    final encryptionKey = await _getEncryptionKey();
    final encryptionCipher = HiveAesCipher(encryptionKey);

    // Abrir boxes cifrados
    await Hive.openBox<ContentEntry>(
      _contentBoxName,
      encryptionCipher: encryptionCipher,
    );
    
    await Hive.openBox(
      _preferencesBoxName,
      encryptionCipher: encryptionCipher,
    );
    
    await Hive.openBox(
      _historyBoxName,
      encryptionCipher: encryptionCipher,
    );
  }

  /// Obtener o generar clave de cifrado de 256 bits
  static Future<List<int>> _getEncryptionKey() async {
    final hasKey = await _secureStorage.containsKey(key: _encryptionKeyName);
    
    if (!hasKey) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64UrlEncode(key),
      );
      return key;
    }
    
    final keyString = await _secureStorage.read(key: _encryptionKeyName);
    return base64Url.decode(keyString!);
  }

  // Getters para boxes
  static Box<ContentEntry> get contentBox => 
      Hive.box<ContentEntry>(_contentBoxName);
  
  static Box get preferencesBox => 
      Hive.box(_preferencesBoxName);
  
  static Box get historyBox => 
      Hive.box(_historyBoxName);

  // ===== OPERACIONES CRUD PARA CONTENIDO =====
  
  static Future<void> addContent(ContentEntry content) async {
    await contentBox.put(content.id, content);
  }

  static ContentEntry? getContent(String id) {
    return contentBox.get(id);
  }

  static List<ContentEntry> getAllContent() {
    return contentBox.values.toList();
  }

  static List<ContentEntry> getContentByType(String type) {
    return contentBox.values
        .where((content) => content.type == type)
        .toList();
  }

  static List<ContentEntry> getContentByStatus(String status) {
    return contentBox.values
        .where((content) => content.status == status)
        .toList();
  }

  static Future<void> updateContent(ContentEntry content) async {
    content.lastUpdated = DateTime.now();
    await content.save();
  }

  static Future<void> deleteContent(String id) async {
    await contentBox.delete(id);
  }

  // ===== OPERACIONES PARA PREFERENCIAS =====
  
  static Future<void> savePreference(String key, dynamic value) async {
    await preferencesBox.put(key, value);
  }

  static dynamic getPreference(String key, {dynamic defaultValue}) {
    return preferencesBox.get(key, defaultValue: defaultValue);
  }

  // ===== HISTORIAL =====
  
  static Future<void> addToHistory(String contentId) async {
    await historyBox.put(
      contentId,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static List<String> getHistory({int limit = 50}) {
    final entries = historyBox.toMap().entries.toList();
    entries.sort((a, b) => (b.value as int).compareTo(a.value as int));
    return entries.take(limit).map((e) => e.key as String).toList();
  }

  // ===== EXPORT/IMPORT =====
  
  static Future<Map<String, dynamic>> exportLibrary() async {
    return {
      'content': contentBox.values.map((c) => c.toMap()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };
  }

  static Future<void> importLibrary(Map<String, dynamic> data) async {
    final contentList = data['content'] as List;
    for (var item in contentList) {
      final content = ContentEntry.fromMap(item as Map<String, dynamic>);
      await addContent(content);
    }
  }

  // ===== LIMPIAR TODO =====
  
  static Future<void> clearAll() async {
    await contentBox.clear();
    await historyBox.clear();
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
