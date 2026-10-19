import 'package:flutter/material.dart';

class TicketDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ticketData;

  const TicketDetailScreen({
    super.key,
    required this.ticketData,
  });

  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp0';
    double doubleVal = double.tryParse(amount.toString()) ?? 0;
    int val = doubleVal.toInt();
    return 'Rp${val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final String category = (ticketData['category'] ?? 'Film').toString();
    final String title = ticketData['title'] ?? 'Tiket MyTix';
    final String venue = ticketData['venue'] ?? 'Bioskop MyTix';
    final String subtitle = ticketData['subtitle'] ?? '-';
    final String details = ticketData['details'] ?? '';
    final String id = ticketData['id']?.toString() ?? '1';

    IconData iconData = Icons.movie_filter_rounded;
    if (category.toLowerCase() == 'makanan') iconData = Icons.fastfood_rounded;
    if (category.toLowerCase() == 'event') iconData = Icons.event_seat_rounded;

    final String ticketCode = "TIX-${category.toUpperCase().substring(0, 3)}-$id-2026";

    return Scaffold(
      backgroundColor: const Color(0xFF001935),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F2942),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(iconData, color: const Color(0xFF38BDF8), size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Lokasi / Venue', venue, Icons.location_on_outlined),
                        const SizedBox(height: 16),
                        _buildInfoRow('Waktu / Tanggal', subtitle, Icons.access_time_rounded),
                        if (details.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildInfoRow('Keterangan', details, Icons.info_outline_rounded),
                        ],
                        const SizedBox(height: 16),
                        _buildInfoRow('Metode Pembayaran', 'QRIS / Cashless', Icons.payment_rounded),
                        const Divider(height: 32, thickness: 1),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _formatCurrency(ticketData['total_price']),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF001935),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      const SizedBox(
                        height: 20,
                        width: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF001935),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                (constraints.constrainWidth() / 10).floor(),
                                (_) => const SizedBox(
                                  width: 5,
                                  height: 1.5,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(color: Colors.grey),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                        width: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF001935),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 110,
                            color: Color(0xFF001935),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ticketCode,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Color(0xFF001935),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tunjukkan Kode QR ini kepada petugas di lokasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-Ticket berhasil disimpan ke Galeri!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text(
                  'Unduh Tiket / E-Receipt',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0284C7)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001935),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}