import 'package:flutter/material.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          _itemNotif(
            icon: Icons.article,
            warna: Colors.blue.shade100,
            judul: "Berita Baru Ditambahkan",
            isi: "Berita terbaru berhasil dipublikasikan",
            waktu: "2 menit lalu",
          ),

          _itemNotif(
            icon: Icons.edit,
            warna: Colors.green.shade100,
            judul: "Berita Diperbarui",
            isi: "Artikel telah diperbarui",
            waktu: "10 menit lalu",
          ),

          _itemNotif(
            icon: Icons.info,
            warna: Colors.orange.shade100,
            judul: "Selamat Datang",
            isi: "Selamat menggunakan aplikasi berita",
            waktu: "Hari ini",
          ),
        ],
      ),
    );
  }

  Widget _itemNotif({
    required IconData icon,
    required Color warna,
    required String judul,
    required String isi,
    required String waktu,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: warna,
          child: Icon(icon),
        ),

        title: Text(
          judul,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(isi),
            const SizedBox(height: 8),
            Text(
              waktu,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
