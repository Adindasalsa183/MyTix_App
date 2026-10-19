import 'package:flutter/material.dart';
import 'order_summary_screen.dart'; // Import halaman ringkasan order

class SelectSeatScreen extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String dateText;
  final String timeText;
  final int ticketPrice;

  const SelectSeatScreen({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.dateText,
    required this.timeText,
    required this.ticketPrice,
  });

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  // Baris A - M
  final List<String> rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M'];
  
  // Nomor kursi per baris (Kiri: 1-5, Kanan: 6-14)
  final List<int> leftSeats = [1, 2, 3, 4, 5];
  final List<int> rightSeats = [6, 7, 8, 9, 10, 11, 12, 13, 14];

  // Set untuk menyimpan kursi terpilih & tidak tersedia
  final Set<String> selectedSeats = {};
  final Set<String> unavailableSeats = {
    'B12', 'B13', 'C11', 'C12', 'C13', 'D9', 'D10',
    'E6', 'E7', 'E8', 'E9', 'E10', 'E11', 'E12', 'E13', 'E14',
    'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14',
    'G8', 'G9', 'G10', 'G11', 'G12', 'G13', 'G14'
  };

  @override
  Widget build(BuildContext context) {
    int totalSeatsSelected = selectedSeats.length;
    int totalPrice = totalSeatsSelected * widget.ticketPrice;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF001935)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cinemaName.toUpperCase(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001935),
              ),
            ),
            Text(
              '${widget.dateText} | ${widget.timeText}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time, color: Color(0xFF001935)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Peringatan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Anak usia 2 tahun ke atas wajib membeli tiket.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Legenda Status Kursi
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(const Color(0xFF0F172A), 'Tersedia'),
                _buildLegendItem(Colors.grey.shade200, 'Tidak Tersedia', border: Colors.grey.shade300),
                _buildLegendItem(const Color(0xFF0284C7), 'Pilihanmu'),
              ],
            ),
          ),

          const Divider(height: 1),

          // Area Denah Kursi
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Grid Kursi A - M
                      ...rows.map((row) => _buildSeatRow(row)),

                      const SizedBox(height: 30),

                      // Lengkungan Layar Bioskop
                      Column(
                        children: [
                          CustomPaint(
                            size: const Size(300, 20),
                            painter: ScreenArcPainter(),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'LAYAR BIOSKOP',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Bar Rincian Order
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL HARGA', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          totalSeatsSelected > 0 
                              ? 'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}' 
                              : 'Rp -',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: totalSeatsSelected > 0 ? const Color(0xFF001935) : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('TEMPAT DUDUK', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          totalSeatsSelected > 0 ? selectedSeats.join(', ') : 'Kursi belum dipilih',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: totalSeatsSelected > 0 ? const Color(0xFF001935) : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Tombol Ringkasan Order dengan Navigasi ke OrderSummaryScreen
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: totalSeatsSelected > 0
                        ? () {
                            List<String> sortedSeats = selectedSeats.toList()..sort();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderSummaryScreen(
                                  movieTitle: widget.movieTitle,
                                  cinemaName: widget.cinemaName,
                                  dateText: widget.dateText,
                                  timeText: widget.timeText,
                                  selectedSeats: sortedSeats,
                                  ticketPrice: widget.ticketPrice,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001935),
                      disabledBackgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'RINGKASAN ORDER',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: totalSeatsSelected > 0 ? const Color(0xFFFBBF24) : Colors.grey.shade500,
                        letterSpacing: 1,
                      ),
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

  Widget _buildLegendItem(Color color, String label, {Color? border}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: border != null ? Border.all(color: border) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }

  Widget _buildSeatRow(String rowName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Blok Kiri (Kursi 1-5)
          ...leftSeats.map((num) => _buildSeatBox('$rowName$num')),
          
          const SizedBox(width: 24), // Gang Tengah (Lorong)

          // Blok Kanan (Kursi 6-14)
          ...rightSeats.map((num) => _buildSeatBox('$rowName$num')),
        ],
      ),
    );
  }

  Widget _buildSeatBox(String seatId) {
    bool isSelected = selectedSeats.contains(seatId);
    bool isUnavailable = unavailableSeats.contains(seatId);

    Color bgColor = const Color(0xFF0F172A); // Tersedia
    Color textColor = Colors.white;

    if (isUnavailable) {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade300;
    } else if (isSelected) {
      bgColor = const Color(0xFF0284C7); // Pilihanmu (Biru)
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: isUnavailable
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  selectedSeats.remove(seatId);
                } else {
                  selectedSeats.add(seatId);
                }
              });
            },
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: isUnavailable ? Border.all(color: Colors.grey.shade200) : null,
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Painter untuk Menggambar Lengkungan Layar
class ScreenArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}