import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class TixEventsScreen extends StatefulWidget {
  const TixEventsScreen({super.key});

  @override
  State<TixEventsScreen> createState() => _TixEventsScreenState();
}

class _TixEventsScreenState extends State<TixEventsScreen> {
  final List<Map<String, dynamic>> _events = const [
    {
      'id': 'jfw-2026',
      'title': 'Jakarta Film Week 2026',
      'category': 'OTHERS',
      'dateRange': '21 - 25 Oktober 2026',
      'time': '13.00 - End',
      'location': 'CGV Grand Indonesia, CGV fX Sudirman, TIM, Mercure Cikini',
      'price': 'Rp4.000',
      'priceRaw': 4000,
      'image': 'assets/images/jakartafilmweek.jpg',
    },
    {
      'id': 'cares-2026',
      'title': 'CARES 2026',
      'category': 'SEMINAR',
      'dateRange': '31 Oktober 2026',
      'time': '08.00 - 17.00 WIB',
      'location': 'The Westin Hotel Jakarta',
      'price': 'Rp200.000',
      'priceRaw': 200000,
      'image': 'assets/images/cares.jpg',
    },
  ];

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
        title: const Text(
          'TIX Events',
          style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(eventData: event),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      event['image']!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: const Color(0xFF001935),
                        child: const Center(child: Icon(Icons.event, color: Colors.white, size: 40)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title']!, 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935))
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event['location']!, 
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mulai dari ${event['price']!}', 
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF001935))
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF001935),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('LIHAT DETAIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            )
                          ],
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
// 1. HALAMAN DETAIL EVENT
// ------------------------------------------------------------------
class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetailScreen({super.key, required this.eventData});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String _selectedDate = '21 OCT';

  final List<Map<String, String>> _dates = const [
    {'date': 'ALL DATE', 'day': ''},
    {'date': '21 OCT', 'day': 'WED'},
    {'date': '22 OCT', 'day': 'THU'},
    {'date': '23 OCT', 'day': 'FRI'},
    {'date': '24 OCT', 'day': 'SAT'},
    {'date': '25 OCT', 'day': 'SUN'},
  ];

  final List<Map<String, String>> _allSchedule = const [
    {
      'date': '21 OCT',
      'title': 'Eastern Condor',
      'venue': 'CGV GRAND INDONESIA | GI - Audi 3 | 17+ - 16.00',
      'desc': 'Sekelompok tahanan asal Asia dengan latar belakang militer dikirim ke Vietnam.',
      'status': 'SOLD OUT'
    },
    {
      'date': '21 OCT',
      'title': 'Encounters of the Martial Mind : A Masterclass with Sammo Hung',
      'venue': 'CGV GRAND INDONESIA | GI - Audi 2 | 17+ - 19:00',
      'desc': 'Mustahil untuk tidak mengagumi kontribusi Sammo Hung bagi sinema martial arts.',
      'status': 'AVAILABLE'
    },
    {
      'date': '22 OCT',
      'title': 'Ah Girl (OPENING FILM)',
      'venue': 'CGV GRAND INDONESIA | GI - Audi 11 | 13+ - 19:15',
      'desc': 'Singapura tahun 1994, sebuah kisah menyentuh hati tentang ikatan keluarga.',
      'status': 'SOLD OUT'
    },
    {
      'date': '23 OCT',
      'title': 'Program Talk & Industri Talk',
      'venue': 'CGV GRAND INDONESIA | GI - Audi 1 | 15+ - 14:00',
      'desc': 'Sesi diskusi interaktif bersama para profesional perfilman nasional.',
      'status': 'AVAILABLE'
    },
    {
      'date': '24 OCT',
      'title': 'The Tasters & Burn',
      'venue': 'CGV GRAND INDONESIA | GI - Audi 2 | 17+ - 16:30',
      'desc': 'Pemutaran ganda karya sinematik dengan narasi yang kuat dan intens.',
      'status': 'AVAILABLE'
    },
    {
      'date': '25 OCT',
      'title': 'The Girl with the Leica & Seporsi Mie Ayam Sebelum Mati',
      'venue': 'CGV GRAND INDONESIA | GI - Audi 3 | 13+ - 18:30',
      'desc': 'Dua film pendek penutup festival yang penuh dengan pesan emosional.',
      'status': 'AVAILABLE'
    },
  ];

  void _proceedToBooking(Map<String, String> show) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          eventData: widget.eventData,
          showData: show,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchedule = _selectedDate == 'ALL DATE'
        ? _allSchedule
        : _allSchedule.where((item) => item['date'] == _selectedDate).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF001935), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TIX EVENTS', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF001935)),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.eventData['image']!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: const Color(0xFF001935),
                      child: const Center(child: Icon(Icons.event, color: Colors.white, size: 50)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.eventData['title']!,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            widget.eventData['category'] ?? 'OTHERS',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${widget.eventData['title']} - ${widget.eventData['dateRange']}\n${widget.eventData['location']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 6, color: Color(0xFFF1F5F9)),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TICKETS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _dates.length,
                            itemBuilder: (context, index) {
                              final item = _dates[index];
                              final isSelected = _selectedDate == item['date'];

                              return GestureDetector(
                                onTap: () => setState(() => _selectedDate = item['date']!),
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF7E22CE) : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF7E22CE) : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['date']!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? Colors.white : const Color(0xFF001935),
                                        ),
                                      ),
                                      if (item['day']!.isNotEmpty)
                                        Text(
                                          item['day']!,
                                          style: TextStyle(fontSize: 9, color: isSelected ? Colors.white70 : Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredSchedule.length,
                          itemBuilder: (context, idx) {
                            final show = filteredSchedule[idx];
                            final isSoldOut = show['status'] == 'SOLD OUT';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    show['title']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001935)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    show['venue']!,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    show['desc']!,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 38,
                                    child: ElevatedButton(
                                      onPressed: isSoldOut ? null : () => _proceedToBooking(show),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSoldOut ? Colors.grey.shade400 : const Color(0xFF001935),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: Text(
                                        isSoldOut ? 'SOLD OUT!' : 'BELI TIKET',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 6, color: Color(0xFFF1F5F9)),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('📲 ', style: TextStyle(fontSize: 16)),
                            Text('ABOUT THIS EVENT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Memasuki tahun keenam penyelenggaraannya, Jakarta Film Week kembali menghadirkan ruang kreatif yang mendorong perkembangan industri film Indonesia untuk bersaing di tingkat internasional...',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 6, color: Color(0xFFF1F5F9)),

                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: 'TIX ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF001935))),
                              TextSpan(text: 'EVENTS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.purple)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '© 2026 TIX ID - PT NUSANTARA ELANG SEJAHTERA.\nALL RIGHTS RESERVED.',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  final availableShow = _allSchedule.firstWhere((e) => e['status'] == 'AVAILABLE', orElse: () => _allSchedule.first);
                  _proceedToBooking(availableShow);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('BUY TICKET', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// 2. PAGE 1: BOOKING DETAILS
// ------------------------------------------------------------------
class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, String> showData;

  const BookingDetailsScreen({
    super.key,
    required this.eventData,
    required this.showData,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late Timer _timer;
  int _secondsLeft = 120;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isNameFilled = false;
  bool _isEmailFilled = false;
  bool _isPhoneFilled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    final authName = AuthService().name;
    final authPhone = AuthService().phone;

    if (authName.isNotEmpty && authName != "User MyTix") {
      _nameController.text = authName;
      _isNameFilled = true;
    }
    if (authPhone.isNotEmpty && authPhone != "081234567890") {
      _phoneController.text = authPhone;
      _isPhoneFilled = true;
    }

    _nameController.addListener(() {
      if (mounted) setState(() => _isNameFilled = _nameController.text.trim().isNotEmpty);
    });
    _emailController.addListener(() {
      if (mounted) setState(() => _isEmailFilled = _emailController.text.trim().isNotEmpty);
    });
    _phoneController.addListener(() {
      if (mounted) setState(() => _isPhoneFilled = _phoneController.text.trim().isNotEmpty);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
      } else {
        _timer.cancel();
        _showTimeOutDialog();
      }
    });
  }

  void _showTimeOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Waktu Pemesanan Habis'),
        content: const Text('Batas waktu pemesanan telah habis (2 menit). Silakan ulangi kembali.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showEmailConfirmationDialog() {
    if (!_isNameFilled || !_isEmailFilled || !_isPhoneFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap lengkapi semua data pemesan terlebih dahulu!'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.purple.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.mark_email_read_rounded, color: Color(0xFF7E22CE), size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Make sure your email is valid, active, and has enough storage to receive your e-ticket',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001935), height: 1.4),
            ),
            const SizedBox(height: 6),
            Text('Your ticket will be sent to this email', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_rounded, color: Color(0xFF7E22CE), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _emailController.text,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text("This information cannot be changed after you click 'Continue'", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinishOrderPaymentScreen(
                            eventData: widget.eventData,
                            showData: widget.showData,
                            userName: _nameController.text.trim(),
                            userEmail: _emailController.text.trim(),
                            userPhone: _phoneController.text.trim(),
                            initialSecondsLeft: _secondsLeft,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFFFFB800),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Continue', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool isFilled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isFilled ? const Color(0xFF001935) : Colors.grey.shade300, width: isFilled ? 1.5 : 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)),
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.normal),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Icon(
            isFilled ? Icons.check_circle : Icons.check_circle_outline,
            color: isFilled ? const Color(0xFF0066FF) : Colors.grey.shade300,
            size: 22,
          ),
        ],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF001935), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('BOOKING DETAILS', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Finish your order in', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          _formatTime(_secondsLeft),
                          style: const TextStyle(color: Color(0xFFBE185D), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 12, color: Color(0xFF9D174D), height: 1.4),
                              children: [
                                TextSpan(text: 'Make sure all the informations is correct. You '),
                                TextSpan(text: 'cannot', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' change it later. We\'ll send the e-ticket to the email address as declared on this page.'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Color(0xFFF472B6), shape: BoxShape.circle),
                          child: const Text('!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildModernTextField(
                    controller: _nameController,
                    labelText: 'Nama Lengkap',
                    hintText: 'Ketik nama sesuai KTP / Passport',
                    isFilled: _isNameFilled,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('Use the same name as your KTP or Passport', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ),

                  const SizedBox(height: 16),

                  _buildModernTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'contoh: nama@email.com',
                    isFilled: _isEmailFilled,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('Tickets will be sent to this email', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Container(
                        width: 95,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          children: [
                            Text('🇮🇩 +62', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
                            Spacer(),
                            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildModernTextField(
                          controller: _phoneController,
                          labelText: 'Nomor Handphone',
                          hintText: '8123456789',
                          isFilled: _isPhoneFilled,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ACTUAL PAY', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text('Extra charges may apply', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(widget.eventData['price'] ?? 'Rp 4.000', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                        const Icon(Icons.arrow_drop_up),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _showEmailConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('CONTINUE', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 13)),
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
// 3. PAGE 2: FINISH YOUR ORDER & PAYMENT METHODS
// ------------------------------------------------------------------
class FinishOrderPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, String> showData;
  final String userName;
  final String userEmail;
  final String userPhone;
  final int initialSecondsLeft;

  const FinishOrderPaymentScreen({
    super.key,
    required this.eventData,
    required this.showData,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.initialSecondsLeft,
  });

  @override
  State<FinishOrderPaymentScreen> createState() => _FinishOrderPaymentScreenState();
}

class _FinishOrderPaymentScreenState extends State<FinishOrderPaymentScreen> {
  late Timer _timer;
  late int _secondsLeft;

  String _selectedPaymentMethod = 'QRIS';
  bool _agreeTixEvents = true;
  bool _agreeJakartaFilmWeek = true;

  final List<Map<String, String>> _methods = const [
    {'name': 'DANA', 'code': 'DANA'},
    {'name': 'Gopay', 'code': 'GOPAY'},
    {'name': 'OVO', 'code': 'OVO'},
    {'name': 'ShopeePay', 'code': 'SHOPEEPAY'},
    {'name': 'LinkAja', 'code': 'LINKAJA'},
    {'name': 'QRIS', 'code': 'QRIS'},
  ];

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.initialSecondsLeft;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
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

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
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
        title: const Text('PAYMENT METHODS', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF001935)),
            onPressed: () {},
          )
        ],
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
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.eventData['image']!,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 54, height: 54, color: const Color(0xFF001935)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.eventData['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF001935))),
                              const SizedBox(height: 4),
                              Text('${widget.eventData['dateRange']}, ${widget.eventData['time']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Finish your order in', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          _formatTime(_secondsLeft),
                          style: const TextStyle(color: Color(0xFFBE185D), fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 10),
                        Text('1x  ${widget.showData['title']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 2),
                        Text('1 Ticket', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Booking Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 8),
                        Text(widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
                        const SizedBox(height: 2),
                        Text(widget.userEmail, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        const SizedBox(height: 2),
                        Text('+62 ${widget.userPhone}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded, color: Colors.purple, size: 20),
                      SizedBox(width: 8),
                      Text('PAYMENT METHODS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.purple.shade300, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.03),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('E-Wallet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple.shade800)),
                              const Icon(Icons.keyboard_arrow_up, color: Colors.purple),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _methods.length,
                          itemBuilder: (context, idx) {
                            final method = _methods[idx];
                            final isSelected = _selectedPaymentMethod == method['code'];

                            return InkWell(
                              onTap: () => setState(() => _selectedPaymentMethod = method['code']!),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.purple.shade50.withOpacity(0.4) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: method['code']!,
                                      groupValue: _selectedPaymentMethod,
                                      onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                                      activeColor: const Color(0xFF001935),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(method['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(method['name']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple.shade700)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeTixEvents,
                              onChanged: (v) => setState(() => _agreeTixEvents = v ?? false),
                              activeColor: const Color(0xFF0066FF),
                            ),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 11, color: Colors.black87),
                                  children: [
                                    TextSpan(text: 'I agree to TIX EVENTS '),
                                    TextSpan(text: 'Terms & Conditions', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' and '),
                                    TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeJakartaFilmWeek,
                              onChanged: (v) => setState(() => _agreeJakartaFilmWeek = v ?? false),
                              activeColor: const Color(0xFF0066FF),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                                  children: [
                                    const TextSpan(text: 'I agree to '),
                                    TextSpan(text: '${widget.eventData['title']} Terms and Conditions', style: const TextStyle(color: Color(0xFF0066FF), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ACTUAL PAY', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text('Extra charges may apply', style: TextStyle(fontSize: 9, color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(widget.eventData['price'] ?? 'Rp 4.000', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                        const Icon(Icons.arrow_drop_up),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentQRScreen(
                            eventData: widget.eventData,
                            showData: widget.showData,
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                            userPhone: widget.userPhone,
                            paymentMethod: _selectedPaymentMethod,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('PAY NOW', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 13)),
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
// 4. DISPLAY QRIS COUNTDOWN & PENYIMPANAN KE PHP MYADMIN
// ------------------------------------------------------------------
class PaymentQRScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, String> showData;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String paymentMethod;

  const PaymentQRScreen({
    super.key,
    required this.eventData,
    required this.showData,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    this.paymentMethod = 'QRIS',
  });

  @override
  State<PaymentQRScreen> createState() => _PaymentQRScreenState();
}

class _PaymentQRScreenState extends State<PaymentQRScreen> {
  late Timer _timer;
  int _secondsLeft = 120;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
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

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _submitPayment() async {
    setState(() => _isLoading = true);

    final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String host = kIsWeb ? 'localhost' : '10.0.2.2';
    final String apiUrl = "http://$host/mytix_api/save_event_order.php?t=$timeStamp";

    bool isSuccess = false;
    String orderId = '';
    String errorDetail = '';

    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": widget.userName.isNotEmpty ? widget.userName : "Angela",
          "email": widget.userEmail.isNotEmpty ? widget.userEmail : "user@mytix.com",
          "phone": widget.userPhone.isNotEmpty ? widget.userPhone : "081234567890",
          "event_slug": widget.eventData['id'] ?? 'jfw-2026',
          "event_title": widget.eventData['title'] ?? 'Jakarta Film Week 2026',
          "show_title": widget.showData['title'] ?? 'Program Event',
          "event_date": widget.showData['date'] ?? '21 OCT',
          "venue": widget.showData['venue'] ?? 'CGV GRAND INDONESIA',
          "total_price": widget.eventData['priceRaw'] ?? 4000,
          "payment_method": widget.paymentMethod,
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200 && res.body.trim().isNotEmpty) {
        final resData = jsonDecode(res.body);
        if (resData['status'] == 'success') {
          isSuccess = true;
          orderId = resData['order_id'] ?? 'EVT-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
        } else {
          errorDetail = resData['message'] ?? 'Status PHP bukan success';
        }
      } else {
        errorDetail = "HTTP Status: ${res.statusCode} | Body: ${res.body}";
      }
    } catch (e) {
      debugPrint("API Error: $e");
      errorDetail = e.toString();
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (isSuccess && orderId.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TicketReceiptScreen(
            username: widget.userName.isNotEmpty ? widget.userName : "Angela",
            showTitle: widget.showData['title']!,
            venue: widget.showData['venue']!,
            eventDate: widget.showData['date']!,
            price: widget.eventData['price'] ?? 'Rp 4.000',
            orderId: orderId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Simpan DB! $errorDetail"),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF001935), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('PEMBAYARAN ${widget.paymentMethod}', style: const TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Scan QR Code Di Bawah Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
            const SizedBox(height: 6),
            Text('Selesaikan pembayaran sebelum batas waktu habis', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(20)),
              child: Text(
                _formatTime(_secondsLeft),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFBE185D)),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                children: [
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=MYTIX-QRIS-PAYMENT',
                    height: 200,
                    width: 200,
                    errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_2_rounded, size: 180, color: Color(0xFF001935)),
                  ),
                  const SizedBox(height: 12),
                  const Text('QRIS National Standard', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitPayment,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF001935), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('KONFIRMASI SUDAH BAYAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 5. NOTA TIKET HASIL PENYIMPANAN KE PHPMYADMIN (KEMBALI KE HOME)
// ------------------------------------------------------------------
class TicketReceiptScreen extends StatelessWidget {
  final String username;
  final String showTitle;
  final String venue;
  final String eventDate;
  final String price;
  final String orderId;

  const TicketReceiptScreen({
    super.key,
    required this.username,
    required this.showTitle,
    required this.venue,
    required this.eventDate,
    required this.price,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Text('NOTA TIKET EVENT', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 54),
                  const SizedBox(height: 10),
                  const Text('PEMESANAN BERHASIL!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                  const SizedBox(height: 4),
                  Text('Halo $username, tiket $showTitle telah tersimpan di phpMyAdmin.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                    child: Text('Kode Tiket: $orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
                  ),

                  const Divider(height: 30, thickness: 1),

                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$orderId',
                    height: 140,
                    width: 140,
                    errorBuilder: (_, __, ___) => const Icon(Icons.qr_code_scanner, size: 120),
                  ),
                  const SizedBox(height: 8),
                  Text('SCAN DI VENUE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey.shade500)),

                  const Divider(height: 30, thickness: 1),

                  _buildReceiptRow('Nama Pemesan', username),
                  const SizedBox(height: 8),
                  _buildReceiptRow('Judul Program', showTitle),
                  const SizedBox(height: 8),
                  _buildReceiptRow('Tanggal Event', eventDate),
                  const SizedBox(height: 8),
                  _buildReceiptRow('Lokasi Penukaran', venue),
                  const SizedBox(height: 8),
                  _buildReceiptRow('Total Harga', price),
                  const SizedBox(height: 8),
                  _buildReceiptRow('Status Pembayaran', 'LUNAS (SUCCESS)'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  // Kembali ke halaman beranda utama
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001935),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('SELESAI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
          ),
        ),
      ],
    );
  }
}