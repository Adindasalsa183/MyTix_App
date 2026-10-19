import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Singleton Pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Data User Aktif
  String _currentUserName = "";
  String _currentUserPhone = "";

  String get name => _currentUserName.isNotEmpty ? _currentUserName : "User MyTix";
  String get phone => _currentUserPhone.isNotEmpty ? _currentUserPhone : "081234567890";

  // Menyimpan Sesi Pengguna secara Realtime
  void setUserSession({required String name, required String phone}) {
    _currentUserName = name;
    _currentUserPhone = phone;
  }

  // Mengambil Data Profil Terbaru dari Backend PHP
  Future<void> fetchLatestProfile() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost/mytix_api/get_profile.php"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _currentUserName = data['name'] ?? _currentUserName;
          _currentUserPhone = data['phone'] ?? _currentUserPhone;
        }
      }
    } catch (_) {}
  }
}