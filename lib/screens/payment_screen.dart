import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'my_tickets_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String dateText;
  final String timeText;
  final List<String> selectedSeats;
  final String paymentMethod;
  final int grandTotal;

  const PaymentScreen({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.dateText,
    required this.timeText,
    required this.selectedSeats,
    required this.paymentMethod,
    required this.grandTotal,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final AuthService _authService = AuthService();
  late Timer _timer;
  int _secondsLeft = 120;
  bool _isLoading = false;

  String _activeUserName = "User MyTix";
  String _activeUserPhone = "081234567890";

  @override
  void initState() {
    super.initState();
    _activeUserName = _authService.name.isNotEmpty ? _authService.name : "User MyTix";
    _activeUserPhone = _authService.phone.isNotEmpty ? _authService.phone : "081234567890";

    _fetchLatestUserFromDatabase();
    _startTimer();
  }

  Future<void> _fetchLatestUserFromDatabase() async {
    final String host = kIsWeb ? 'localhost' : '10.0.2.2';
    try {
      final response = await http.get(
        Uri.parse("http://$host/mytix_api/get_profile.php"),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              _activeUserName = data['name'] ?? _activeUserName;
              _activeUserPhone = data['phone'] ?? _activeUserPhone;
            });
            _authService.setUserSession(
              name: _activeUserName,
              phone: _activeUserPhone,
            );
          }
        }
      }
    } catch (_) {}
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _secondsLeft--;
          });
        }
      }
    });
  }

  String _formatTimer(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')} : ${sec.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Future<void> _submitPayment() async {
    setState(() => _isLoading = true);

    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final List<String> targetUrls = kIsWeb
        ? [
            "http://localhost/mytix_api/save_transaction.php?t=$timeStamp",
            "http://127.0.0.1/mytix_api/save_transaction.php?t=$timeStamp",
          ]
        : [
            "http://10.0.2.2/mytix_api/save_transaction.php?t=$timeStamp",
          ];

    final String methodText = widget.paymentMethod.toLowerCase() == 'qris' ? 'QRIS' : 'Transfer Bank (VA)';
    http.Response? response;

    for (String url in targetUrls) {
      try {
        final res = await http.post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "user_name": _activeUserName,
            "username": _activeUserName,
            "user_phone": _activeUserPhone,
            "phone": _activeUserPhone,
            "movie_title": widget.movieTitle,
            "cinema_name": widget.cinemaName,
            "date_text": widget.dateText,
            "time_text": widget.timeText,
            "seats": widget.selectedSeats.join(', '),
            "payment_method": methodText,
            "total_price": widget.grandTotal,
          }),
        ).timeout(const Duration(seconds: 5));

        if (res.statusCode == 200 && res.body.trim().isNotEmpty) {
          response = res;
          break;
        }
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response != null && response.statusCode == 200) {
      try {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success') {
          final String orderId = resData['order_id'] ?? 'TIX-MOV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

          // Tampilkan Modal Struk Sukses
          _showReceiptDialog(methodText, orderId);
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal Simpan Database: ${resData['message']}")),
          );
          return;
        }
      } catch (_) {}
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Gagal terhubung ke server database XAMPP Apache!"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showReceiptDialog(String methodText, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF001935)),
            ),
            const SizedBox(height: 4),
            Text(
              'Kode Pesanan: $orderId',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const Divider(height: 24, thickness: 1),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _receiptRow("Nama Pemesan", _activeUserName, isBold: true),
                  _receiptRow("No. Telepon", _activeUserPhone),
                  const Divider(height: 14),
                  _receiptRow("Film", widget.movieTitle),
                  _receiptRow("Bioskop", widget.cinemaName),
                  _receiptRow("Jadwal", "${widget.dateText} | ${widget.timeText}"),
                  _receiptRow("Kursi", widget.selectedSeats.join(', ')),
                  _receiptRow("Metode", methodText),
                  const Divider(height: 14),
                  _receiptRow("Total Pembayaran", _formatCurrency(widget.grandTotal), isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyTicketsScreen(initialCategoryIndex: 0),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001935),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'LIHAT TIKET SAYA',
                  style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? const Color(0xFF001935) : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isQris = widget.paymentMethod.toLowerCase() == 'qris';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF001935), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Menunggu Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFFFF1F2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Selesaikan pembayaran Anda dalam ', style: TextStyle(fontSize: 12, color: Color(0xFFE11D48))),
                Text(
                  _formatTimer(_secondsLeft),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (isQris) ...[
                    const Icon(Icons.qr_code_2, size: 40, color: Color(0xFF001935)),
                    const SizedBox(height: 8),
                    const Text(
                      'Pindai kode QR untuk membayar',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF001935)),
                    ),
                    const SizedBox(height: 4),
                    const Text('Gunakan aplikasi GoPay, OVO, DANA, ShopeePay, atau m-Banking', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=MYTIX_PAYMENT_${widget.grandTotal}',
                        width: 180,
                        height: 180,
                        errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_scanner, size: 180, color: Color(0xFF001935)),
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.account_balance, size: 40, color: Color(0xFF0284C7)),
                    const SizedBox(height: 8),
                    const Text(
                      'Nomor Virtual Account (VA)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF001935)),
                    ),
                    const SizedBox(height: 4),
                    const Text('Lakukan transfer ke nomor rekening berikut:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        children: [
                          Text('BCA VIRTUAL ACCOUNT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text(
                            '88012 8940 1928 301',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF001935), letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Tagihan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(_formatCurrency(widget.grandTotal), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_secondsLeft > 0 && !_isLoading) ? _submitPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001935),
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'SAYA SUDAH BAYAR',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFFBBF24), letterSpacing: 1),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}