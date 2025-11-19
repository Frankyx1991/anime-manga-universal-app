import 'package:hive/hive.dart';

part 'content_entry.g.dart';

@HiveType(typeId: 0)
class ContentEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String type; // 'anime', 'manga', 'manhwa'

  @HiveField(3)
  String coverUrl;

  @HiveField(4)
  String description;

  @HiveField(5)
  List<String> genres;

  @HiveField(6)
  String primarySource; // 'jkanime', 'animeflv', 'mangasnosekai', etc.

  @HiveField(7)
  String language; // 'es', 'en', 'ja'

  @HiveField(8)
  String status; // 'pending', 'watching', 'completed'

  @HiveField(9)
  int currentEpisode;

  @HiveField(10)
  int totalEpisodes;

  @HiveField(11)
  DateTime lastUpdated;

  @HiveField(12)
  double rating;

  @HiveField(13)
  Map<String, dynamic>? extraData;

  ContentEntry({
    required this.id,
    required this.title,
    required this.type,
    this.coverUrl = '',
    this.description = '',
    this.genres = const [],
    required this.primarySource,
    this.language = 'es',
    this.status = 'pending',
    this.currentEpisode = 0,
    this.totalEpisodes = 0,
    required this.lastUpdated,
    this.rating = 0.0,
    this.extraData,
  });

  // Métodos de utilidad
  bool get isAnime => type == 'anime';
  bool get isManga => type == 'manga' || type == 'manhwa';
  bool get isCompleted => status == 'completed';
  bool get isWatching => status == 'watching';
  
  double get progress {
    if (totalEpisodes == 0) return 0.0;
    return (currentEpisode / totalEpisodes) * 100;
  }

  // Convertir a Map para export
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'coverUrl': coverUrl,
      'description': description,
      'genres': genres,
      'primarySource': primarySource,
      'language': language,
      'status': status,
      'currentEpisode': currentEpisode,
      'totalEpisodes': totalEpisodes,
      'lastUpdated': lastUpdated.toIso8601String(),
      'rating': rating,
      'extraData': extraData,
    };
  }

  // Crear desde Map para import
  factory ContentEntry.fromMap(Map<String, dynamic> map) {
    return ContentEntry(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? 'anime',
      coverUrl: map['coverUrl'] ?? '',
      description: map['description'] ?? '',
      genres: List<String>.from(map['genres'] ?? []),
      primarySource: map['primarySource'] ?? '',
      language: map['language'] ?? 'es',
      status: map['status'] ?? 'pending',
      currentEpisode: map['currentEpisode'] ?? 0,
      totalEpisodes: map['totalEpisodes'] ?? 0,
      lastUpdated: DateTime.parse(map['lastUpdated']),
      rating: (map['rating'] ?? 0.0).toDouble(),
      extraData: map['extraData'],
    );
  }
}
