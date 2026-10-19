import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const UpcomingDetailScreen({
    super.key,
    required this.movieData,
  });

  @override
  State<UpcomingDetailScreen> createState() => _UpcomingDetailScreenState();
}

class _UpcomingDetailScreenState extends State<UpcomingDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isWatchlisted = false;

  // Database Detail Real untuk Seluruh Film Akan Tayang
  final Map<String, Map<String, dynamic>> _upcomingDB = {
    'PULANG KAMPUNG': {
      'genre': 'Drama, Musical',
      'duration': '1 jam 45 mnt',
      'releaseDate': '26 November 2026',
      'ageRating': '13+',
      'director': 'Bene Dion Rajagukguk',
      'producer': 'Ernest Prakasa, Dipa Andika',
      'cast': 'Sastra Silalahi, Gita Bhebhita, Boris Bokir, Indra Jegel',
      'synopsis':
          'Seorang profesional muda terkemuka yang tinggal di Jakarta tiba-tiba dipanggil pulang ke kampung halaman leluhurnya di Sumatra Utara oleh sosok sesepuh keluarga untuk mencalonkan diri dalam pemilihan jabatan publik; di sana, ambisi politiknya bersinggungan dengan sebuah pengalaman romantis yang mengubah hidup.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'BEWARE BOIÚNA': {
      'genre': 'Horror, Thriller',
      'duration': '1 jam 38 mnt',
      'releaseDate': '16 Oktober 2026',
      'ageRating': '17+',
      'director': 'Rodrigo Aragão',
      'producer': 'Mayra Alarcón',
      'cast': 'Kika Sena, Mayra Alarcón, Roney Villela',
      'synopsis':
          'Ekspedisi ilmiah di sepanjang pedalaman sungai Amazon berubah menjadi teror mengerikan saat mereka memasuki wilayah kekuasaan Boiúna, ular raksasa mistis purba yang memangsa siapa saja yang merusak kelestarian hutan hujan.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'TENTANG SUATU TEMPAT DI WILAYAH KINKI': {
      'genre': 'Misteri, Psychological Horror',
      'duration': '1 jam 52 mnt',
      'releaseDate': '16 Oktober 2026',
      'ageRating': '17+',
      'director': 'Takashi Shimizu',
      'producer': 'Shinji Ogawa, Nobuaki Saho',
      'cast': 'Kanna Hashimoto, Daiki Shigeoka, Mayu Hotta',
      'synopsis':
          'Sebuah laporan investigasi dokumenter mengenai serangkaian hilangnya orang-orang secara misterius di wilayah Kinki, Jepang. Jejak petunjuk mengarah pada ritual terlarang kuno dan kaset tua yang menyimpan kutukan mengerikan.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'TENTANG SUATU TEMPAT DI WILAYAH KUNING': {
      'genre': 'Misteri, Psychological Horror',
      'duration': '1 jam 52 mnt',
      'releaseDate': '16 Oktober 2026',
      'ageRating': '17+',
      'director': 'Takashi Shimizu',
      'producer': 'Shinji Ogawa, Nobuaki Saho',
      'cast': 'Kanna Hashimoto, Daiki Shigeoka, Mayu Hotta',
      'synopsis':
          'Sebuah laporan investigasi dokumenter mengenai serangkaian hilangnya orang-orang secara misterius di wilayah Kinki, Jepang. Jejak petunjuk mengarah pada ritual terlarang kuno dan kaset tua yang menyimpan kutukan mengerikan.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'CLAYFACE': {
      'genre': 'Action, Sci-Fi, Horror',
      'duration': '2 jam 05 mnt',
      'releaseDate': '21 Oktober 2026',
      'ageRating': '17+',
      'director': 'Mike Flanagan',
      'producer': 'Matt Reeves, James Gunn',
      'cast': 'Tom Hardy, Paul Dano, Colin Farrell',
      'synopsis':
          'Kisah asal-usul seorang aktor panggung yang mengalami kecelakaan tragis hingga wajahnya hancur. Demi menyelamatkan karirnya, ia menggunakan zat kimia eksperimental yang justru mengubah tubuhnya menjadi monster tanah liat berkekuatan merubah bentuk.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'SITI SI VAMPIR': {
      'genre': 'Comedy, Fantasy, Drama',
      'duration': '1 jam 40 mnt',
      'releaseDate': '22 Oktober 2026',
      'ageRating': '13+',
      'director': 'Hanung Bramantyo',
      'producer': 'Manoj Punjabi',
      'cast': 'Indah Permatasari, Reza Rahadian, Ringgo Agus Rahman',
      'synopsis':
          'Siti, seorang gadis desa sederhana yang tak sengaja tergigit makhluk purba saat bekerja di kota. Mengimbangi kehidupannya yang kini menjadi vampir komedi dengan naluri bertahan hidup sehari-hari demi menyembunyikan identitas barunya.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'SITI SITI': {
      'genre': 'Comedy, Fantasy, Drama',
      'duration': '1 jam 40 mnt',
      'releaseDate': '22 Oktober 2026',
      'ageRating': '13+',
      'director': 'Hanung Bramantyo',
      'producer': 'Manoj Punjabi',
      'cast': 'Indah Permatasari, Reza Rahadian, Ringgo Agus Rahman',
      'synopsis':
          'Siti, seorang gadis desa sederhana yang tak sengaja tergigit makhluk purba saat bekerja di kota. Mengimbangi kehidupannya yang kini menjadi vampir komedi dengan naluri bertahan hidup sehari-hari demi menyembunyikan identitas barunya.',
      'trailerUrl': 'https://www.youtube.com',
    },
    'PIRUNDUK': {
      'genre': 'Horror, Folklore',
      'duration': '1 jam 44 mnt',
      'releaseDate': '22 Oktober 2026',
      'ageRating': '17+',
      'director': 'Kimo Stamboel',
      'producer': 'Awi Suryadi, Manoj Punjabi',
      'cast': 'Mikha Tambayong, Rio Dewanto, Gisellma Firmansyah',
      'synopsis':
          'Misteri desa terpencil yang menganut ajaran ilmu perundukan mistis kuno. Ketika sebuah keluarga pendatang melanggar pantangan ritual Pirunduk, roh-roh leluhur penjaga hutan mulai menagih janji darah.',
      'trailerUrl': 'https://www.youtube.com',
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getMovieDetail(String rawTitle) {
    String formattedTitle = rawTitle.trim().toUpperCase();
    if (_upcomingDB.containsKey(formattedTitle)) return _upcomingDB[formattedTitle]!;
    for (String key in _upcomingDB.keys) {
      if (formattedTitle.contains(key) || key.contains(formattedTitle)) {
        return _upcomingDB[key]!;
      }
    }
    return {
      'genre': widget.movieData['genre'] ?? 'Drama, Thriller',
      'duration': '1 jam 45 mnt',
      'releaseDate': widget.movieData['releaseDate'] ?? 'Segera',
      'ageRating': widget.movieData['ageRating'] ?? '13+',
      'director': 'Sutradara Ternama',
      'producer': 'Produser Film Indonesia',
      'cast': 'Jajaran Aktor & Aktris Utama',
      'synopsis': 'Kisah emosional dan penuh kejutan tentang dinamika hubungan manusia dan petualangan tak terduga.',
      'trailerUrl': 'https://www.youtube.com',
    };
  }

  Future<void> _launchTrailer(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Membuka Trailer: $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.movieData['title'] ?? 'FILM AKAN TAYANG';
    final String poster = widget.movieData['poster'] ?? widget.movieData['image'] ?? 'assets/images/pulang_kampung.jpg';
    final Map<String, dynamic> detail = _getMovieDetail(title);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Warna Dominan Putih Terang
      appBar: AppBar(
        backgroundColor: const Color(0xFF001935), // Aksen Biru Navi
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Film',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Banner Atas & Card Utama Informasi Film
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        color: const Color(0xFF001935),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              // Banner Kuning Pengingat
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFDE047),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.stars_rounded, size: 16, color: Color(0xFF854D0E)),
                                    SizedBox(width: 6),
                                    Text(
                                      'PASTIKAN FILM INI SUDAH ADA DI WATCHLISTMU!',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF713F12),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Detail Utama Film
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        poster,
                                        width: 110,
                                        height: 155,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 110,
                                          height: 155,
                                          color: const Color(0xFF001935),
                                          child: const Icon(Icons.movie, color: Colors.white, size: 36),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF001935),
                                              height: 1.2,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          _buildMetaRow('Genre', detail['genre']),
                                          _buildMetaRow('Durasi', detail['duration']),
                                          _buildMetaRow('Sutradara', detail['director']),
                                          _buildMetaRow('Rating Usia', detail['ageRating'], isBadge: true),
                                          const SizedBox(height: 12),

                                          // Tombol Nonton Trailer Aksen Biru
                                          SizedBox(
                                            height: 34,
                                            child: OutlinedButton.icon(
                                              onPressed: () => _launchTrailer(detail['trailerUrl']),
                                              icon: const Icon(Icons.play_circle_fill_rounded, size: 18, color: Color(0xFF0284C7)),
                                              label: const Text(
                                                'Nonton Trailer',
                                                style: TextStyle(fontSize: 12, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                side: const BorderSide(color: Color(0xFF0284C7), width: 1.2),
                                                backgroundColor: const Color(0xFFF0F9FF),
                                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Sektor Watchlist Interaktif
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star_half_rounded, size: 18, color: Color(0xFFEAB308)),
                            SizedBox(width: 6),
                            Text(
                              'Belum ada ulasan',
                              style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(height: 20, width: 1, color: Colors.grey.shade300),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() => _isWatchlisted = !_isWatchlisted);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isWatchlisted ? 'Berhasil ditambahkan ke Watchlist!' : 'Dihapus dari Watchlist.'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFF001935),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                _isWatchlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Watchlist', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                                  Text(_isWatchlisted ? '821 Orang' : '820 Orang', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // TabBar Putih Aksen Biru
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF0284C7),
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorColor: const Color(0xFF0284C7),
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      tabs: const [
                        Tab(text: 'SINOPSIS'),
                        Tab(text: 'JADWAL'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Konten Tab View
                  SizedBox(
                    height: 460,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLightSinopsisTab(detail),
                        _buildLightJadwalTab(detail['releaseDate']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar "INGATKAN SAYA SAAT TAYANG"
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _isWatchlisted = !_isWatchlisted);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isWatchlisted ? 'Pengingat film berhasil diaktifkan!' : 'Pengingat dibatalkan.'),
                      backgroundColor: const Color(0xFF0284C7),
                    ),
                  );
                },
                icon: Icon(
                  _isWatchlisted ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                  color: const Color(0xFF001935),
                ),
                label: Text(
                  _isWatchlisted ? 'PENGINGAT AKTIF' : 'INGATKAN SAYA SAAT TAYANG',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF001935),
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDE047),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          if (isBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
            )
          else
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLightSinopsisTab(Map<String, dynamic> detail) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          // Card Sinopsis Film
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notes_rounded, size: 18, color: Color(0xFF0284C7)),
                    SizedBox(width: 8),
                    Text(
                      'Sinopsis Film',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Text(
                  detail['synopsis'],
                  style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.6, letterSpacing: 0.1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Card Kru Film (Produser, Sutradara, Pemain)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoTile(Icons.chair_alt_rounded, 'Produser', detail['producer']),
                const Divider(height: 20),
                _buildInfoTile(Icons.movie_filter_rounded, 'Sutradara', detail['director']),
                const Divider(height: 20),
                _buildInfoTile(Icons.people_alt_rounded, 'Pemain', detail['cast']),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF0284C7)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF001935))),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLightJadwalTab(String releaseDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: Row(
              children: [
                const Icon(Icons.event_available_rounded, color: Color(0xFF0284C7), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Segera tayang di bioskop kesayanganmu $releaseDate!',
                    style: const TextStyle(color: Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                )
              ],
            ),
            child: Icon(Icons.confirmation_number_outlined, size: 60, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 16),
          const Text(
            'Jadwal tayang belum tersedia',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aktifkan pengingat agar kamu mendapatkan notifikasi secara otomatis saat tiket sudah mulai dijual!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}