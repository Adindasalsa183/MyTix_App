# MyTix

Aplikasi pemesanan tiket bioskop berbasis Flutter.

**Aplikasi Asli:** TIX ID
**Nama Plesetan:** MyTix

**Kelas:** S1 Sistem Informasi 2024F, Kelompok 2

## Anggota Kelompok

| No | Nama | NIM |
|----|------|-----|
| 1 | Fariha Zain | 24051214192 |
| 2 | Adinda Salsabila Putri | 24051214183 |
| 3 | Rifa Tabina Trinita | 24051214199 |
| 4 | M. Affan Malakaini | 24051214177 |

## Teknologi

- **Frontend:** Flutter (Dart SDK `>=3.0.0 <4.0.0`)
- **Backend:** PHP (REST API sederhana, folder `mytix_api`)
- **Database:** MySQL (`mytix_db`)
- **Package utama:** `http`, `shared_preferences`, `url_launcher`

## Panduan Menjalankan Proyek (Getting Started)

Ikuti langkah berikut untuk menjalankan MyTix di lingkungan lokal (*development*).

### Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (cek dengan `flutter doctor`)
- [Laragon](https://laragon.org/) atau [XAMPP](https://www.apachefriends.org/)
- Git
- Chrome (untuk Web) atau Android Emulator (untuk Android)

### 1. Persiapan Backend & Database (`MyTix_API`)

1. **Jalankan web server lokal**
   - Buka **Laragon** atau **XAMPP**, lalu jalankan layanan **Apache** dan **MySQL**.
2. **Import database**
   - Buka phpMyAdmin di `http://localhost/phpmyadmin`.
   - Buat database baru bernama `mytix_db`.
   - Pilih tab **Import**, pilih file `mytix_db.sql` dari repositori `MyTix_API`, lalu klik **Go / Import**.
3. **Pasang API**
   - Salin folder API ke `htdocs` (XAMPP) atau `www` (Laragon) dengan nama `mytix_api`.
   - Tes endpoint di browser: `http://localhost/mytix_api/get_profile.php`.

### 2. Persiapan Frontend Flutter (`MyTix_App`)

1. **Clone repositori**
```bash
   git clone https://github.com/Adindasalsa183/MyTix_App.git
   cd MyTix_App
```
2. **Install dependensi**
```bash
   flutter pub get
```
3. **Jalankan aplikasi** (pastikan Apache dan MySQL sudah menyala)
```bash
   # Web (Chrome)
   flutter run -d chrome

   # Android Emulator
   flutter run -d emulator-5554

   # Windows Desktop
   flutter run -d windows
```
   Gunakan `flutter devices` untuk melihat daftar perangkat yang tersedia.

### Alamat API per Platform

Base URL diatur otomatis di `lib/services/api_service.dart`:

| Platform | Base URL |
|----------|----------|
| Web / Windows / iOS | `http://localhost/mytix_api` |
| Android Emulator | `http://10.0.2.2/mytix_api` |

> Kalau menjalankan di HP fisik, ganti base URL dengan IP laptop kamu
> (contoh `http://192.168.1.10/mytix_api`) dan pastikan HP dan laptop ada di jaringan Wi-Fi yang sama.

## Struktur Folder

```
MyTix_App/
├── lib/
│   ├── main.dart
│   ├── screens/    # Halaman aplikasi (login, home, pilih kursi, pembayaran, dll.)
│   └── services/   # api_service, auth_service, notification_service
├── assets/images/  # Poster film, banner, dan gambar menu
├── android/  web/  windows/
└── pubspec.yaml
```