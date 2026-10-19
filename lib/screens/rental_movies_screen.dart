import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ------------------------------------------------------------------
// DATABASE LOKAL FILM SEWA ONLINE
// ------------------------------------------------------------------
final List<Map<String, dynamic>> _rentalDatabase = [
  {
    'id': 'now-you-see-me',
    'title': 'NOW YOU SEE ME',
    'image': 'assets/images/now.jpg',
    'year': '2013',
    'duration': '1 jam 55 mnt',
    'rating': '85%',
    'ageRating': '13+',
    'synopsis': 'Sebuah tim pesulap terampil yang dikenal sebagai "The Four Horsemen" melakukan perampokan bank virtual selama pertunjukan mereka, lalu membagikan uang hasil perampokan tersebut kepada para penonton.',
    'rentPriceText': 'Rp 28.000',
    'rentPriceRaw': 28000.0,
    'buyPriceText': 'Rp 74.000',
    'buyPriceRaw': 74000.0,
  },
  {
    'id': 'the-conjuring',
    'title': 'THE CONJURING',
    'image': 'assets/images/theconjuring.jpg',
    'year': '2013',
    'duration': '1 jam 52 mnt',
    'rating': '86%',
    'ageRating': '17+',
    'synopsis': 'Investigator supranatural Ed dan Lorraine Warren bekerja untuk membantu keluarga Perron yang mengalami peristiwa-peristiwa mistis dan mengerikan di rumah peternakan terpencil mereka.',
    'rentPriceText': 'Rp 30.000',
    'rentPriceRaw': 30000.0,
    'buyPriceText': 'Rp 80.000',
    'buyPriceRaw': 80000.0,
  },
  {
    'id': 'the-nun-2',
    'title': 'THE NUN II',
    'image': 'assets/images/thenun.jpg',
    'year': '2023',
    'duration': '1 jam 50 mnt',
    'rating': '78%',
    'ageRating': '17+',
    'synopsis': 'Prancis 1956. Seorang pastor dibunuh, dan kejahatan mulai menyebar. Suster Irene sekali lagi berhadapan langsung dengan kekuatan iblis Valak yang mengerikan.',
    'rentPriceText': 'Rp 32.000',
    'rentPriceRaw': 32000.0,
    'buyPriceText': 'Rp 85.000',
    'buyPriceRaw': 85000.0,
  },
  {
    'id': 'smurfs-lost-village',
    'title': 'SMURFS : THE LOST VILLAGE',
    'image': 'assets/images/smurfs.jpg',
    'year': '2017',
    'duration': '1 jam 30 mnt',
    'rating': '80%',
    'ageRating': 'SU',
    'synopsis': 'Peta misterius membawa Smurfette dan sahabatnya Brainy, Clumsy, dan Hefty dalam perlombaan mendebarkan melintasi Hutan Terlarang untuk menemukan desa tersembunyi legendaris.',
    'rentPriceText': 'Rp 22.000',
    'rentPriceRaw': 22000.0,
    'buyPriceText': 'Rp 60.000',
    'buyPriceRaw': 60000.0,
  },
  {
    'id': 'man-of-steel',
    'title': 'MAN OF STEEL',
    'image': 'assets/images/man.jpg',
    'year': '2013',
    'duration': '2 jam 23 mnt',
    'rating': '82%',
    'ageRating': '13+',
    'synopsis': 'Seorang anak laki-laki mempelajari bahwa ia memiliki kekuatan luar biasa dan bukan berasal dari Bumi. Sebagai pemuda, ia melakukan perjalanan untuk menemukan dari mana ia berasal dan alasan ia dikirim ke sini.',
    'rentPriceText': 'Rp 25.000',
    'rentPriceRaw': 25000.0,
    'buyPriceText': 'Rp 70.000',
    'buyPriceRaw': 70000.0,
  },
];

