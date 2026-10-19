import 'dart:async';
import 'package:flutter/material.dart';
import 'movie_detail_screen.dart';
import 'cinema_list_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'tix_food_screen.dart';
import 'tix_event_screen.dart';
import 'cares_event_detail_screen.dart';
import 'rental_movies_screen.dart';
import 'upcoming_detail_screen.dart';
import 'my_cinema_screen.dart';
import 'my_tickets_screen.dart';

class MyTixHomeScreen extends StatefulWidget {
  const MyTixHomeScreen({super.key});

  @override
  State<MyTixHomeScreen> createState() => _MyTixHomeScreenState();
}

class _MyTixHomeScreenState extends State<MyTixHomeScreen> {
  String _selectedCinema = 'Semua Film';
  int _navIndex = 0;

  late final PageController _bannerController;
  late final Timer _bannerTimer;
  int _currentBannerIndex = 0;

  late final PageController _nowShowingController;
  int _currentMovieIndex = 0;

  final List<String> _bannerImages = const [
    'assets/images/info1.jpg',
    'assets/images/info2.jpg',
    'assets/images/info3.jpg',
    'assets/images/info4.jpg',
    'assets/images/info5.jpg',
  ];

  final List<Map<String, dynamic>> _nowShowingMovies = const [
    {
      'title': 'KUASA GELAP: PERJANJIAN DAR...',
      'rating': '9.3',
      'ageRating': 'R13+',
      'genre': 'Horror',
      'poster': 'assets/images/kuasa_gelap.jpg',
      'desc': 'Wah, banyak yang suka film ini! Dengan rating ⭐ 9.3 kamu wajib nonton!',
      'cinemas': ['XXI', 'CGV', 'Cinépolis']
    },
    {
      'title': 'STREET FIGHTER',
      'rating': '8.8',
      'ageRating': 'R13+',
      'genre': 'Action / Sci-Fi',
      'poster': 'assets/images/street_fighter.jpg',
      'desc': 'Aksi pertarungan seru yang penuh kejutan di setiap detiknya!',
      'cinemas': ['XXI', 'CGV']
    },
    {
      'title': 'IBU, BAGAIMANA AKU TANPAMU?',
      'rating': '9.1',
      'ageRating': 'SU',
      'genre': 'Drama / Family',
      'poster': 'assets/images/ibu.jpg',
      'desc': 'Kisah haru perjuangan seorang ibu yang menyentuh hati.',
      'cinemas': ['XXI', 'Cinépolis']
    },
    {
      'title': 'OTHER MOMMY',
      'rating': '8.5',
      'ageRating': 'D17+',
      'genre': 'Horror / Thriller',
      'poster': 'assets/images/other_mommy.jpg',
      'desc': 'Ketegangan misteri keluarga yang meneror pikiranmu.',
      'cinemas': ['CGV', 'Cinépolis']
    },
    {
      'title': 'WARGA RUSUN 609',
      'rating': '8.7',
      'ageRating': 'R13+',
      'genre': 'Comedy / Horror',
      'poster': 'assets/images/warga_rusun.jpg',
      'desc': 'Penghuni rumah susun unit 609 mendapati kejadian-kejadian mistis dan konyol.',
      'cinemas': ['XXI', 'CGV', 'Cinépolis']
    },
  ];

