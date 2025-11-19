# 📱 Universal Anime & Manga Aggregator

> **Agregador universal de anime y manga GRATIS** - App Flutter con almacenamiento local cifrado, sin cuentas, privacidad total.

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue)](#)

## ✨ Características

### 🔐 Privacidad y Seguridad
- ✅ **Almacenamiento 100% local** - Todos los metadatos se guardan cifrados en tu dispositivo
- ✅ **Cifrado AES-256** - Protección de datos con Hive encrypted
- ✅ **PIN y biometría** - Bloqueo de app con huella dactilar / Face ID
- ✅ **Sin registro** - No requiere cuenta ni datos personales
- ✅ **Export/Import** - Backup manual de tu biblioteca

### 🎬 Funcionalidades Anime
- 📺 Múltiples fuentes gratuitas: **jkanime**, **animeflv**, **anidb**
- 🎯 Búsqueda unificada entre todas las fuentes
- 📱 Reproductor WebView integrado
- 🔊 Selección de audio (SUB/DUB)
- 📊 Seguimiento de progreso por episodio
- 🏷️ Estados: Pendiente / Viendo / Finalizado

### 📚 Funcionalidades Manga/Manhwa
- 📖 Fuentes: **mangasnosekai**, **manhwaweb**, **zonatmo**
- 👁️ Lector optimizado con WebView
- 📄 Seguimiento por capítulo
- 🌐 Soporte multi-idioma (ES, EN)

### 🎨 Interfaz
- 🌙 Tema oscuro optimizado
- 🎭 Diseño temático anime/manga diferenciado
- 📲 Navegación inferior Material You
- ⚡ Carga con shimmer effects
- 🖼️ Caché de imágenes

## 🚀 Instalación

### Requisitos
- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio / VS Code
- Dispositivo Android 5.0+ o iOS 11+

### Pasos

```bash
# 1. Clonar repositorio
git clone https://github.com/Frankyx1991/anime-manga-universal-app.git
cd anime-manga-universal-app

# 2. Instalar dependencias
flutter pub get

# 3. Generar archivos Hive
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Ejecutar app
flutter run
```

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── core/
│   ├── constants/              # Constantes y configuraciones
│   ├── themes/                 # Temas anime/manga
│   └── utils/                  # Utilidades de cifrado/biometría
├── data/
│   ├── models/                 # Modelos Hive
│   │   ├── content_entry.dart  # Modelo anime/manga
│   │   └── user_preferences.dart
│   ├── repositories/           # Lógica de datos
│   └── sources/                # Scrapers de fuentes
│       ├── anime_sources/
│       │   ├── jkanime_source.dart
│       │   └── animeflv_source.dart
│       └── manga_sources/
│           └── mangasnosekai_source.dart
├── presentation/
│   ├── pages/
│   │   ├── home/              # Página principal
│   │   ├── anime/             # Lista y reproductor
│   │   ├── manga/             # Lista y lector
│   │   ├── library/           # Biblioteca personal
│   │   └── settings/          # Configuración y seguridad
│   └── widgets/               # Widgets reutilizables
└── services/
    ├── hive_service.dart      # Gestión almacenamiento cifrado
    ├── scraper_service.dart   # Web scraping
    └── webview_service.dart   # Reproducción/lectura
```

## 🔧 Dependencias Principales

```yaml
dependencies:
  # Almacenamiento cifrado
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0
  
  # Web scraping
  dio: ^5.4.0
  html: ^0.15.4
  
  # WebView
  webview_flutter: ^4.4.2
  flutter_inappwebview: ^6.0.0
  
  # Estado y navegación
  flutter_riverpod: ^2.4.9
  go_router: ^12.1.3
  
  # Seguridad
  local_auth: ^2.1.7
  crypto: ^3.0.3
```

## 💾 Almacenamiento Local

La app usa **Hive** con cifrado AES-256:

```dart
// Ejemplo de uso del servicio Hive
await HiveService.init();  // Inicializar con cifrado

// Agregar contenido
final anime = ContentEntry(
  id: 'one-piece-1',
  title: 'One Piece',
  type: 'anime',
  primarySource: 'jkanime',
  currentEpisode: 150,
  totalEpisodes: 1100,
  lastUpdated: DateTime.now(),
);

await HiveService.addContent(anime);

// Recuperar biblioteca
final library = HiveService.getAllContent();
final watching = HiveService.getContentByStatus('watching');
```

## 🎯 Fuentes Integradas

### Anime
- **jkanime.net** - Catálogo extenso en español
- **animeflv.net** - Actualizaciones rápidas
- **anidb.net** - Base de datos completa

### Manga/Manhwa
- **mangasnosekai.com** - Manga español
- **manhwaweb.com** - Manhwa coreano
- **zonatmo.com** - Variedad asiática

## 🔒 Seguridad y Privacidad

### Cifrado de Datos
```dart
// Generación automática de clave AES-256
final key = Hive.generateSecureKey();
final encryptedBox = await Hive.openBox(
  'content_library',
  encryptionCipher: HiveAesCipher(key),
);
```

### Autenticación Biométrica
```dart
// Verificar biometría disponible
final canAuth = await LocalAuthentication().canCheckBiometrics;

// Autenticar
final authenticated = await LocalAuthentication().authenticate(
  localizedReason: 'Desbloquear biblioteca',
);
```

## 🚧 Roadmap

- [x] Almacenamiento local cifrado
- [x] Modelos de datos anime/manga
- [x] Navegación principal
- [ ] Scrapers de fuentes anime (jkanime, animeflv)
- [ ] Scrapers de fuentes manga
- [ ] WebView reproductor/lector
- [ ] Sistema de búsqueda multi-fuente
- [ ] Sincronización de progreso
- [ ] Notificaciones de nuevos episodios
- [ ] Widget home screen
- [ ] Modo offline con descarga

## 🤝 Contribuir

Contribuciones son bienvenidas!

1. Fork el proyecto
2. Crea tu rama (`git checkout -b feature/NuevaFuncion`)
3. Commit cambios (`git commit -m 'Agregar NuevaFuncion'`)
4. Push a la rama (`git push origin feature/NuevaFuncion`)
5. Abre un Pull Request

## ⚖️ Legal

**IMPORTANTE**: Esta app es un agregador que enlaza a fuentes públicas. No aloja contenido.

- ✅ Solo integra sitios públicos y gratuitos
- ✅ No almacena ni transmite contenido con copyright
- ✅ Actúa como navegador web con funciones de seguimiento
- ✅ Reproduce anuncios de las fuentes originales

**El usuario es responsable del uso según las leyes locales.**

## 📄 Licencia

[MIT License](LICENSE) - Libre de usar, modificar y distribuir.

## 👤 Autor

**Frankyx1991**
- GitHub: [@Frankyx1991](https://github.com/Frankyx1991)
- Proyecto: [anime-manga-universal-app](https://github.com/Frankyx1991/anime-manga-universal-app)

## 🌟 Agradecimientos

- [Flutter](https://flutter.dev) - Framework multiplataforma
- [Hive](https://docs.hivedb.dev/) - Base de datos local
- [Consumet API](https://docs.consumet.org/) - Inspiración para scrapers
- Comunidades de anime/manga por las fuentes públicas

---

**¿Te gusta el proyecto? Dale una ⭐ en GitHub!**
