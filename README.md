# FilmBox — Ternak Klip Technical Test

Aplikasi Flutter untuk menjelajahi, mencari, dan menyimpan film favorit. Data film diambil dari file JSON lokal yang di-bundle bersama aplikasi.

---

## 1. Cara Menjalankan Aplikasi

### Prasyarat

| Kebutuhan | Versi minimum |
|-----------|--------------|
| Flutter   | 3.x (stable) |
| Dart      | 3.9.x        |
| Android SDK / Xcode | sesuai target platform |

### Langkah-langkah

```bash
# 1. Clone repositori
git clone <url-repositori>
cd ternak_klip_technical_test

# 2. Install dependencies
flutter pub get

# 3. Jalankan di emulator / device
flutter run

# 4. (Opsional) Jalankan unit test
flutter test test/features/favorites/
```

> Tidak diperlukan API key atau konfigurasi environment apapun — semua data bersumber dari `assets/data/movies.json`.

---

## 2. Arsitektur

Proyek ini menggunakan **Clean Architecture** dengan pembagian tiga layer: `data`, `domain`, dan `presentation`, yang diorganisasi secara **feature-first**.

```
lib/
├── app/                    # Entry point & navigasi global
├── core/                   # Error handling lintas fitur
├── features/
│   ├── movies/
│   │   ├── data/           # DataSource, Model, RepositoryImpl
│   │   ├── domain/         # Entity, Repository (abstract), UseCase
│   │   └── presentation/   # BLoC, Pages, Widgets
│   └── favorites/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── injection_container.dart
```

### Alasan memilih arsitektur ini

| Keputusan | Alasan |
|-----------|--------|
| **Clean Architecture** | Memisahkan logika bisnis (domain) dari detail implementasi (data/presentation) sehingga mudah diganti dan diuji secara terisolasi. |
| **Feature-first folder** | Skala lebih baik saat fitur bertambah; semua hal yang berkaitan dengan satu fitur berada di satu tempat. |
| **Abstract interface untuk repository & data source** | Domain layer tidak bergantung pada implementasi konkret — memudahkan mock saat testing. |
| **GetIt sebagai service locator** | Ringan, tidak membutuhkan code generation, dan sudah cukup untuk skala proyek ini. |

### Alur data (contoh: load daftar film)

```
MovieListPage
  → MovieListBloc (event: MovieListStarted)
    → GetMoviesPage (use case)
      → MovieRepository (abstract)
        → MovieRepositoryImpl
          → MovieLocalDataSourceImpl (baca assets JSON)
```

---

## 3. State Management

**flutter_bloc (BLoC pattern)** dipilih sebagai satu-satunya state management.

### Tiga BLoC yang digunakan

| BLoC | Tanggung jawab |
|------|----------------|
| `MovieListBloc` | Pagination film (15 item/halaman), pull-to-refresh, infinite scroll |
| `SearchBloc` | Pencarian dengan debounce 300 ms + `switchMap` untuk membatalkan query lama |
| `FavoritesBloc` | Load & toggle favorit; menggunakan `SharedPreferences` melalui use case |

### Alasan memilih BLoC

- **Predictable state flow** — setiap perubahan state dipicu oleh event yang eksplisit, sehingga mudah dilacak dan di-debug.
- **Testability** — BLoC murni Dart tanpa ketergantungan UI; dapat diuji dengan `bloc_test` tanpa Flutter.
- **Debounce & switchMap bawaan** — `stream_transform` memudahkan implementasi pencarian reaktif tanpa boilerplate tambahan.
- **Separation of concerns** — BLoC hanya mengonsumsi use case, tidak menyentuh layer data langsung.

---

## 4. Keterbatasan dan Trade-off

### Data lokal saja
Seluruh data film berasal dari `assets/data/movies.json`. Tidak ada integrasi API jaringan. Ini mempercepat pengembangan, namun data tidak bisa diperbarui tanpa merilis ulang aplikasi.

### Pencarian case-insensitive sederhana
Pencarian hanya mencocokkan `title.toLowerCase().contains(query)`. Pencarian berdasarkan genre, aktor, atau tahun belum didukung.

### Cache in-memory untuk data film
`MovieLocalDataSourceImpl` menggunakan static field `_cache` sebagai cache. Ini efisien untuk satu sesi, tetapi cache tidak di-invalidate — relevan jika data JSON suatu saat diperbarui di runtime.

### Tidak ada error boundary khusus
Error dari data source langsung di-emit sebagai state error di BLoC. Untuk produksi, sebaiknya ada error typing yang lebih granular (misalnya menggunakan `Either` dari `dartz` atau `Result` type).

### FavoritesBloc melakukan dua operasi berurutan saat toggle
Setelah `toggleFavorite`, BLoC langsung memanggil `getFavorites` untuk me-refresh daftar. Ini menambah satu I/O call, meskipun pada `SharedPreferences` lokal dampaknya tidak signifikan.

### Unit test belum mencakup BLoC layer
Test yang ditulis berfokus pada repository dan use case. BLoC layer belum memiliki test — idealnya menggunakan package `bloc_test`.

---

## 5. Perkiraan Waktu Pengerjaan

| Tahap | Estimasi |
|-------|----------|
| Setup project & Clean Architecture scaffold | 1 jam |
| Feature movies (data source, repo, use case, BLoC, UI) | 3 jam |
| Feature favorites (data source, repo, use case, BLoC, UI) | 2 jam |
| Search dengan debounce & pagination infinite scroll | 1.5 jam |
| Unit testing (repository + use case) | 1 jam |
| README & finishing | 0.5 jam |
| **Total** | **~9 jam** |

---

## 6. Penggunaan AI Tools

| Tool | Bagian yang dibantu |
|------|---------------------|
| **Claude Code (claude-sonnet-4-6)** | Penulisan unit test di layer repository (`FavoritesRepositoryImpl`) dan use case (`GetFavorites`, `ToggleFavorite`) menggunakan `mocktail`. Juga membantu menulis README ini. |

Seluruh logika bisnis, arsitektur, struktur folder, dan implementasi fitur ditulis secara mandiri. AI digunakan sebagai akselerator untuk bagian boilerplate test dan dokumentasi.
