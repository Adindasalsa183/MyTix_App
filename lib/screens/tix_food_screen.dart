import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import 'my_tickets_screen.dart';

class TixFoodScreen extends StatefulWidget {
  final String? loggedInUser;
  final Map<String, String>? initialCinema;

  const TixFoodScreen({
    super.key, 
    this.loggedInUser,
    this.initialCinema,
  });

  @override
  State<TixFoodScreen> createState() => _TixFoodScreenState();
}

class _TixFoodScreenState extends State<TixFoodScreen> {
  final List<Map<String, String>> _cinemas = const [
    {'name': 'CIPUTRA WORLD XXI', 'hours': 'Jam operasional F&B 11:30 - 21:30 WIB'},
    {'name': 'PAKUWON CITY XXI', 'hours': 'Jam operasional F&B 11:30 - 21:05 WIB'},
    {'name': 'ROYAL XXI', 'hours': 'Jam operasional F&B 11:00 - 21:30 WIB'},
    {'name': 'TRANS ICON MALL XXI', 'hours': 'Jam operasional F&B 11:30 - 21:40 WIB'},
    {'name': 'BG JUNCTION CGV', 'hours': 'Jam operasional F&B 11:00 - 21:15 WIB'},
  ];

  final List<Map<String, dynamic>> _foodItems = const [
    {
      'title': 'SNACK ATTACK',
      'desc': 'Popcorn Salt/Sweet + Java Tea + Donut',
      'priceRaw': 50000,
      'price': 'Rp 50.000',
      'image': 'assets/images/snackattack.jpg',
    },
    {
      'title': 'CLASSIC COMBO',
      'desc': 'Popcorn Salt/Sweet Glaze/Mix + Coca-Cola Zero',
      'priceRaw': 50000,
      'price': 'Rp 50.000',
      'image': 'assets/images/classiccombo.jpg',
    },
    {
      'title': 'STIXX PANDAN KAYA',
      'desc': 'Pandan Srikaya Pretzels + Coconut Flakes',
      'priceRaw': 35000,
      'price': 'Rp 35.000',
      'image': 'assets/images/stixxpandan.jpg',
    },
    {
      'title': 'FAMILY COMBO',
      'desc': 'Popcorn Tower + 2 Soft Drink (L)',
      'priceRaw': 200000,
      'price': 'Rp 200.000',
      'image': 'assets/images/familycombo.jpg',
    },
    {
      'title': 'PAKET GOOLLL!',
      'desc': 'Popcorn Salt (M) + Croffle + Coca Cola Can',
      'priceRaw': 100000,
      'price': 'Rp 100.000',
      'image': 'assets/images/paketgool.jpg',
    },
  ];

  Map<String, String>? _selectedCinema;

  String get _activeUsername {
    if (widget.loggedInUser != null && widget.loggedInUser!.isNotEmpty) {
      return widget.loggedInUser!;
    }
    return AuthService().name;
  }

  @override
  void initState() {
    super.initState();
    _selectedCinema = widget.initialCinema;
  }

  void _navigateToPaymentPage(Map<String, dynamic> food) {
    if (_selectedCinema == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TixFoodPaymentScreen(
          food: food,
          cinema: _selectedCinema!['name']!,
          username: _activeUsername,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF001935), size: 18),
          onPressed: () {
            if (_selectedCinema != null) {
              setState(() => _selectedCinema = null);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedCinema == null ? 'Pilih Bioskop TIX Food' : _selectedCinema!['name']!,
          style: const TextStyle(
            color: Color(0xFF001935), 
            fontWeight: FontWeight.bold, 
            fontSize: 16
          ),
        ),
      ),
      body: _selectedCinema == null ? _buildCinemaList() : _buildFoodScreen(),
    );
  }

  Widget _buildCinemaList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: const Color(0xFF001935),
          child: const Row(
            children: [
              Icon(Icons.location_on, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Text(
                'SURABAYA', 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12, letterSpacing: 1.1)
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _cinemas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final cinema = _cinemas[index];
              final bool isCGV = cinema['name']!.contains('CGV');

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCinema = cinema;
                  });
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isCGV ? Colors.red.shade50 : Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isCGV ? 'CGV' : 'XXI', 
                          style: TextStyle(
                            fontWeight: FontWeight.w900, 
                            fontSize: 12,
                            color: isCGV ? Colors.red : const Color(0xFFD97706)
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cinema['name']!, 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001935))
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cinema['hours']!, 
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodScreen() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              )
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.storefront_rounded, color: Color(0xFF001935), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCinema!['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001935), fontSize: 13),
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _selectedCinema = null),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001935).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Ganti Bioskop', style: TextStyle(color: Color(0xFF001935), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: _foodItems.length,
            itemBuilder: (context, index) {
              final item = _foodItems[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF001935),
                            child: const Center(child: Icon(Icons.fastfood, color: Colors.white, size: 32)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)), maxLines: 1),
                    const SizedBox(height: 2),
                    Text(item['desc']!, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(item['price']!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF001935))),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () => _navigateToPaymentPage(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001935), 
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('PESAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------
// HALAMAN PEMBAYARAN FULL SCREEN & DIALOG NOTA ELEGAN
// ------------------------------------------------------------------
class TixFoodPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> food;
  final String cinema;
  final String username;

  const TixFoodPaymentScreen({
    super.key,
    required this.food,
    required this.cinema,
    required this.username,
  });

  @override
  State<TixFoodPaymentScreen> createState() => _TixFoodPaymentScreenState();
}

class _TixFoodPaymentScreenState extends State<TixFoodPaymentScreen> {
  int _secondsLeft = 180;
  Timer? _timer;
  String _selectedMethod = 'QRIS';
  bool _isLoading = false;
  bool _isQrGenerated = false;

