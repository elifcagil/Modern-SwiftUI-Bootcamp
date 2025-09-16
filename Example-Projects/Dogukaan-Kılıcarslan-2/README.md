### MultiDevBootcamp – Lesson 2 Skeleton (News + Favorites)

SwiftUI + MVVM skeleton for a practical bootcamp lesson. In this step we:
- Fetch a basic news list (temporary simple request).
- Persist articles and favorites with `UserDefaults`.
- Show a News tab and a Favorites tab.

This project is intentionally simple and swappable: later lessons will replace pieces (storage with Core Data, proper networking layer, etc.).

---

### Requirements
- Xcode 15+ (iOS 17 SDK)
- iOS 17 simulator or device
- Swift 5.9+

---

### Getting Started
1) Open `MultiDevBootcamp.xcodeproj` in Xcode.
2) Select the `MultiDevBootcamp` scheme and your target device/simulator.
3) (Optional but recommended) Set your NewsAPI key so the News tab fetches real data:
   - Product → Scheme → Edit Scheme… → Run → Arguments → Environment Variables
   - Add key `NEWS_API_KEY` with your API key value
   - The skeleton sends the key via `x-api-key` header to `top-headlines?country=us`.
4) Run.

If you skip the API key, the app shows a few demo placeholder articles so it still works during class.

---

### Project Structure (high-level)
- `MultiDevBootcamp/MultiDevBootcampApp.swift`: App entry point.
- `Models/`
  - `NewsArticle.swift`: Domain model used across views.
- `Scenes/`
  - `NewsList/View/NewsListView.swift`: List UI for news.
  - `NewsList/ViewModel/NewsListViewModel.swift`: ViewModel for fetching + persisting articles.
  - `Favorites/View/FavoritesView.swift`: List UI for favorites-only view.
  - `Favorites/ViewModel/FavoritesViewModel.swift`: ViewModel reading favorites from storage.
- `ViewComponents/`
  - `ArticleRowView.swift`: Row component with a star toggle.
- `Services/`
  - `BasicNewsService.swift`: Simple fetch using URLSession; uses top-headlines.
- `Network/`
  - `EndpointManager.swift`: Base URL + path constants.
  - `AccessProvider.swift`: Reads `NEWS_API_KEY` from environment.
  - `NewsAPIModels.swift`: Request/response DTOs for NewsAPI.
- `Storage/`
  - `UserDefaultsManager.swift`: Typed wrapper for `UserDefaults` (Codable + PropertyList types).
  - `ArticlesDataManager.swift`: Abstraction to save/load `[NewsArticle]` (UserDefaults-backed).
  - `NewsStorage.swift`: Protocol the app depends on (persist/load + favorites API).
  - `UserDefaultsNewsStorage.swift`: Concrete `NewsStorage` using `UserDefaultsManager` + `ArticlesDataManager`.

---

### Data Flow (Lesson 2)
- News tab
  - `NewsListViewModel.refresh()` → `BasicNewsService.fetchLatest(query:page:pageSize:)`
  - Maps response to `[NewsArticle]` → `NewsStorage.saveArticles` (UserDefaults)
  - UI lists `articles`; star toggles call `NewsStorage.toggleFavorite(id:)`.
- Favorites tab
  - `FavoritesViewModel` loads all articles from storage, filters by favorite IDs
  - The list is storage-only (no network); updates immediately when toggled.

Edge cases handled:
- No API key present → shows demo placeholders (no network call).
- Failed decode/read from storage → falls back to default values.

---

### What Students Implement in This Lesson
- Fill in the `ArticlesDataManager` methods:
  - `saveArticles(_:)` – encode and persist the array of `NewsArticle` using `UserDefaultsManager`.
  - `loadArticles()` – decode and return the saved array (or empty if absent/decoding fails).
- Optionally extend `BasicNewsService` to support search (`q`) and pagination.
- Wire small UI improvements (e.g., empty/error states copy, badges, etc.).

Hints:
- See `UserDefaultsManager` for typed key usage with Codable.
- `UserDefaultsNewsStorage` already delegates article persistence to `ArticlesDataManager` and manages favorite IDs separately.

---

### Networking (Temporary – to be replaced in a later lesson)
- Endpoint: `top-headlines` with `country=us` using `EndpointManager`.
- API key header: `x-api-key: <NEWS_API_KEY>` (set in Scheme → Environment Variables).
- Decoder: `JSONDecoder` with `iso8601` for `publishedAt`.
- If you want to switch to `everything` or add filters (e.g., `q`, `category`), adjust `BasicNewsService` query items.

---

### Favorites
- Stored as a `Set<String>` of article IDs (persisted via `UserDefaults` as an array of strings).
- Tapping the star toggles membership in that set and updates the list immediately.

---

### Known Limitations (by design for Lesson 2)
- Minimal error UI; only simple messages.
- No infinite pagination or caching policies yet.
- Storage is `UserDefaults` only (Core Data comes next lesson).

---

### Troubleshooting
- 401/403 or empty list: ensure `NEWS_API_KEY` is set under the scheme and valid.
- Empty Favorites after relaunch: ensure the app has write permission (simulator usually fine), and favorites were toggled at least once.
- Date decoding errors: NewsAPI uses ISO-8601; we use `JSONDecoder.dateDecodingStrategy = .iso8601`.

---

### Next Lessons
- Replace `UserDefaultsNewsStorage` with a Core Data-backed implementation.
- Replace `BasicNewsService` with a full network layer (endpoint abstraction, request builder, error mapping, tests).
- Add pagination, pull-to-refresh states, and offline-first behavior.


