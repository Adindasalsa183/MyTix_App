import 'package:flutter/material.dart';
import 'tix_event_screen.dart'; // Import untuk mengarahkan ke BookingDetailsScreen

class CaresEventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const CaresEventDetailScreen({
    super.key,
    required this.eventData,
  });

  @override
  State<CaresEventDetailScreen> createState() => _CaresEventDetailScreenState();
}

class _CaresEventDetailScreenState extends State<CaresEventDetailScreen> {
  // Tiket default terpilih untuk pembelian
  Map<String, String> _selectedTicket = {
    'title': 'SYMPOSIUM + WORKSHOP FROM INDICATION TO INSERTION FOR GP | Presale',
    'price': 'Rp 500.000',
    'priceRaw': '500000',
    'venue': 'The Westin Hotel Jakarta',
    'date': '31 OCT 2026',
  };

  void _proceedToBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          eventData: {
            'id': widget.eventData['id'] ?? 'cares-2026',
            'title': widget.eventData['title'] ?? 'CARES 2026',
            'category': 'CONFERENCE',
            'dateRange': '31 Oktober 2026',
            'time': '07.00 - End',
            'location': 'The Westin Hotel Jakarta',
            'price': _selectedTicket['price']!,
            'priceRaw': int.tryParse(_selectedTicket['priceRaw']!) ?? 500000,
            'image': widget.eventData['image'] ?? 'assets/images/cares.jpg',
          },
          showData: {
            'title': _selectedTicket['title']!,
            'venue': 'The Westin Hotel Jakarta',
            'date': '31 OCT 2026',
          },
        ),
      ),
    );
  }

  Widget _buildTicketCard({
    required String title,
    required String price,
    required String priceRaw,
    bool isSoldOut = false,
  }) {
    final bool isSelected = _selectedTicket['title'] == title;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF7E22CE) : Colors.grey.shade300,
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF001935),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 0.8),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Color(0xFF001935),
                ),
              ),
              if (isSoldOut)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SOLD OUT!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTicket = {
                        'title': title,
                        'price': price,
                        'priceRaw': priceRaw,
                        'venue': 'The Westin Hotel Jakarta',
                        'date': '31 OCT 2026',
                      };
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? const Color(0xFF7E22CE) : const Color(0xFF9333EA),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    isSelected ? 'Selected' : 'Select Ticket',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
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
        title: const Text(
          'TIX EVENTS',
          style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
                  // Banner Header
                  ClipRRect(
                    child: Image.asset(
                      widget.eventData['image'] ?? 'assets/images/cares.jpg',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: const Color(0xFF001935),
                        child: const Center(
                          child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),

                  // Event Info & Deskripsi
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CARES 2026',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                          child: const Text(
                            'CONFERENCE',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'CARES 2026 brings together the cardiovascular community to navigate the complexities of modern clinical care—from evidence to bedside decisions. Through engaging Symposium, Lunch Symposium, and hands-on Workshops, the program explores challenging cases, evolving strategies, and practical skills across cardiovascular medicine. This year, CARES goes beyond traditional boundaries, welcoming medical students, interns, general practitioners, specialists, and nurses to learn, exchange perspectives, and grow together. Join us at the clinical crossroads, where knowledge meets collaboration and every decision matters.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 1),

                  // Date, Time, Location Section
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF001935)),
                            SizedBox(width: 6),
                            Text('DATE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Saturday, 31 October 2026',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF001935)),
                            SizedBox(width: 6),
                            Text('TIME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '7 AM - end',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF001935)),
                            SizedBox(width: 6),
                            Text('LOCATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Westin Jakarta',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // TICKETS SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🎟️ ', style: TextStyle(fontSize: 18)),
                            Text('TICKETS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // CATEGORY 1: Presale for GP
                        const Text('Presale for GP', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 10),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP FROM INDICATION TO INSERTION FOR GP | Presale',
                          price: 'Rp 500.000',
                          priceRaw: '500000',
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM FOR GP | Presale',
                          price: 'Rp 350.000',
                          priceRaw: '350000',
                          isSoldOut: true,
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP LIPID MASTERCLASS FOR GP | Presale',
                          price: 'Rp 500.000',
                          priceRaw: '500000',
                          isSoldOut: true,
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP EMERGENCY ECG FOR GP | Presale',
                          price: 'Rp 500.000',
                          priceRaw: '500000',
                          isSoldOut: true,
                        ),

                        const SizedBox(height: 20),

                        // CATEGORY 2: General Practitioner, Ners and Student
                        const Text('General Practitioner, Ners and Student', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 10),
                        _buildTicketCard(
                          title: 'SYMPOSIUM FOR GP',
                          price: 'Rp 500.000',
                          priceRaw: '500000',
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM FOR MEDICAL STUDENT',
                          price: 'Rp 250.000',
                          priceRaw: '250000',
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP LIPID MASTERCLASS FOR GP',
                          price: 'Rp 700.000',
                          priceRaw: '700000',
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP EMERGENCY ECG FOR GP',
                          price: 'Rp 700.000',
                          priceRaw: '700000',
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP FROM INDICATION TO INSERTION FOR GP',
                          price: 'Rp 700.000',
                          priceRaw: '700000',
                        ),
                        _buildTicketCard(
                          title: 'WORKSHOP ModernPCI: SEE Beyond Angiography - Physiology (FFR) & Intravascular Imaging (IVUS) Cathlab Nurse',
                          price: 'Rp 200.000',
                          priceRaw: '200000',
                        ),
                        _buildTicketCard(
                          title: 'SYMPOSIUM + WORKSHOP Modern PCI: SEE Beyond Angiography - Physiology (FFR) & Intravascular Imaging (IVUS)',
                          price: 'Rp 200.000',
                          priceRaw: '200000',
                        ),

                        const SizedBox(height: 20),

                        // CATEGORY 3: Specialist Doctor
                        const Text('Specialist Doctor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                        const SizedBox(height: 10),
                        _buildTicketCard(
                          title: 'SYMPOSIUM FOR Specialist',
                          price: 'Rp 1.000.000',
                          priceRaw: '1000000',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ABOUT THIS EVENT SECTION
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🧾 ', style: TextStyle(fontSize: 18)),
                            Text('ABOUT THIS EVENT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF001935))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF001935),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'HEARTOLOGY CARDIOVASCULAR HOSPITAL',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Center(
                                child: Text(
                                  'CARES 2026',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                                ),
                              ),
                              const Center(
                                child: Text(
                                  'CARDIAC & VASCULAR EXCELLENCE SCIENTIFIC UPDATE 2026',
                                  style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Symposium (7 AM - 11 AM)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                                    Text('• Valvular Heart Disease MS/AS', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    Text('• Varicose Veins/Chronic Venous Disease', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    Text('• Atrial Fibrillation', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    const Divider(height: 16),
                                    const Text('Workshop (1 PM - 4 PM)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                                    Text('• Lipid Masterclass', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    Text('• Emergency ECG for GP', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    Text('• From Indication to Insertion', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    Text('• Patent Foramen Ovale (PFO)', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                    Text('• Modern PCI', style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DOWNLOAD TIX ID APP BANNER
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001935),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_iphone_rounded, color: Colors.white, size: 36),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Download TIX ID APP!',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'More Convenient, Easier Than Ever.',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PAYMENT PARTNER LOGOS
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Multiple payment methods available for your convenience.',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildPaymentLogoBadge('JCB'),
                            _buildPaymentLogoBadge('Mastercard'),
                            _buildPaymentLogoBadge('VISA'),
                            _buildPaymentLogoBadge('BCA'),
                            _buildPaymentLogoBadge('Mandiri'),
                            _buildPaymentLogoBadge('BNI'),
                            _buildPaymentLogoBadge('BRI'),
                            _buildPaymentLogoBadge('DANA'),
                            _buildPaymentLogoBadge('GoPay'),
                            _buildPaymentLogoBadge('OVO'),
                            _buildPaymentLogoBadge('ShopeePay'),
                            _buildPaymentLogoBadge('LinkAja'),
                            _buildPaymentLogoBadge('QRIS'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // FOOTER TIX EVENTS
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF1F5F9),
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    child: Column(
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: 'TIX ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF001935))),
                              TextSpan(text: 'EVENTS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.purple)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hassle-free solutions for your events! Sell ticket, on-site operational, payment, and data analytics to create amazing event.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'TERMS & CONDITIONS | PRIVACY POLICY | CONTACT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                        ),
                        const SizedBox(height: 16),
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

          // STICKY BOTTOM BUTTON "BUY TICKET"
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
              height: 48,
              child: ElevatedButton(
                onPressed: _proceedToBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB800),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  'BUY TICKET',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLogoBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
      ),
    );
  }
}