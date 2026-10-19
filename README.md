Aplikasi Asli : TIX ID 
Nama Plesetan : MyTix

Kelas : S1 Sistem Informasi 2024F Kelompok 2 :

1. Fariha Zain (24051214192)
2. Adinda Salsabila Putri (24051214183)
3. Rifa Tabina Trinita (24051214199)
4. M. Affan Malakaini (24051214177)

Panduan Menjalankan Proyek (Getting Started)

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi MyTix di lingkungan lokal (*development*).

### 1. Persiapan Backend & Database (`MyTix_API`)

1. **Jalankan Web Server Lokal**:
   - Buka aplikasi **Laragon** atau **XAMPP**, lalu jalankan layanan **Apache** dan **MySQL**.
2. **Import Database**:
   - Buka phpMyAdmin di browser (`http://localhost/phpmyadmin`).
   - Buat database baru dengan nama `mytix_db`.
   - Pilih tab **Import**, lalu pilih file `mytix_db.sql` yang berada di repositori `MyTix_API`.
   - Klik **Go / Import** hingga seluruh tabel berhasil dibuat.
3. **Konfigurasi API**:
   - Pastikan folder API berada di dalam direktori `htdocs` (XAMPP) atau `www` (Laragon) dengan nama `mytix_api`.
   - Jalankan uji coba endpoint di browser: `http://localhost/mytix_api/get_profile.php`.

---

### 2. Persiapan Frontend Flutter (`MyTix_App`)

1. **Clone Repositori**:
   ```bash
   git clone [https://github.com/Adindasalsa183/MyTix_App.git](https://github.com/Adindasalsa183/MyTix_App.git)
   cd MyTix_App
