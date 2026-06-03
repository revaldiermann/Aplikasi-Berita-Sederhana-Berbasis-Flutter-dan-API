import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifikasi_screen.dart';

import '../models/berita_model.dart';
import '../providers/berita_provider.dart';
import '../widgets/berita_card.dart';

import 'berita_detail_screen.dart';
import 'tambah_edit_berita_screen.dart';

class BeritaListScreen extends StatefulWidget {
  const BeritaListScreen({Key? key}) : super(key: key);

  @override
  State<BeritaListScreen> createState() => _BeritaListScreenState();
}

class _BeritaListScreenState extends State<BeritaListScreen> {
  // ================================
  // CONTROLLER
  // ================================

  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // ================================
  // STATE
  // ================================

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();

    // Ambil data berita pertama kali
    Future.microtask(() {
      Provider.of<BeritaProvider>(
        context,
        listen: false,
      ).fetchBerita();
    });

    // Listener scroll
    _scrollController.addListener(() {
      if (_scrollController.offset > 20) {
        setState(() {
          _isScrolled = true;
        });
      } else {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ================================
  // SEARCH BERITA
  // ================================

  Future<void> _searchBerita(
    String keyword,
  ) async {
    final provider = Provider.of<BeritaProvider>(
      context,
      listen: false,
    );

    if (keyword.trim().isEmpty) {
      provider.fetchBerita();
    } else {
      provider.searchBerita(keyword);
    }
  }

  // ================================
  // NAVIGASI TAMBAH BERITA
  // ================================

  Future<void> _tambahBerita() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahEditBeritaScreen(),
      ),
    );

    // Refresh setelah tambah berita
    if (result == true) {
      Provider.of<BeritaProvider>(
        context,
        listen: false,
      ).fetchBerita();
    }
  }

  // ================================
  // NAVIGASI EDIT BERITA
  // ================================

  Future<void> _editBerita(
    Berita berita,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahEditBeritaScreen(
          berita: berita,
          isEditing: true,
        ),
      ),
    );

    // Refresh setelah edit berita
    if (result == true) {
      Provider.of<BeritaProvider>(
        context,
        listen: false,
      ).fetchBerita();
    }
  }

  // ================================
  // HAPUS BERITA
  // ================================

  Future<void> _hapusBerita(
    int id,
  ) async {
    await Provider.of<BeritaProvider>(
      context,
      listen: false,
    ).deleteBerita(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berita berhasil dihapus"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provider digunakan untuk mengambil
    // state/data berita dari API
    final provider = Provider.of<BeritaProvider>(context);

    return Scaffold(
      // =================================
      // WARNA DASAR BACKGROUND
      // =================================

      backgroundColor: const Color(0xffF5F7FA),

      // =================================
      // APP BAR MODERN
      // =================================

      appBar: AppBar(
        elevation: _isScrolled ? 2 : 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          children: [
            // Logo/icon aplikasi
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.newspaper,
                color: Colors.blue.shade700,
              ),
            ),

            const SizedBox(width: 12),

            // Judul aplikasi
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "News Portal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Berita terkini hari ini",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),


        actions: [
          // NOTIFIKASI
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: "Notifikasi",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotifikasiScreen(),
                    ),
                  );
                },
              ),

              // Badge jumlah notifikasi
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // REFRESH
          IconButton(
            onPressed: () {
              provider.fetchBerita();
            },
            icon: const Icon(Icons.refresh),
          ),

          const SizedBox(width: 8),
        ],


      ),

      // =================================
      // BODY
      // =================================

      body: Column(
        children: [
          // =================================
          // HEADER + SEARCH
          // =================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.blue.shade400,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADLINE
                const Text(
                  "Breaking News 🔥",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Temukan berita terbaru dan informasi menarik setiap hari.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                // =================================
                // SEARCH BAR MODERN
                // =================================

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchBerita,
                    decoration: InputDecoration(
                      hintText: "Cari berita...",
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();

                                provider.fetchBerita();

                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // =================================
          // TITLE SECTION
          // =================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Berita Terbaru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${provider.beritaList.length} Artikel",
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // =================================
          // LIST BERITA
          // =================================

          Expanded(
            child: provider.isLoading

                // =============================
                // LOADING
                // =============================

                ? const Center(
                    child: CircularProgressIndicator(),
                  )

                // =============================
                // ERROR
                // =============================

                : provider.error != null
                    ? Center(
                        child: Text(
                          provider.error!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )

                    // =============================
                    // EMPTY DATA
                    // =============================

                    : provider.beritaList.isEmpty
                        ? const Center(
                            child: Text(
                              "Berita tidak ditemukan",
                            ),
                          )

                        // =============================
                        // LISTVIEW BERITA
                        // =============================

                        : RefreshIndicator(
                            onRefresh: () async {
                              provider.fetchBerita();
                            },
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 100,
                              ),
                              itemCount: provider.beritaList.length,
                              itemBuilder: (context, index) {
                                // Ambil data berita
                                final berita = provider.beritaList[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16,
                                  ),
                                  child: BeritaCard(
                                    // Data berita
                                    berita: berita,

                                    // Klik detail
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BeritaDetailScreen(
                                            id: berita.id,
                                          ),
                                        ),
                                      );
                                    },

                                    // Klik edit
                                    onEdit: () {
                                      _editBerita(berita);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),

      // =================================
      // FLOATING BUTTON
      // =================================

      floatingActionButton: FloatingActionButton.extended(
        // Tombol tambah berita
        onPressed: _tambahBerita,

        backgroundColor: Colors.blue.shade700,

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: const Text(
          "Tambah",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =================================
      // BOTTOM NAVIGATION BAR
      // =================================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          // Menu Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          // Menu Trending
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Trending",
          ),

          // Menu Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
