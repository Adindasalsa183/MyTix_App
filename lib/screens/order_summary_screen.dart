import 'dart:async';
import 'package:flutter/material.dart';
import 'payment_screen.dart'; // Import halaman pembayaran

class OrderSummaryScreen extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String dateText;
  final String timeText;
  final List<String> selectedSeats;
  final int ticketPrice;

  const OrderSummaryScreen({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.dateText,
    required this.timeText,
    required this.selectedSeats,
    required this.ticketPrice,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  String _selectedPaymentMethod = 'qris';
  final int _serviceFeePerTicket = 4000;

  // Countdown Timer 10 Menit (600 Detik)
  late Timer _timer;
  int _startSeconds = 600;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _startSeconds--;
          });
        }
      }
    });
  }

  String _formatTimer(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String minStr = minutes.toString().padLeft(2, '0');
    String secStr = seconds.toString().padLeft(2, '0');
    return '$minStr : $secStr';
  }

  String _formatCurrency(int amount) {
    return 'Rp${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ticketCount = widget.selectedSeats.length;
    int totalSeatPrice = widget.ticketPrice * ticketCount;
    int totalServiceFee = _serviceFeePerTicket * ticketCount;
    int grandTotal = totalSeatPrice + totalServiceFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF001935)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ringkasan Order',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001935),
          ),
        ),
      ),
      body: Column(
        children: [
          // Banner Timer Countdown Pembayaran
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFFFF1F2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selesaikan pembayaran Anda dalam ',
                  style: TextStyle(fontSize: 12, color: Color(0xFFE11D48)),
                ),
                Text(
                  _formatTimer(_startSeconds),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Info Film
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE047),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'XXI',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movieTitle,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF001935),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.cinemaName}, STUDIO 2',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.dateText}, ${widget.timeText}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),

                  // Section Detail Transaksi
                  const Text(
                    'Detail Transaksi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                    '$ticketCount TIKET',
                    widget.selectedSeats.join(', '),
                    isBoldValue: true,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'KURSI REGULER',
                    '${_formatCurrency(widget.ticketPrice)} x $ticketCount',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'BIAYA LAYANAN',
                    '${_formatCurrency(_serviceFeePerTicket)} x $ticketCount',
                    subLabel: 'Untuk membantu peningkatan pelayanan kami',
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 12),

                  // Section Metode Pembayaran (Hanya QRIS & Transfer Bank)
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                  ),
                  const SizedBox(height: 12),

                  // Option 1: QRIS
                  _buildPaymentOption(
                    id: 'qris',
                    title: 'QRIS (Gopay, OVO, Dana, ShopeePay)',
                    subtitle: 'Pindai kode QR menggunakan aplikasi e-wallet atau m-banking Anda.',
                    icon: Icons.qr_code_scanner,
                    iconColor: Colors.redAccent,
                  ),

                  const SizedBox(height: 12),

                  // Option 2: Transfer Bank
                  _buildPaymentOption(
                    id: 'bank_transfer',
                    title: 'Transfer Bank (Virtual Account)',
                    subtitle: 'BCA, Mandiri, BNI, BRI, & Bank Lainnya.',
                    icon: Icons.account_balance,
                    iconColor: const Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar Bayar Sekarang
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL BAYAR', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(grandTotal),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001935),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          movieTitle: widget.movieTitle,
                          cinemaName: widget.cinemaName,
                          dateText: widget.dateText,
                          timeText: widget.timeText,
                          selectedSeats: widget.selectedSeats,
                          paymentMethod: _selectedPaymentMethod,
                          grandTotal: grandTotal,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001935),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'BAYAR SEKARANG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFBBF24),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {String? subLabel, bool isBoldValue = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
              if (subLabel != null) ...[
                const SizedBox(height: 2),
                Text(subLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF001935),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    bool isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF001935) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedPaymentMethod,
              activeColor: const Color(0xFF001935),
              onChanged: (val) {
                if (val != null) setState(() => _selectedPaymentMethod = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}