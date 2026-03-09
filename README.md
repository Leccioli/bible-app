# 📖 Bible App

A cross-platform Bible application built with Flutter, powered by the [API.Bible](https://scripture.api.bible/) REST API. Browse multiple Bible translations, search for keywords across any version, and get a curated daily verse to start your day.

> 🚧 **Work in progress** — This is a personal project I'm building to sharpen my Flutter and software architecture skills. Feedback and suggestions are welcome!

<!-- TODO: Add a demo GIF here -->
<!-- ![App Demo](assets/demo.gif) -->

---

## ✨ Features

- **Browse Bible Versions** — View a list of all available Bible translations from around the world, sorted alphabetically.
- **Keyword Search** — Select a Bible version and search for any keyword. Results display the verse reference and text, with long-press to copy.
- **Daily Verse** — A curated verse for each day of the month, fetched from the King James Version (KJV).

## 🗺️ Planned Features

- [ ] Bible Reader — Navigate books → chapters → verses and read the Bible in-app
- [ ] User Accounts — Authentication, personal preferences, and bookmarks
- [ ] Favorite Verses — Save and organize your favorite passages
- [ ] Offline Support — Cache previously read content for offline access
- [ ] Dark Mode — Theme toggle for comfortable reading at night

---

## 🏗️ Architecture & Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| **UI** | Flutter (Material 3) | Cross-platform user interface |
| **State Management** | flutter_bloc (Cubit) | Reactive state management with separation of concerns |
| **Networking** | http | REST API communication |
| **API** | [API.Bible](https://scripture.api.bible/) | Bible translations, verses, and search |
| **Concurrency** | Dart Isolates | Background JSON parsing for smooth UI performance |

### Project Structure

```
lib/
├── main.dart                  # App entry point & BlocProvider setup
├── cubits/                    # State management (Cubit + States)
│   ├── bible_cubit.dart
│   ├── bible_state.dart
│   ├── daily_verse_cubit.dart
│   ├── daily_verse_state.dart
│   ├── search_cubit.dart
│   └── search_state.dart
├── data/                      # Data layer (API client, models, constants)
│   ├── bible_api_client.dart
│   ├── daily_verses.dart
│   ├── secrets.dart           # API key (git-ignored)
│   └── models/
│       └── bible.dart
└── ui/                        # Presentation layer (screens)
    ├── home_page.dart
    ├── bibles_page.dart
    ├── search_page.dart
    └── daily_verse_page.dart
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.8.1)
- An API key from [API.Bible](https://scripture.api.bible/) (free)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Leccioli/bible.git
   cd bible
   ```

2. **Add your API key**

   Create the file `lib/data/secrets.dart` (this file is git-ignored):
   ```dart
   const String apiKey = 'YOUR_API_KEY_HERE';
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📚 What I'm Learning

This project is a hands-on exercise in:

- **State Management** — Managing async states (loading, success, error) with Cubit
- **Clean Architecture** — Separating UI, business logic, and data layers
- **API Integration** — Consuming RESTful APIs with proper error handling
- **Dart Concurrency** — Using Isolates for heavy computation off the main thread
- **Flutter Best Practices** — Widget lifecycle, resource disposal, and type safety

---

## 🛠️ Built With

- [Flutter](https://flutter.dev/) — UI toolkit for cross-platform apps
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — State management
- [http](https://pub.dev/packages/http) — HTTP client
- [API.Bible](https://scripture.api.bible/) — Bible data API

---

## 📄 License

This project is for personal and educational purposes.
