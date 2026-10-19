import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Mengatur URL dasar secara otomatis sesuai platform pengujian
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost/mytix_api'; // Web Chrome / Localhost
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/mytix_api'; // Emulator Android
    } else {
      return 'http://localhost/mytix_api'; // Windows Desktop / iOS
    }
  }

  /// Registrasi Pengguna Baru ke Database phpMyAdmin (tabel: users)
  static Future<Map<String, dynamic>> registerUser(String namaLengkap, String nomorHp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama_lengkap': namaLengkap,
          'nomor_hp': nomorHp,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? true,
          'message': data['message'] ?? 'Berhasil terdaftar di database!',
          'nama_lengkap': data['nama_lengkap'] ?? namaLengkap,
          'nomor_hp': data['nomor_hp'] ?? nomorHp,
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mendaftar (Status Server: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal terhubung ke API Server lokal: ${e.toString()}',
      };
    }
  }

  /// Mengambil Profil Pengguna Paling Terbaru dari Database
  static Future<Map<String, dynamic>> getLatestProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_profile.php'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }
    } catch (e) {
      debugPrint('Error getLatestProfile: $e');
    }
    return {'status': 'error', 'message': 'Gagal memuat profil'};
  }

  /// Mengambil Daftar Film Berdasarkan Bioskop
  static Future<List<dynamic>> getMovies(String cinema) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_movies.php?cinema=$cinema'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
    } catch (e) {
      debugPrint('Error getMovies: $e');
    }
    return [];
  }
}