// ------------------------------------------------------------------
// 1. HALAMAN KATALOG UTAMA
// ------------------------------------------------------------------
class RentalMoviesScreen extends StatelessWidget {
  const RentalMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sewa Film Online',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 14,
          mainAxisSpacing: 18,
        ),
        itemCount: _rentalDatabase.length,
        itemBuilder: (context, index) {
          final item = _rentalDatabase[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieRentalDetailScreen(movieData: item),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF181A20),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF001935),
                          child: const Center(child: Icon(Icons.movie_outlined, color: Colors.white, size: 36)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mulai dari ${item['rentPriceText']}',
                          style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// 2. HALAMAN DETAIL STREAMING FILM
// ------------------------------------------------------------------
class MovieRentalDetailScreen extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const MovieRentalDetailScreen({
    super.key,
    required this.movieData,
  });

  @override
  State<MovieRentalDetailScreen> createState() => _MovieRentalDetailScreenState();
}

class _MovieRentalDetailScreenState extends State<MovieRentalDetailScreen> {
  bool _isBookmarked = false;
  bool _isLiked = false;
  bool _isDisliked = false;

  void _navigateToCheckout(String optionType, String priceText, double rawPrice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieRentalCheckoutScreen(
          movieTitle: widget.movieData['title'] ?? 'NOW YOU SEE ME',
          rentalType: optionType,
          priceText: priceText,
          rawPrice: rawPrice,
          movieImage: widget.movieData['image'] ?? 'assets/images/now.jpg',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.movieData['title'] ?? 'NOW YOU SEE ME';
    final synopsis = widget.movieData['synopsis'] ?? 'Sinopsis film tidak tersedia.';
    final year = widget.movieData['year'] ?? '2013';
    final duration = widget.movieData['duration'] ?? '1 jam 55 mnt';
    final rating = widget.movieData['rating'] ?? '85%';
    final ageRating = widget.movieData['ageRating'] ?? '13+';
    final rentPriceText = widget.movieData['rentPriceText'] ?? 'Rp 28.000';
    final rentPriceRaw = (widget.movieData['rentPriceRaw'] as num?)?.toDouble() ?? 28000.0;
    final buyPriceText = widget.movieData['buyPriceText'] ?? 'Rp 74.000';
    final buyPriceRaw = (widget.movieData['buyPriceRaw'] as num?)?.toDouble() ?? 74000.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 380,
                      width: double.infinity,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.1),
                            const Color(0xFF0F1015),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Image.asset(
                        widget.movieData['image'] ?? 'assets/images/now.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade900),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.greenAccent, size: 18),
                          const SizedBox(width: 4),
                          Text(rating, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(ageRating, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                          ),
                          const SizedBox(width: 12),
                          Text('$year • $duration', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(synopsis, style: TextStyle(color: Colors.grey.shade300, fontSize: 13, height: 1.5)),
                      const SizedBox(height: 24),

                      // Tombol Pilihan Sewa atau Beli
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _navigateToCheckout('Sewa HD', rentPriceText, rentPriceRaw),
                              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 18),
                              label: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Sewa HD', style: TextStyle(color: Colors.black, fontSize: 10)),
                                  Text(rentPriceText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA8C7FA),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _navigateToCheckout('Beli HD', buyPriceText, buyPriceRaw),
                              icon: const Icon(Icons.shopping_bag_rounded, color: Colors.black, size: 18),
                              label: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Beli mulai dari', style: TextStyle(color: Colors.black, fontSize: 10)),
                                  Text(buyPriceText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA8C7FA),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                            child: Column(
                              children: [
                                Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: _isBookmarked ? Colors.cyanAccent : Colors.white),
                                const SizedBox(height: 4),
                                const Text('Daftar Tonton', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() => _isLiked = !_isLiked),
                            child: Column(
                              children: [
                                Icon(_isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, color: _isLiked ? Colors.greenAccent : Colors.white),
                                const SizedBox(height: 4),
                                const Text('Suka', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() => _isDisliked = !_isDisliked),
                            child: Column(
                              children: [
                                Icon(_isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, color: _isDisliked ? Colors.redAccent : Colors.white),
                                const SizedBox(height: 4),
                                const Text('Tidak suka', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// 3. FORM INPUT ISI MANUAL PEMESAN
// ------------------------------------------------------------------
class MovieRentalCheckoutScreen extends StatefulWidget {
  final String movieTitle;
  final String rentalType;
  final String priceText;
  final double rawPrice;
  final String movieImage;

  const MovieRentalCheckoutScreen({
    super.key,
    required this.movieTitle,
    required this.rentalType,
    required this.priceText,
    required this.rawPrice,
    required this.movieImage,
  });

  @override
  State<MovieRentalCheckoutScreen> createState() => _MovieRentalCheckoutScreenState();
}

class _MovieRentalCheckoutScreenState extends State<MovieRentalCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Field Form Dibuat KOSONG agar Pengguna Mengisi Secara Manual
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedPaymentMethod = 'QRIS / E-Wallet';

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'QRIS / E-Wallet', 'icon': Icons.qr_code_scanner_rounded, 'desc': 'Scan QRIS via DANA, GoPay, OVO, ShopeePay'},
    {'name': 'Google Pay', 'icon': Icons.account_balance_wallet_rounded, 'desc': 'Pembayaran praktis 1-Tap Google'},
    {'name': 'BCA Virtual Account', 'icon': Icons.account_balance_rounded, 'desc': 'Transfer Otomatis Bank BCA'},
    {'name': 'Mandiri Virtual Account', 'icon': Icons.account_balance_rounded, 'desc': 'Transfer Otomatis Bank Mandiri'},
  ];

  void _handlePayNow() {
    if (!_formKey.currentState!.validate()) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => QrPaymentBottomSheet(
        movieTitle: widget.movieTitle,
        rentalType: widget.rentalType,
        priceText: widget.priceText,
        rawPrice: widget.rawPrice,
        userName: _nameController.text,
        userEmail: _emailController.text,
        userPhone: _phoneController.text,
        paymentMethod: _selectedPaymentMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1015),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Produk
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF181A20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.movieImage,
                        width: 55,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 55, height: 75, color: Colors.grey.shade800),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movieTitle,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text('Kategori: ${widget.rentalType}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                          const SizedBox(height: 6),
                          Text(
                            widget.priceText,
                            style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text('Data Pemesan (Isi Manual)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),

              _buildCustomTextField(
                controller: _nameController,
                label: 'Nama Lengkap',
                hint: 'Masukkan nama Anda',
                icon: Icons.person_outline_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Nama lengkap wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              _buildCustomTextField(
                controller: _emailController,
                label: 'Alamat Email',
                hint: 'contoh@domain.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Email tidak valid' : null,
              ),
              const SizedBox(height: 12),

              _buildCustomTextField(
                controller: _phoneController,
                label: 'Nomor WhatsApp / Telepon',
                hint: '081234567890',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().length < 9 ? 'Nomor telepon minimal 9 digit' : null,
              ),

              const SizedBox(height: 24),
              const Text('Pilih Metode Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),

              ..._paymentMethods.map((method) {
                final isSelected = _selectedPaymentMethod == method['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedPaymentMethod = method['name']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF262A34) : const Color(0xFF181A20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.cyanAccent : Colors.white10,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(method['icon'] as IconData, color: isSelected ? Colors.cyanAccent : Colors.grey, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(method['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(method['desc'], style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                            ],
                          ),
                        ),
                        Radio<String>(
                          value: method['name'],
                          groupValue: _selectedPaymentMethod,
                          activeColor: Colors.cyanAccent,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPaymentMethod = val);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handlePayNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA8C7FA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    'Bayar Sekarang • ${widget.priceText}',
                    style: const TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 18),
        filled: true,
        fillColor: const Color(0xFF181A20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 4. BOTTOM SHEET KODE QRIS & TIMER COUNTDOWN 2 MENIT
// ------------------------------------------------------------------
class QrPaymentBottomSheet extends StatefulWidget {
  final String movieTitle;
  final String rentalType;
  final String priceText;
  final double rawPrice;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String paymentMethod;

  const QrPaymentBottomSheet({
    super.key,
    required this.movieTitle,
    required this.rentalType,
    required this.priceText,
    required this.rawPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.paymentMethod,
  });

  @override
  State<QrPaymentBottomSheet> createState() => _QrPaymentBottomSheetState();
}

class _QrPaymentBottomSheetState extends State<QrPaymentBottomSheet> {
  late Timer _timer;
  int _secondsRemaining = 120; // Timer 2 Menit (120 Detik)
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _processPayment() async {
    setState(() => _isSubmitting = true);

    final String host = kIsWeb ? 'localhost' : '10.0.2.2';
    final String apiUrl = "http://$host/mytix_api/save_movie_rental.php";

    String orderId = "RENT-" + DateTime.now().millisecondsSinceEpoch.toString().substring(5);

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "movie_title": widget.movieTitle,
          "rental_type": widget.rentalType,
          "price": widget.rawPrice,
          "user_name": widget.userName,
          "user_email": widget.userEmail,
          "user_phone": widget.userPhone,
          "payment_method": widget.paymentMethod,
        }),
      );

      final resData = jsonDecode(res.body);
      if (resData['order_id'] != null) {
        orderId = resData['order_id'];
      }
    } catch (_) {}

    setState(() => _isSubmitting = false);
    Navigator.pop(context); // Tutup QR BottomSheet

    // Tampilkan Nota Pembayaran Digital
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MovieRentalReceiptDialog(
        orderId: orderId,
        movieTitle: widget.movieTitle,
        rentalType: widget.rentalType,
        priceText: widget.priceText,
        userName: widget.userName,
        userEmail: widget.userEmail,
        userPhone: widget.userPhone,
        paymentMethod: widget.paymentMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF181A20),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('Scan QR Code Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text('Buka e-wallet Anda dan scan kode QR di bawah ini', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          const SizedBox(height: 16),

          // Timer Countdown 2 Menit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF262A34),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.cyanAccent, size: 18),
                const SizedBox(width: 6),
                Text('Sisa Waktu: $_formattedTime', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tampilan Kode QR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(
              'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=MYTIX-PAYMENT-${widget.movieTitle}',
              width: 170,
              height: 170,
              errorBuilder: (_, __, ___) => Container(
                width: 170,
                height: 170,
                color: Colors.grey.shade200,
                child: const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text('${widget.movieTitle} • ${widget.priceText}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 24),

          // Tombol "Sudah Bayar"
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _secondsRemaining > 0 && !_isSubmitting ? _processPayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : const Text('Sudah Bayar', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// 5. DIALOG NOTA / STRUK TRANSAKSI DIGITAL MODERN
// ------------------------------------------------------------------
class MovieRentalReceiptDialog extends StatelessWidget {
  final String orderId;
  final String movieTitle;
  final String rentalType;
  final String priceText;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String paymentMethod;

  const MovieRentalReceiptDialog({
    super.key,
    required this.orderId,
    required this.movieTitle,
    required this.rentalType,
    required this.priceText,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF181A20),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 48),
                  ),
                  const SizedBox(height: 10),
                  const Text('PEMBAYARAN BERHASIL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                  Text('Nota Transaksi Digital MyTix', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white24)),

            _buildReceiptRow('No. Order', orderId, isHighlight: true),
            _buildReceiptRow('Nama Pemesan', userName),
            _buildReceiptRow('Email', userEmail),
            _buildReceiptRow('No. Telepon', userPhone),
            _buildReceiptRow('Film', movieTitle),
            _buildReceiptRow('Kategori', rentalType),
            _buildReceiptRow('Metode Bayar', paymentMethod),
            _buildReceiptRow('Status', 'AKTIF', isStatus: true),

            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white24)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(priceText, style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup Nota
                  Navigator.pop(context); // Kembali ke Detail
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaksi tersimpan! Selamat menonton.'), backgroundColor: Colors.cyan),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Mulai Nonton Sekarang', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false, bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isStatus
                    ? Colors.greenAccent
                    : (isHighlight ? Colors.cyanAccent : Colors.white),
                fontWeight: isHighlight || isStatus ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}