  @override
  void initState() {
    super.initState();
    _startTimer(180);
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Waktu pembayaran habis!'), 
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);

    final String host = kIsWeb ? 'localhost' : '10.0.2.2';
    final String apiUrl = "http://$host/mytix_api/save_food_order.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode({
          "username": widget.username,
          "cinema_name": widget.cinema,
          "item_title": widget.food['title'],
          "total_price": widget.food['priceRaw'],
          "payment_method": _selectedMethod,
        }),
      );

      final resData = jsonDecode(response.body);

      if (mounted) {
        setState(() => _isLoading = false);
        _timer?.cancel();

        if (resData['status'] == 'success') {
          String orderId = resData['order_id'] ?? 'TIXF-008129';
          _showPickupReceiptModal(orderId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal: ${resData['message']}'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _timer?.cancel();
        _showPickupReceiptModal('TIXF-008129');
      }
    }
  }

  // DIALOG NOTA PICKUP MODEL STRUK TIKET
  void _showPickupReceiptModal(String orderId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),
              
              // Status Badge Success
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 12),
              const Text('PEMBAYARAN BERHASIL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF001935), letterSpacing: 0.5)),
              Text('Simpan nota digital ini untuk penjemputan F&B', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(height: 20),

              // CARD KARTU STRUK PICKUP
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID PESANAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 0.8)),
                            const SizedBox(height: 2),
                            Text(orderId, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF001935))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                          child: Text('LUNAS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                        )
                      ],
                    ),

                    const SizedBox(height: 14),
                    Row(
                      children: List.generate(
                        30,
                        (index) => Expanded(
                          child: Container(
                            height: 1,
                            color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildReceiptRow('Pemesan', widget.username),
                    const SizedBox(height: 8),
                    _buildReceiptRow('Lokasi Pickup', widget.cinema),
                    const SizedBox(height: 8),
                    _buildReceiptRow('Menu F&B', widget.food['title']!),
                    const SizedBox(height: 8),
                    _buildReceiptRow('Metode Bayar', _selectedMethod, isHighlight: true),

                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        Text(widget.food['price']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BARCODE SCANNER UNTUK KASIR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0xFF001935)),
                    const SizedBox(height: 4),
                    Text('Tunjukkan QR ini ke kasir ${widget.cinema}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // TOMBOL SELESAI & KEMBALI
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyTicketsScreen(initialCategoryIndex: 1), // Kategori Makanan
                      ),
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001935),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('SELESAI & KEMBALI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        Text(
          value, 
          style: TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: isHighlight ? const Color(0xFF0284C7) : const Color(0xFF001935)
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF001935), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isQrGenerated ? 'Pembayaran TIX Food' : 'Konfirmasi & Pembayaran',
          style: const TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade700, Colors.red.shade900],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Selesaikan Pembayaran Dalam',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatTime(_secondsLeft),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (!_isQrGenerated) ...[
                    const Text('RINCIAN PESANAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  widget.food['image']!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 64, height: 64, color: const Color(0xFF001935),
                                    child: const Icon(Icons.fastfood, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.food['title']!,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF001935)),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.food['desc']!,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.food['price']!,
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF001935)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Pemesan', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              Text(widget.username, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Lokasi Penjemputan', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              Text(widget.cinema, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text('METODE PEMBAYARAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
                    const SizedBox(height: 10),

                    _buildPaymentOptionCard(
                      id: 'QRIS',
                      title: 'QRIS',
                      subtitle: 'Gopay, OVO, Dana, ShopeePay, BCA Mobile',
                      icon: Icons.qr_code_scanner_rounded,
                    ),

                    const SizedBox(height: 10),

                    _buildPaymentOptionCard(
                      id: 'Virtual Account',
                      title: 'Virtual Account',
                      subtitle: 'Transfer via BCA, Mandiri, BRI, BNI',
                      icon: Icons.account_balance_outlined,
                    ),
                  ] 
                  else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          if (_selectedMethod == 'QRIS') ...[
                            const Text(
                              'Pindai Kode QRIS',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF001935)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Buka aplikasi e-wallet / m-banking kamu lalu scan QR di bawah ini:',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.qr_code_2_rounded,
                                size: 190,
                                color: Color(0xFF001935),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Total Tagihan: ${widget.food['price']}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Color(0xFF001935)),
                            ),
                          ] else ...[
                            const Text(
                              'Nomor Virtual Account',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF001935)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Transfer tepat sesuai dengan nominal berikut:',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'BCA VIRTUAL ACCOUNT',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '88012 081234567890',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF001935), letterSpacing: 1.1),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.grey),
                                        onPressed: () {
                                          Clipboard.setData(const ClipboardData(text: '88012081234567890'));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Nomor VA berhasil disalin!'), duration: Duration(seconds: 1)),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Tagihan', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                Text(widget.food['price']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // BOTTOM BAR
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ]
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total Pembayaran', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    const SizedBox(height: 2),
                    Text(
                      widget.food['price']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF001935)),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () {
                              if (!_isQrGenerated) {
                                setState(() {
                                  _isQrGenerated = true;
                                });
                                _startTimer(60); 
                              } else {
                                _processPayment();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isQrGenerated ? Colors.green.shade700 : const Color(0xFF001935),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              _isQrGenerated ? 'SUDAH BAYAR' : 'BAYAR SEKARANG', 
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
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

  Widget _buildPaymentOptionCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = _selectedMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF001935) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF001935).withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF001935).withOpacity(0.08) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF001935), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001935))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedMethod,
              activeColor: const Color(0xFF001935),
              onChanged: (val) => setState(() => _selectedMethod = val!),
            ),
          ],
        ),
      ),
    );
  }
}