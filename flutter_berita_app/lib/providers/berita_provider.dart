import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/berita_model.dart';
import '../services/api_service.dart';

class BeritaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Berita> _beritaList = [];
  Berita? _selectedBerita;

  bool _isLoading = false;
  String? _error;

  List<Berita> get beritaList => _beritaList;
  Berita? get selectedBerita => _selectedBerita;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // =========================
  // GET ALL BERITA
  // =========================
  Future<void> fetchBerita() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _beritaList = await _apiService.getBerita();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // =========================
  // GET DETAIL BERITA
  // =========================
  Future<void> fetchBeritaById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedBerita = await _apiService.getBeritaById(id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // =========================
  // CREATE BERITA
  // =========================
  Future<void> createBerita(Berita berita) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.createBerita(berita);

      // refresh data
      await fetchBerita();
    } catch (e) {
      _error = e.toString();

      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // UPDATE BERITA
  // =========================
  Future<void> updateBerita(int id, Berita berita) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.updateBerita(id, berita);

      // refresh data
      await fetchBerita();
    } catch (e) {
      _error = e.toString();

      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // DELETE BERITA
  // =========================
  Future<void> deleteBerita(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteBerita(id);

      _beritaList.removeWhere((berita) => berita.id == id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // =========================
  // UPLOAD GAMBAR
  // =========================
  Future<String> uploadGambar(XFile imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fileName = await _apiService.uploadGambar(imageFile);

      _isLoading = false;
      notifyListeners();

      return fileName;
    } catch (e) {
      _error = e.toString();

      _isLoading = false;
      notifyListeners();

      throw Exception('Gagal upload gambar: $e');
    }
  }

  Future<void> searchBerita(String keyword) async {
    _isLoading = true;
    notifyListeners();

    try {
      _beritaList = await _apiService.searchBerita(keyword);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