  final List<Map<String, dynamic>> _upcomingMovies = const [
    {
      'title': 'PULANG KAMPUNG',
      'releaseDate': '26 Nov 2026',
      'poster': 'assets/images/pulang_kampung.jpg',
      'cinemas': ['XXI', 'CINÉPOLIS']
    },
    {
      'title': 'BEWARE BOIÚNA',
      'releaseDate': '16 Okt 2026',
      'poster': 'assets/images/beware.jpg',
      'cinemas': ['XXI', 'CGV']
    },
    {
      'title': 'TENTANG SUATU TEMPAT DI WILAYAH KUNING',
      'releaseDate': '16 Okt 2026',
      'poster': 'assets/images/tentangsuatutempat.jpg',
      'cinemas': ['CGV', 'CINÉPOLIS']
    },
    {
      'title': 'CLAYFACE',
      'releaseDate': '21 Okt 2026',
      'poster': 'assets/images/clayface.jpg',
      'cinemas': ['XXI', 'CGV', 'CINÉPOLIS']
    },
    {
      'title': 'SITI SITI',
      'releaseDate': '22 Okt 2026',
      'poster': 'assets/images/sitisivampir.jpg',
      'cinemas': ['XXI', 'CGV']
    },
    {
      'title': 'PIRUNDUK',
      'releaseDate': '22 Okt 2026',
      'poster': 'assets/images/pirunduk.jpg',
      'cinemas': ['XXI', 'CINÉPOLIS']
    },
  ];

  final List<Map<String, dynamic>> _tixFoodItems = const [
    {
      'title': 'SNACK ATTACK',
      'desc': 'Popcorn Salt/Sweet + Java Tea + Donut',
      'price': 'Rp50.000',
      'image': 'assets/images/snackattack.jpg',
    },
    {
      'title': 'CLASSIC COMBO',
      'desc': 'Popcorn Salt/Sweet Glaze/Mix + Coca-Cola Zero',
      'price': 'Rp50.000',
      'image': 'assets/images/classiccombo.jpg',
    },
    {
      'title': 'STIXX PANDAN KAYA',
      'desc': 'Pandan Srikaya Pretzels + Coconut Flakes',
      'price': 'Rp35.000',
      'image': 'assets/images/stixxpandan.jpg',
    },
    {
      'title': 'FAMILY COMBO',
      'desc': 'Popcorn Tower + 2 Soft Drink (L)',
      'price': 'Rp200.000',
      'image': 'assets/images/familycombo.jpg',
    },
    {
      'title': 'PAKET GOOLLL!',
      'desc': 'Popcorn Salt (M) + Croffle + Coca Cola Can',
      'price': 'Rp100.000',
      'image': 'assets/images/paketgool.jpg',
    },
  ];

  final List<Map<String, dynamic>> _tixEvents = const [
    {
      'id': 'jfw-2026',
      'title': 'Jakarta Film Week 2026',
      'category': 'OTHERS',
      'dateRange': '21 - 25 Oktober 2026',
      'time': '13.00 - End',
      'location': 'CGV Grand Indonesia, CGV fX Sudirman...',
      'price': 'Rp4.000',
      'image': 'assets/images/jakartafilmweek.jpg',
    },
    {
      'id': 'cares-2026',
      'title': 'CARES 2026',
      'category': 'SEMINAR',
      'dateRange': '31 Oktober 2026',
      'time': '08.00 - 17.00 WIB',
      'location': 'Westin Jakarta',
      'price': 'Rp200.000',
      'image': 'assets/images/cares.jpg',
    },
  ];

