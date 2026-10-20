import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class MyTixLoginScreen extends StatefulWidget {
  const MyTixLoginScreen({super.key});

  @override
  State<MyTixLoginScreen> createState() => _MyTixLoginScreenState();
}

class _MyTixLoginScreenState extends State<MyTixLoginScreen> {
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    String phoneInput = _phoneCtrl.text.trim();

    if (phoneInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap masukkan nomor HP terdaftar!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    String formattedPhone = phoneInput;
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '+62${formattedPhone.substring(1)}';
    } else if (!formattedPhone.startsWith('+62')) {
      formattedPhone = '+62$formattedPhone';
    }

    final String host = kIsWeb ? 'localhost' : '10.0.2.2';
    final String apiUrl = "http://$host/mytix_api/get_profile.php?nomor_hp=${Uri.encodeComponent(formattedPhone)}";

    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(
        const Duration(seconds: 10),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success' || resData['success'] == true) {
          final data = resData['data'] ?? resData;
          final String fetchedName = data['nama_lengkap'] ?? data['name'] ?? 'User MyTix';

          _showOtpDialog(fetchedName, formattedPhone);
          return;
        }
      }
    } catch (e) {
      debugPrint("Error login: $e");
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nomor HP belum terdaftar atau terjadi kesalahan koneksi.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showOtpDialog(String fetchedName, String formattedPhone) {
    final String generatedOtp = (1000 + Random().nextInt(9000)).toString();
    final otpCtrl = TextEditingController(text: generatedOtp);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Column(
                children: const [
                  Icon(Icons.mark_email_read_rounded, color: Color(0xFF0284C7), size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Verifikasi Kode OTP',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF001935)),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kode OTP telah dikirimkan ke $formattedPhone',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
                    ),
                    child: TextField(
                      controller: otpCtrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                        color: Color(0xFF001935),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0000',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0284C7)),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Mengisi & Memverifikasi OTP...',
                        style: TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);

                      AuthService().setUserSession(
                        name: fetchedName,
                        phone: formattedPhone,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selamat datang kembali, $fetchedName!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyTixHomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001935),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('VERIFIKASI SEKARANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    Timer(const Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);

        AuthService().setUserSession(
          name: fetchedName,
          phone: formattedPhone,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selamat datang kembali, $fetchedName!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyTixHomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF001935)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Masuk Ke MyTix',
          style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NOMOR HANDPHONE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: const Text(
                    '+62',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '81234567890',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001935),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Masuk',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Belum punya akun? ', style: TextStyle(fontSize: 13, color: Colors.grey)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyTixRegisterScreen(
                          onBack: () => Navigator.pop(context),
                          onSuccess: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(fontSize: 13, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}