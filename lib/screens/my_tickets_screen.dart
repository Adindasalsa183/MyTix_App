import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'profile_screen.dart';
import 'notification_screen.dart';
import 'my_cinema_screen.dart';

class MyTicketsScreen extends StatefulWidget {
  final VoidCallback? onGoToHome;
  final int initialCategoryIndex;

  const MyTicketsScreen({
    super.key, 
    this.onGoToHome,
    this.initialCategoryIndex = 0,
  });

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedCategoryIndex;
  int _navIndex = 2;

  final List<String> _categories = const ['Film', 'Makanan', 'Event'];

  List<dynamic> _myTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIndex = widget.initialCategoryIndex;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    _fetchUserTicketsFromDatabase();
  }

  Future<void> _fetchUserTicketsFromDatabase() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await AuthService().fetchLatestProfile();
    } catch (_) {}

    final String host = kIsWeb ? 'localhost' : '10.0.2.2';
    final String apiUrl = "http://$host/mytix_api/get_user_tickets.php";

    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success') {
          if (mounted) {
            setState(() {
              _myTickets = resData['data'] ?? [];
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint("Error fetching tickets: $e");
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.headset_mic, color: Color(0xFF001935)),
            SizedBox(width: 8),
            Text('Bantuan MyTix',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
            'Butuh bantuan pemesanan atau kendala tiket? Hubungi Customer Service kami di support@mytix.id atau Call Center: 1500-123.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('TUTUP')),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp0';
    double doubleVal = double.tryParse(amount.toString()) ?? 0;
    int val = doubleVal.toInt();
    return 'Rp${val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final String currentCategory = _categories[_selectedCategoryIndex];

    final filteredTickets = _myTickets.where((item) {
      final cat = (item['category'] ?? '').toString().trim().toLowerCase();
      final targetCat = currentCategory.trim().toLowerCase();
      return cat == targetCat;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Cari di MyTix',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Color(0xFF001935)),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF001935)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF001935)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF001935),
              unselectedLabelColor: Colors.grey.shade500,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
              indicatorColor: const Color(0xFF0284C7),
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: 'TIKET AKTIF'),
                Tab(text: 'DAFTAR TRANSAKSI'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_categories.length, (index) {
                final isSelected = _selectedCategoryIndex == index;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isSelected ? const Color(0xFFF0F9FF) : Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF0284C7)
                            : Colors.grey.shade300,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0284C7)
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF001935)))
                : RefreshIndicator(
                    onRefresh: _fetchUserTicketsFromDatabase,
                    color: const Color(0xFF001935),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        filteredTickets.isEmpty
                            ? _buildEmptyState(
                                title: 'Belum Ada Tiket Aktif',
                                description:
                                    'Pesan tiket $currentCategory favoritmu sekarang!',
                              )
                            : _buildTicketList(filteredTickets, isAktif: true),

                        filteredTickets.isEmpty
                            ? _buildEmptyState(
                                title: 'Belum Ada Transaksi',
                                description:
                                    'Riwayat pembelian $currentCategory kamu akan muncul di sini.',
                              )
                            : _buildTicketList(filteredTickets, isAktif: false),
                      ],
                    ),
                  ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          if (index == 0) {
            if (widget.onGoToHome != null) {
              widget.onGoToHome!();
            } else {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyCinemaScreen()),
            );
          } else {
            setState(() => _navIndex = index);
          }
        },
        selectedItemColor: const Color(0xFF001935),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_outlined), label: 'Bioskop'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: 'Tiket'),
        ],
      ),
    );
  }

  Widget _buildTicketList(List<dynamic> tickets, {required bool isAktif}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final String category = (ticket['category'] ?? 'Film').toString();

        IconData iconData = Icons.movie;
        if (category.toLowerCase() == 'makanan') iconData = Icons.fastfood;
        if (category.toLowerCase() == 'event') iconData = Icons.event;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Material(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.black12,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetailScreen(ticketData: ticket),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF001935).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(iconData, color: const Color(0xFF001935), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket['title'] ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF001935)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ticket['venue'] ?? '-',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey.shade600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAktif ? Colors.green.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isAktif ? 'AKTIF' : 'SUKSES',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isAktif ? Colors.green.shade800 : Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ticket['subtitle'] ?? '-',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF001935))),
                            if (ticket['details'] != null &&
                                ticket['details'].toString().isNotEmpty)
                              Text(ticket['details'].toString(),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey.shade600)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              _formatCurrency(ticket['total_price']),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF001935)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                color: Colors.grey, size: 14),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required String title,
    required String description,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.confirmation_number_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001935),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onGoToHome != null) {
                    widget.onGoToHome!();
                  } else {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Film',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// KELAS DETAIL PEMBELIAN / E-TICKET (NAMA PEMESAN DIHAPUS)
// ---------------------------------------------------------------------------
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
      backgroundColor: const Color(0xFF0B192C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'E-Ticket & Bukti Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  // HEADER KARTU
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.4)),
                          ),
                          child: Icon(iconData, color: const Color(0xFF38BDF8), size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0284C7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  category.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
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

                  // BODY E-TICKET (NAMA PEMESAN SUDAH DIHAPUS)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Lokasi / Venue', venue, Icons.location_on_outlined),
                        const SizedBox(height: 14),
                        _buildInfoRow('Waktu / Tanggal', subtitle, Icons.access_time_rounded),
                        if (details.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _buildInfoRow('Keterangan / Seats', details, Icons.confirmation_number_outlined),
                        ],
                        const SizedBox(height: 14),
                        _buildInfoRow('Metode Pembayaran', 'QRIS / Cashless', Icons.account_balance_wallet_outlined),
                        const Divider(height: 28, thickness: 1),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatCurrency(ticketData['total_price']),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0B192C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // GAURIS TEPIAN KARCIS
                  Row(
                    children: [
                      const SizedBox(
                        height: 20,
                        width: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFF0B192C),
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
                            color: Color(0xFF0B192C),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // BAGIAN BARCODE / QR CODE E-TICKET
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 110,
                            color: Color(0xFF0B192C),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ticketCode,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Color(0xFF0B192C),
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

            const SizedBox(height: 20),

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
                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
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
                  elevation: 4,
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
                  color: Color(0xFF0B192C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}