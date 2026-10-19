import 'package:flutter/material.dart';
import 'movie_detail_screen.dart';
import 'upcoming_detail_screen.dart'; // IMPORT FILE DETAIL AKAN TAYANG

class CinemaListScreen extends StatefulWidget {
  final int initialTabIndex; // 0: SEDANG TAYANG, 1: AKAN TAYANG
  const CinemaListScreen({super.key, this.initialTabIndex = 0});

  @override
  State<CinemaListScreen> createState() => _CinemaListScreenState();
}

class _CinemaListScreenState extends State<CinemaListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _nowShowing = const [
    {
      'title': 'KUASA GELAP: PERJANJIAN DAR...',
      'genre': 'Horror',
      'ageRating': 'R13+',
      'rating': '9.3',
      'poster': 'assets/images/kuasa_gelap.jpg',
      'cinemas': ['XXI', 'CGV', 'Cinépolis']
    },
    {
      'title': 'STREET FIGHTER',
      'genre': 'Action / Sci-Fi',
      'ageRating': 'R13+',
      'rating': '8.8',
      'poster': 'assets/images/street_fighter.jpg',
      'cinemas': ['XXI', 'CGV']
    },
    {
      'title': 'IBU, BAGAIMANA AKU TANPAMU?',
      'genre': 'Drama / Family',
      'ageRating': 'SU',
      'rating': '9.1',
      'poster': 'assets/images/ibu.jpg',
      'cinemas': ['XXI', 'Cinépolis']
    },
    {
      'title': 'OTHER MOMMY',
      'genre': 'Horror / Thriller',
      'ageRating': 'D17+',
      'rating': '8.5',
      'poster': 'assets/images/other_mommy.jpg',
      'cinemas': ['CGV', 'Cinépolis']
    },
    {
      'title': 'WARGA RUSUN 609',
      'genre': 'Comedy / Horror',
      'ageRating': 'R13+',
      'rating': '8.7',
      'poster': 'assets/images/warga_rusun.jpg',
      'cinemas': ['XXI', 'CGV', 'Cinépolis']
    },
  ];

  final List<Map<String, dynamic>> _upcoming = const [
    {
      'title': 'PULANG KAMPUNG',
      'genre': 'Drama, Musical',
      'releaseDate': '26 Nov 2026',
      'poster': 'assets/images/pulang_kampung.jpg',
    },
    {
      'title': 'BEWARE BOIÚNA',
      'genre': 'Horror',
      'releaseDate': '16 Okt 2026',
      'poster': 'assets/images/beware.jpg',
    },
    {
      'title': 'TENTANG SUATU TEMPAT DI WILAYAH KUNING',
      'genre': 'Misteri',
      'releaseDate': '16 Okt 2026',
      'poster': 'assets/images/tentangsuatutempat.jpg',
    },
    {
      'title': 'CLAYFACE',
      'genre': 'Action / Thriller',
      'releaseDate': '21 Okt 2026',
      'poster': 'assets/images/clayface.jpg',
    },
    {
      'title': 'SITI SITI',
      'genre': 'Drama / Family',
      'releaseDate': '22 Okt 2026',
      'poster': 'assets/images/sitisivampir.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Film Bioskop',
          style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF001935),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF001935),
          tabs: const [
            Tab(text: 'SEDANG TAYANG'),
            Tab(text: 'AKAN TAYANG'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieGrid(_nowShowing, isNowShowing: true),
          _buildMovieGrid(_upcoming, isNowShowing: false),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<Map<String, dynamic>> movies, {required bool isNowShowing}) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final item = movies[index];
        return GestureDetector(
          onTap: () {
            if (isNowShowing) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieDetailScreen(movieData: item)),
              );
            } else {
              // PERBAIKAN: JIKA AKAN TAYANG, BUKA UPCOMING DETAIL SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpcomingDetailScreen(movieData: item)),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item['poster'] ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF001935),
                      child: Center(
                        child: Text(item['title'] ?? '', style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                isNowShowing ? (item['genre'] ?? '') : 'Rilis: ${item['releaseDate']}',
                style: TextStyle(fontSize: 11, color: isNowShowing ? Colors.grey : Colors.blue),
              ),
            ],
          ),
        );
      },
    );
  }
}