import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/berita_model.dart';
import '../providers/berita_provider.dart';
import '../services/api_service.dart';

class TambahEditBeritaScreen extends StatefulWidget {
  final Berita? berita;
  final bool isEditing;

  const TambahEditBeritaScreen({
    Key? key,
    this.berita,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<TambahEditBeritaScreen> createState() =>
      _TambahEditBeritaScreenState();
}

class _TambahEditBeritaScreenState
    extends State<TambahEditBeritaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _judulController = TextEditingController();
  final _isiController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  bool _isLoading = false;
  bool _isValidating = false;

  String? _existingImage;

  @override
  void initState() {
    super.initState();

    if (widget.berita != null) {
      _judulController.text = widget.berita!.judul;
      _isiController.text = widget.berita!.isi;

      if (widget.berita!.gambar != null &&
          widget.berita!.gambar!.isNotEmpty) {
        _existingImage = widget.berita!.gambar;
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });

        print('Image selected: ${pickedFile.path}');
      }
    } catch (e) {
      print('Error picking image: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
      _existingImage = null;
    });
  }

  Future<void> _simpanBerita() async {
    if (_isValidating) return;

    setState(() {
      _isValidating = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isValidating = false;
      });

      return;
    }

    setState(() {
      _isLoading = true;
      _isValidating = false;
    });

    final apiService = ApiService();

    String? gambarNama;

    try {
      // Upload gambar jika ada
      if (_imageFile != null) {
        try {
          gambarNama =
              await apiService.uploadGambar(_imageFile!);

          print('Gambar berhasil diupload: $gambarNama');
        } catch (e) {
          print('Upload gagal: $e');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload gambar gagal: $e'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      final berita = Berita(
        id: widget.isEditing ? widget.berita!.id : 0,
        judul: _judulController.text,
        isi: _isiController.text,
        gambar: gambarNama ?? _existingImage,
      );

      if (widget.isEditing) {
        await Provider.of<BeritaProvider>(
          context,
          listen: false,
        ).updateBerita(widget.berita!.id, berita);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berita berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await Provider.of<BeritaProvider>(
          context,
          listen: false,
        ).createBerita(berita);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berita berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      print('Error save berita: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan berita: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? 'Edit Berita'
              : 'Tambah Berita',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    child: kIsWeb
                                        ? Image.network(
                                            _imageFile!.path,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            _imageFile!.path,
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : _existingImage != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(
                                                12),
                                        child: Image.network(
                                          '${apiService.uploadBaseUrl}/$_existingImage',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context,
                                                  error,
                                                  stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 60,
                                        ),
                                      ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: const Icon(
                                      Icons.photo_library),
                                  label:
                                      const Text('Pilih Gambar'),
                                ),
                              ),

                              const SizedBox(width: 12),

                              if (_imageFile != null ||
                                  _existingImage != null)
                                ElevatedButton.icon(
                                  onPressed: _removeImage,
                                  icon:
                                      const Icon(Icons.delete),
                                  label: const Text('Hapus'),
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor:
                                        Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Berita',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _isiController,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'Isi Berita',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi berita wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _simpanBerita,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      widget.isEditing
                          ? 'UPDATE BERITA'
                          : 'SIMPAN BERITA',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
