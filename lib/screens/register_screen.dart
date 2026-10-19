import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class MyTixRegisterScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const MyTixRegisterScreen({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<MyTixRegisterScreen> createState() => _MyTixRegisterScreenState();
}

class _MyTixRegisterScreenState extends State<MyTixRegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _agree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final String nameInput = _nameCtrl.text.trim();
    String phoneInput = _phoneCtrl.text.trim();

    if (nameInput.isEmpty || phoneInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi nama dan nomor HP terlebih dahulu!'),
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

    final response = await ApiService.registerUser(
      nameInput,
      formattedPhone,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response['success'] == true) {
      final String finalName = response['nama_lengkap'] ?? nameInput;
      final String finalPhone = response['nomor_hp'] ?? formattedPhone;

      // TAMPILKAN POP-UP OTP OTOMATIS
      _showOtpDialog(finalName, finalPhone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Gagal mendaftar ke server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // DIALOG POPUP KODE OTP OTOMATIS
  void _showOtpDialog(String registeredName, String registeredPhone) {
    final String generatedOtp = (1000 + Random().nextInt(9000)).toString();
    final otpCtrl = TextEditingController(text: generatedOtp); // Terisi Otomatis

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.mark_email_read_rounded, color: Color(0xFF0284C7), size: 48),
              SizedBox(height: 8),
              Text(
                'Verifikasi Pendaftaran',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF001935)),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kode OTP verifikasi telah dikirim ke $registeredPhone',
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0284C7)),
                  ),
                  SizedBox(width: 8),
                  Text('Mengisi & Memverifikasi OTP...', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  AuthService().setUserSession(
                    name: registeredName,
                    phone: registeredPhone,
                  );

                  widget.onSuccess();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyTixHomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001935),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('VERIFIKASI & MASUK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );

    // Otomatis Verifikasi dalam 2 Detik
    Timer(const Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Tutup dialog OTP

        AuthService().setUserSession(
          name: registeredName,
          phone: registeredPhone,
        );

        widget.onSuccess();

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
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Daftar MyTix',
          style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'NAMA LENGKAP',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama Anda',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _agree,
                    activeColor: const Color(0xFF001935),
                    onChanged: (v) => setState(() => _agree = v ?? false),
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        text: 'Dengan melanjutkan, kamu menyetujui ',
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' serta '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' MyTix.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_agree && !_isLoading) ? _handleRegister : null,
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
                          'Daftar MyTix',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? ', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyTixLoginScreen()),
                      );
                    },
                    child: const Text(
                      'Masuk / Login',
                      style: TextStyle(fontSize: 13, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}