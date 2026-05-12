📱 Flutter News CMS (API + Flutter + CodeIgniter 4)
📌 Deskripsi Project

Flutter News CMS adalah aplikasi manajemen berita sederhana berbasis Flutter (frontend mobile/web) yang terhubung dengan REST API menggunakan CodeIgniter 4 (backend).

Aplikasi ini memungkinkan pengguna untuk melakukan operasi CRUD (Create, Read, Update, Delete) berita serta upload gambar.

Project ini dibuat sebagai latihan integrasi Flutter + API + Database MySQL.

⚙️ Fitur Utama
📄 Menampilkan daftar berita dari API
🔍 Detail berita
➕ Tambah berita baru
✏️ Edit berita
❌ Hapus berita
🖼️ Upload gambar berita
🌐 Integrasi REST API (CodeIgniter 4)
📱 Support Flutter Android & Web
🧱 Tech Stack
Frontend
Flutter
Provider (State Management)
HTTP Package
Image Picker
Backend
CodeIgniter 4
REST API
MySQL Database
File Upload System
📁 Struktur Project
ci-berita/
│
├── app/
│   ├── Controllers/
│   │   └── Api.php
│   ├── Models/
│   └── Config/
│
├── public/
│   └── uploads/        # folder gambar
│
├── flutter_berita_app/
│   ├── lib/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── screens/
│
└── database/
    └── db_news.sql
🚀 Cara Menjalankan Project
1. Clone Repository
git clone https://github.com/username/flutter-news-cms.git
2. Backend (CodeIgniter 4)
cd ci-berita
composer install
php spark serve

Akses:

http://localhost:8080
3. Database
Import file:
db_news.sql
Setting database di:
app/Config/Database.php
4. Flutter App
cd flutter_berita_app
flutter pub get
flutter run
🌐 Konfigurasi API

Pastikan base URL di Flutter sesuai backend:

final String baseUrl = 'http://localhost:8080/api';
final String uploadBaseUrl = 'http://localhost:8080/uploads';
📸 Screenshot (Opsional tapi disarankan)

Tambahkan screenshot di sini:

/assets/screenshots/home.png
/assets/screenshots/detail.png
/assets/screenshots/form.png
⚠️ Catatan Penting
Jika pakai emulator Android → gunakan 10.0.2.2
Jika pakai HP → gunakan IP komputer (misal 192.168.x.x)
Folder uploads harus writable (permission 777 jika Linux/Mac)
🧠 Insight Project

Project ini melatih:

Integrasi Flutter dengan REST API
Manajemen state menggunakan Provider
Upload file dari mobile/web ke server
Struktur MVC di CodeIgniter 4
Debugging error API & CORS
📜 License

MIT License

👨‍💻 Author

Dibuat sebagai project pembelajaran Flutter + API Integration