  final List<Map<String, String>> _rentalMovies = const [
    {'title': 'NOW YOU SEE ME', 'image': 'assets/images/now.jpg'},
    {'title': 'THE CONJURING', 'image': 'assets/images/theconjuring.jpg'},
    {'title': 'THE NUN II', 'image': 'assets/images/thenun.jpg'},
    {'title': 'SMURFS : THE LOST VILLAGE', 'image': 'assets/images/smurfs.jpg'},
    {'title': 'MAN OF STEEL', 'image': 'assets/images/man.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _nowShowingController = PageController(viewportFraction: 0.68);

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _bannerImages.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerController.dispose();
    _nowShowingController.dispose();
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
            Text('Bantuan MyTix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Butuh bantuan pemesanan atau kendala tiket? Hubungi Customer Service kami di support@mytix.id atau Call Center: 1500-123.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('TUTUP')),
        ],
      ),
    );
  }

  void _showProfileModal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _openMovieDetail(Map<String, dynamic> movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movieData: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _nowShowingMovies.where((movie) {
      if (_selectedCinema == 'Semua Film') return true;
      final cinemas = movie['cinemas'] as List<String>?;
      return cinemas != null && cinemas.contains(_selectedCinema);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCinemaScreen()));
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                SizedBox(width: 8),
                Text('Cari di MyTix...', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Color(0xFF001935), size: 22),
            onPressed: _showHelpDialog,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF001935), size: 22),
            onPressed: _showProfileModal,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF001935), size: 22),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARIS LOKASI DENGAN CARD MODERN
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCinemaScreen()));
                },
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded, color: Color(0xFF0284C7), size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text('SURABAYA', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF001935), letterSpacing: 0.5)),
                    const SizedBox(width: 2),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF001935), size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BANNER SLIDER
            SizedBox(
              height: 170,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _bannerController,
                    itemCount: _bannerImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TixEventsScreen()));
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  _bannerImages[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF001935), Color(0xFF0284C7)],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Beli tiket bioskop sekaligus event lebih hemat di MyTix',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _bannerImages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          width: _currentBannerIndex == index ? 22 : 6,
                          decoration: BoxDecoration(
                            color: _currentBannerIndex == index
                                ? const Color(0xFF0284C7)
                                : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 1. SEDANG TAYANG
            _buildSectionHeader(
              '🎬 Sedang Tayang', 
              'Film seru pilihan yang tayang di bioskop',
              onTapAll: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CinemaListScreen(initialTabIndex: 0)));
              },
            ),
            const SizedBox(height: 10),

            // CHIPS KATEGORI BIOSKOP
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['Semua Film', 'XXI', 'CGV', 'Cinépolis', 'Watchlist Saya'].map((c) {
                  final active = _selectedCinema == c;
                  final isWatchlist = c == 'Watchlist Saya';
                  return InkWell(
                    onTap: () => setState(() => _selectedCinema = c),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF001935) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? const Color(0xFF001935) : Colors.grey.shade300,
                          width: 1.2,
                        ),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF001935).withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          if (isWatchlist) ...[
                            Icon(Icons.favorite, size: 14, color: active ? Colors.redAccent : Colors.red),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            c,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: active ? FontWeight.bold : FontWeight.w600,
                              color: active ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // CAROUSEL SEDANG TAYANG
            SizedBox(
              height: 380,
              child: PageView.builder(
                controller: _nowShowingController,
                itemCount: filteredMovies.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentMovieIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = filteredMovies[index];
                  final isSelected = index == _currentMovieIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: isSelected ? 0 : 18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF001935),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isSelected ? 0.25 : 0.08),
                          blurRadius: isSelected ? 16 : 6,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openMovieDetail(item),
                        borderRadius: BorderRadius.circular(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                item['poster'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: const Color(0xFF001935),
                                  child: Center(
                                    child: Text(
                                      item['title'] ?? '',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),

                              // BADGE RATING DAN USIA
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                      const SizedBox(width: 3),
                                      Text(
                                        item['rating'] ?? '8.0',
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0284C7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['ageRating'] ?? '',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              // TOMBOL BELI TIKET MODERN
                              if (isSelected)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF001935), Color(0xFF0F172A)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.confirmation_number_rounded, color: Color(0xFF38BDF8), size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'BELI TIKET',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (filteredMovies.isNotEmpty)
              InkWell(
                onTap: () => _openMovieDetail(filteredMovies[_currentMovieIndex % filteredMovies.length]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        filteredMovies[_currentMovieIndex % filteredMovies.length]['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF001935),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        filteredMovies[_currentMovieIndex % filteredMovies.length]['desc'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            const Divider(height: 32, thickness: 1, color: Color(0xFFE2E8F0)),

            // 2. AKAN TAYANG
            _buildSectionHeader(
              '⏳ Akan Tayang', 
              'Segera tayang di bioskop kesayanganmu',
              onTapAll: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CinemaListScreen(initialTabIndex: 1)));
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _upcomingMovies.length,
                itemBuilder: (context, index) {
                  final item = _upcomingMovies[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpcomingDetailScreen(movieData: item),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: _buildUpcomingCard(
                      title: item['title'] ?? '',
                      releaseDate: item['releaseDate'] ?? '',
                      cinemas: List<String>.from(item['cinemas'] ?? []),
                      assetPath: item['poster'] ?? '',
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 32, thickness: 1, color: Color(0xFFE2E8F0)),

            // 3. TIX FOOD
            _buildSectionHeader(
              '🍿 TIX Food', 
              'Nonton lebih asik bareng camilan favoritmu!',
              onTapAll: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TixFoodScreen()));
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 235,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tixFoodItems.length,
                itemBuilder: (context, index) {
                  final food = _tixFoodItems[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TixFoodScreen()));
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _buildFoodCard(
                      food['title']!,
                      food['desc']!,
                      food['price']!,
                      food['image']!,
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 32, thickness: 1, color: Color(0xFFE2E8F0)),

            // 4. TIX EVENT
            _buildSectionHeader(
              '🎟️ TIX Event', 
              'Rasakan serunya, nikmati pengalamannya!',
              onTapAll: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TixEventsScreen()));
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 275,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tixEvents.length,
                itemBuilder: (context, index) {
                  final event = _tixEvents[index];
                  return InkWell(
                    onTap: () {
                      if (event['id'] == 'cares-2026') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CaresEventDetailScreen(eventData: event),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailScreen(eventData: event),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: _buildEventCard(
                      event['title']!,
                      event['location']!,
                      event['price']!,
                      event['image']!,
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 32, thickness: 1, color: Color(0xFFE2E8F0)),

            // 5. SEWA FILM ONLINE
            _buildSectionHeader(
              '▶️ Sewa Film Online', 
              'Sewa dan tonton film menarik kapanpun!',
              onTapAll: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RentalMoviesScreen()));
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _rentalMovies.length,
                itemBuilder: (context, index) {
                  final movie = _rentalMovies[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RentalMoviesScreen()));
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: _buildRentalCard(
                      movie['title']!,
                      movie['image']!,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyCinemaScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTicketsScreen(
                  onGoToHome: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          } else {
            setState(() => _navIndex = index);
          }
        },
        selectedItemColor: const Color(0xFF001935),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: 'Bioskop'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Tiket'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? subtitle, {required VoidCallback onTapAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ]
            ],
          ),
          InkWell(
            onTap: onTapAll,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF), 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: const Row(
                children: [
                  Text('Semua', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                  Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF0284C7)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard({
    required String title,
    required String releaseDate,
    required List<String> cinemas,
    required String assetPath,
  }) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF001935),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF001935),
                  child: const Center(child: Icon(Icons.movie, color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF001935)), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: cinemas.map((c) => Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
              child: Text(c, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black87)),
            )).toList(),
          ),
          const SizedBox(height: 2),
          Text('Rilis: $releaseDate', style: const TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFoodCard(String title, String desc, String price, String assetPath) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 85,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF001935),
                  child: const Center(
                    child: Icon(Icons.fastfood, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF001935)), maxLines: 1),
          Text(desc, style: const TextStyle(fontSize: 9, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF001935))),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TixFoodScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001935),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'BELI SEKARANG',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String location, String price, String assetPath) {
    return Container(
      width: 310,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF001935),
                  child: const Center(
                    child: Icon(Icons.event, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001935),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          children: [
                            const TextSpan(text: 'Mulai '),
                            TextSpan(
                              text: price,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF001935),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildRentalCard(String title, String assetPath) {
    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF001935),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF001935),
                  child: const Center(
                    child: Icon(Icons.movie_outlined, color: Colors.white, size: 36),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF001935),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}