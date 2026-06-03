import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../models/berita_model.dart';

class ApiService {
  // =========================
  // BASE URL
  // =========================

  final String baseUrl = 'http://localhost:8080/api';
  final String uploadBaseUrl = 'http://localhost:8080/uploads';

  // =========================
  // GET ALL BERITA
  // =========================

  Future<List<Berita>> getBerita() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita'),
      );

      print('GET BERITA STATUS: ${response.statusCode}');
      print('GET BERITA BODY: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse.map((data) => Berita.fromJson(data)).toList();
      } else {
        throw Exception(
          'Gagal memuat berita',
        );
      }
    } catch (e) {
      print('ERROR GET BERITA: $e');

      throw Exception(
        'Tidak dapat memuat berita',
      );
    }
  }

  // =========================
  // GET BERITA BY ID
  // =========================

  Future<Berita> getBeritaById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita/$id'),
      );

      print('GET DETAIL STATUS: ${response.statusCode}');
      print('GET DETAIL BODY: ${response.body}');

      if (response.statusCode == 200) {
        return Berita.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception(
          'Gagal memuat detail berita',
        );
      }
    } catch (e) {
      print('ERROR GET DETAIL: $e');

      throw Exception(
        'Tidak dapat memuat detail berita',
      );
    }
  }

  // =========================
  // CREATE BERITA
  // =========================

  Future<Map<String, dynamic>> createBerita(
    Berita berita,
  ) async {
    try {
      print('CREATE DATA: ${berita.toJson()}');

      final response = await http.post(
        Uri.parse('$baseUrl/berita'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          berita.toJson(),
        ),
      );

      print('CREATE STATUS: ${response.statusCode}');
      print('CREATE BODY: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal membuat berita',
        );
      }
    } catch (e) {
      print('ERROR CREATE: $e');

      throw Exception(
        'Tidak dapat membuat berita',
      );
    }
  }

  // =========================
  // UPDATE BERITA
  // =========================

  Future<Map<String, dynamic>> updateBerita(
    int id,
    Berita berita,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/berita/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          berita.toJson(),
        ),
      );

      print('UPDATE STATUS: ${response.statusCode}');
      print('UPDATE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal update berita',
        );
      }
    } catch (e) {
      print('ERROR UPDATE: $e');

      throw Exception(
        'Tidak dapat update berita',
      );
    }
  }

  // =========================
  // DELETE BERITA
  // =========================

  Future<Map<String, dynamic>> deleteBerita(
    int id,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/berita/$id'),
      );

      print('DELETE STATUS: ${response.statusCode}');
      print('DELETE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal menghapus berita',
        );
      }
    } catch (e) {
      print('ERROR DELETE: $e');

      throw Exception(
        'Tidak dapat menghapus berita',
      );
    }
  }

  // =========================
  // UPLOAD GAMBAR
  // =========================

  Future<String> uploadGambar(
    XFile imageFile,
  ) async {
    try {
      print('Uploading image: ${imageFile.path}');
      print('Image name: ${imageFile.name}');

      // =========================
      // READ BYTES
      // =========================

      final bytes = await imageFile.readAsBytes();

      print('Image bytes: ${bytes.length}');

      // =========================
      // VALIDASI SIZE
      // =========================

      if (bytes.length > 5 * 1024 * 1024) {
        throw Exception(
          'Ukuran file maksimal 5MB',
        );
      }

      // =========================
      // EXTENSION
      // =========================

      final extension = imageFile.name.split('.').last.toLowerCase();

      print('Extension: $extension');

      // =========================
      // VALIDASI EXTENSION
      // =========================

      if (![
        'jpg',
        'jpeg',
        'png',
        'gif',
      ].contains(extension)) {
        throw Exception(
          'Format gambar tidak didukung',
        );
      }

      // =========================
      // MULTIPART REQUEST
      // =========================

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      );

      // =========================
      // FILE
      // =========================

      var multipartFile = http.MultipartFile.fromBytes(
        'gambar',
        bytes,
        filename: imageFile.name,
        contentType: MediaType(
          'image',
          extension == 'jpg' ? 'jpeg' : extension,
        ),
      );

      request.files.add(
        multipartFile,
      );

      // =========================
      // HEADERS
      // =========================

      request.headers.addAll({
        'Accept': 'application/json',
      });

      // =========================
      // SEND
      // =========================

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      print('UPLOAD STATUS: ${response.statusCode}');
      print('UPLOAD BODY: ${response.body}');

      // =========================
      // SUCCESS
      // =========================

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          return responseData['data']['file_name'];
        } else {
          throw Exception(
            responseData['message'] ?? 'Upload gagal',
          );
        }
      } else {
        throw Exception(
          'Upload gagal: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('ERROR UPLOAD: $e');

      throw Exception(
        'Tidak dapat upload gambar',
      );
    }
  }
Future<List<Berita>> searchBerita(
  String keyword,
) async {
  try {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/berita?keyword=$keyword',
      ),
    );

    print('SEARCH STATUS: ${response.statusCode}');
    print('SEARCH BODY: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse.map((data) => Berita.fromJson(data)).toList();
    } else {
      throw Exception(
        'Gagal mencari berita',
      );
    }
  } catch (e) {
    print('ERROR SEARCH: $e');

    throw Exception(
      'Tidak dapat mencari berita',
    );
  }
}
}

