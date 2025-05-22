# Eskulku - Aplikasi Manajemen Ekstrakurikuler

Eskulku adalah aplikasi manajemen ekstrakurikuler untuk sekolah tingkat SMP. Aplikasi ini memudahkan sekolah dalam mengatur dan mendata kegiatan ekstrakurikuler, serta membantu siswa untuk mendaftar, mengikuti, dan memantau kegiatan ekstrakurikuler dengan mudah.

## Fitur Utama

### Untuk Sekolah
- Pendaftaran dan login menggunakan email dan password
- Mendapatkan kode unik sekolah (Short ID) untuk dibagikan kepada siswa
- Mengelola ekstrakurikuler (tambah, edit, hapus)
- Melihat daftar siswa yang mendaftar di setiap ekstrakurikuler

### Untuk Siswa
- Pendaftaran menggunakan kode sekolah, nama, email, dan password
- Login untuk melihat dan mendaftar ke ekstrakurikuler yang tersedia
- Melihat jadwal, kuota, dan status pendaftaran ekstrakurikuler

## Teknologi yang Digunakan

- Flutter (Frontend)
- Supabase (Backend - Auth, Database, Storage)

## Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terinstal
2. Clone repositori ini
3. Update file `lib/core/constants/app_constants.dart` dengan URL dan API Key Supabase Anda
4. Jalankan perintah berikut:

```bash
flutter pub get
flutter run
```

## Struktur Database

Database terdiri dari 4 tabel utama:
- `schools` - Data sekolah
- `students` - Data siswa
- `extracurriculars` - Data ekstrakurikuler
- `registrations` - Data pendaftaran siswa ke ekstrakurikuler

## Kontribusi

Kontribusi selalu diterima. Silakan buat pull request atau laporkan issue jika menemukan bug atau memiliki ide untuk pengembangan aplikasi.

## Lisensi

[MIT License](LICENSE)
