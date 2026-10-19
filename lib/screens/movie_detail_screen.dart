import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'select_seat_screen.dart'; // Import halaman pilih kursi

class MovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? movieData;

  const MovieDetailScreen({super.key, this.movieData});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDateIndex = 0;
  String? _selectedTime;

  // Tanggal Realtime sampai 31 Oktober
  late final List<Map<String, String>> _dates;

  // Database Detail Film Lengkap Bahasa Indonesia
  final Map<String, Map<String, dynamic>> _movieDetailsDB = {
    'KUASA GELAP: PERJANJIAN DAR...': {
      'synopsis': 'Setelah ritual pengusiran setan yang gagal berujung bencana, dua romo Katolik ditugaskan untuk menghadapi iblis kuno berkuasa tinggi yang bangkit akibat perjanjian ilmu hitam leluhur demi kekayaan berlimpah.',
      'producer': 'Robert Ronny, Aoura Lovenson Chandra',
      'director': 'Rizal Mantovani',
      'cast': 'Jerome Kurnia, Lukman Sardi, Freya JKT48, Astrid Tiar',
      'trailerUrl': 'https://youtu.be/YhYioKS3z_k?si=GXRxNgJmiKksxzEQ',
      'duration': '1 jam 36 menit',
    },
    'STREET FIGHTER': {
      'synopsis': 'Pertarungan sengit para petarung terkuat dari seluruh dunia yang berkumpul dalam turnamen rahasia untuk menghentikan organisasi jahat Shadaloo pimpinan M. Bison.',
      'producer': 'Neal H. Moritz, Legendary Pictures',
      'director': 'Danny Philippou, Michael Philippou',
      'cast': 'Jean-Claude Van Damme, Ming-Na Wen, Raul Julia',
      'trailerUrl': 'https://youtu.be/U6sbm1OaJb8?si=gjKvClfYhfyl3RRR',
      'duration': '1 jam 42 menit',
    },
    'IBU, BAGAIMANA AKU TANPAMU?': {
      'synopsis': 'Kisah perjuangan emosional seorang ibu tunggal dalam merawat anak-anaknya di tengah ujian hidup yang berat, hingga sang anak menyadari betapa hampa hidupnya tanpa kehadiran sang ibu.',
      'producer': 'Chand Parwez Servia',
      'director': 'Rudi Soedjarwo',
      'cast': 'Cut Mini, Nirina Zubir, Ali Fikry',
      'trailerUrl': 'https://youtu.be/Sh6ryxsOHYg?si=vjowAm2RR6zTGMqH',
      'duration': '1 jam 48 menit',
    },
    'OTHER MOMMY': {
      'synopsis': 'Sebuah keluarga pindah ke rumah baru hanya untuk menemukan rahasia kelam tentang entitas ghaib yang menyerupai ibu mereka dan mencoba mengambil alih kehidupan keluarga tersebut.',
      'producer': 'Jason Blum, James Wan',
      'director': 'David F. Sandberg',
      'cast': 'Patrick Wilson, Vera Farmiga, Mckenna Grace',
      'trailerUrl': 'https://youtu.be/-mnTITqqiT0?si=wIijJNl2CNkLqlIk',
      'duration': '1 jam 38 menit',
    },
    'WARGA RUSUN 609': {
      'synopsis': 'Penghuni rumah susun unit 609 mendapati kejadian-kejadian mistis dan konyol setelah salah satu warga memelihara benda pusaka yang membawa aura gaib di seluruh lantai rusun.',
      'producer': 'Manoj Punjabi',
      'director': 'Anggy Umbara',
      'cast': 'Indro Warkop, Raditya Dika, Tora Sudiro',
      'trailerUrl': 'https://youtu.be/O6skUxOL_Yw?si=mfPpFiYlPC1V0ho9',
      'duration': '1 jam 35 menit',
    },
  };

  // Daftar Bioskop Surabaya Beserta Harga
  final List<Map<String, dynamic>> _cinemas = const [
    {
      'name': 'Ciputra World XXI',
      'tag': 'XXI',
      'type': 'REGULAR 2D',
      'price': 'Rp30.000',
      'priceValue': 30000,
    },
    {
      'name': 'PAKUWON CITY XXI',
      'tag': 'XXI',
      'type': 'REGULAR 2D',
      'price': 'Rp35.000',
      'priceValue': 35000,
    },
    {
      'name': 'ROYAL XXI',
      'tag': 'XXI',
      'type': 'REGULAR 2D',
      'price': 'Rp30.000',
      'priceValue': 30000,
    },
    {
      'name': 'TRANS ICON MALL XXI',
      'tag': 'XXI',
      'type': 'REGULAR 2D',
      'price': 'Rp30.000',
      'priceValue': 30000,
    },
    {
      'name': 'BG JUNCTION CGV',
      'tag': 'CGV',
      'type': 'REGULAR 2D',
      'price': 'Rp30.000',
      'priceValue': 30000,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _dates = _generateRealtimeDatesUntil31Oct();
  }

  // Pembuat Tanggal Realtime Sampai 31 Oktober
  List<Map<String, String>> _generateRealtimeDatesUntil31Oct() {
    final List<String> namaHari = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
    final List<String> namaBulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    DateTime now = DateTime.now();
    List<Map<String, String>> dates = [];

    DateTime currentDate = now;
    int dayOffset = 0;

    while (currentDate.month == 10 && currentDate.day <= 31) {
      String dayText = '${currentDate.day} ${namaBulan[currentDate.month - 1]}';
      String subText = dayOffset == 0 ? 'HARI INI' : namaHari[currentDate.weekday - 1];

      dates.add({
        'day': dayText,
        'sub': subText,
      });

      dayOffset++;
      currentDate = now.add(Duration(days: dayOffset));
    }

    if (dates.isEmpty) {
      for (int day = now.day; day <= 31; day++) {
        DateTime target = DateTime(2026, 10, day);
        dates.add({
          'day': '$day Okt',
          'sub': day == now.day ? 'HARI INI' : namaHari[target.weekday - 1],
        });
      }
    }

    return dates;
  }

  // Pembuat Jam Tayang Acak Berdasarkan Tanggal & Bioskop
  List<String> _getRandomSchedules(String cinemaName, int dateIndex) {
    final List<String> masterTimes = [
      '11:45', '12:15', '12:30', '13:00', '13:45', '14:20', '14:50',
      '15:15', '15:30', '16:00', '16:40', '17:10', '17:45', '18:15',
      '19:00', '19:30', '20:15', '20:45', '21:15', '21:45'
    ];

    int seed = cinemaName.hashCode + dateIndex + (widget.movieData?['title']?.hashCode ?? 0);
    Random random = Random(seed);

    List<String> available = List.from(masterTimes);
    available.shuffle(random);

    int count = 4 + random.nextInt(2);
    List<String> result = available.sublist(0, count);
    result.sort();
    return result;
  }

  // Fungsi Buka Trailer YouTube
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

  // Fungsi Pindah ke Halaman Pilih Tempat Duduk
  void _navigateToSeatSelection(String movieTitle) {
    if (_selectedTime == null) return;

    List<String> parts = _selectedTime!.split('_');
    String cinemaName = parts[0];
    String timeText = parts[1];

    var selectedCinema = _cinemas.firstWhere(
      (c) => c['name'] == cinemaName,
      orElse: () => _cinemas[0],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectSeatScreen(
          movieTitle: movieTitle,
          cinemaName: cinemaName,
          dateText: _dates[_selectedDateIndex]['day']!,
          timeText: timeText,
          ticketPrice: selectedCinema['priceValue'] ?? 30000,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.movieData?['title'] ?? 'KUASA GELAP: PERJANJIAN DAR...';
    final poster = widget.movieData?['poster'] ?? 'assets/images/kuasa_gelap.jpg';
    final genre = widget.movieData?['genre'] ?? 'Horror';
    final ageRating = widget.movieData?['ageRating'] ?? 'R 13+';
    final rating = widget.movieData?['rating'] ?? '9.3';

    final detail = _movieDetailsDB[title] ?? {
      'synopsis': widget.movieData?['desc'] ?? 'Sinopsis tidak tersedia.',
      'producer': 'Produser Film',
      'director': 'Sutradara Film',
      'cast': 'Pemeran Utama Film',
      'trailerUrl': 'https://www.youtube.com',
      'duration': '1 jam 50 menit',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF001935),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
              child: Column(
                children: [
                  // Header Card Informasi Film
                  Stack(
                    children: [
                      Container(
                        height: 90,
                        color: const Color(0xFF001935),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFDE047),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.workspace_premium, size: 16, color: Color(0xFF854D0E)),
                                    SizedBox(width: 6),
                                    Text(
                                      'TOP 5 FILM TERBAIK DARI MINGGU LALU!',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF854D0E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        poster,
                                        width: 105,
                                        height: 145,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 105,
                                          height: 145,
                                          color: const Color(0xFF001935),
                                          child: const Icon(Icons.movie, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF001935),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildMetaRow('Genre', genre),
                                          _buildMetaRow('Durasi', detail['duration']),
                                          _buildMetaRow('Sutradara', detail['director']),
                                          _buildMetaRow('Rating Usia', ageRating, isBadge: true),
                                          const SizedBox(height: 8),

                                          OutlinedButton.icon(
                                            onPressed: () => _launchTrailer(detail['trailerUrl']),
                                            icon: const Icon(Icons.play_arrow, size: 16, color: Color(0xFF0284C7)),
                                            label: const Text(
                                              'Nonton Trailer',
                                              style: TextStyle(fontSize: 12, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              side: const BorderSide(color: Color(0xFF0284C7)),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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

                  const SizedBox(height: 16),

                  // Rating dan Watchlist
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              rating,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFEAB308)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: Color(0xFFEAB308), size: 18),
                            const Icon(Icons.star, color: Color(0xFFEAB308), size: 18),
                            const Icon(Icons.star, color: Color(0xFFEAB308), size: 18),
                            const Icon(Icons.star, color: Color(0xFFEAB308), size: 18),
                            const Icon(Icons.star_half, color: Color(0xFFEAB308), size: 18),
                          ],
                        ),
                        const Spacer(),
                        Container(height: 30, width: 1, color: Colors.grey.shade300),
                        const Spacer(),
                        const Row(
                          children: [
                            Icon(Icons.favorite_border, color: Colors.red, size: 20),
                            SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Masukkan watchlist', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('14.449 Orang', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(thickness: 1, color: Color(0xFFF1F5F9)),

                  // Tab TabBar (SINOPSIS / JADWAL)
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF001935),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF001935),
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: const [
                      Tab(text: 'SINOPSIS'),
                      Tab(text: 'JADWAL'),
                    ],
                  ),

                  // Konten Tab
                  SizedBox(
                    height: 480,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSinopsisTab(detail),
                        _buildJadwalTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar BELI TIKET
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF001935),
            child: ElevatedButton.icon(
              onPressed: _selectedTime != null ? () => _navigateToSeatSelection(title) : null,
              icon: const Icon(Icons.confirmation_number, color: Color(0xFFFBBF24)),
              label: const Text(
                'BELI TIKET',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBBF24),
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001935),
                disabledBackgroundColor: const Color(0xFF001935).withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          if (isBadge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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

  Widget _buildSinopsisTab(Map<String, dynamic> detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail['synopsis'],
            style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text('Produser', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
          const SizedBox(height: 2),
          Text(detail['producer'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          const Text('Sutradara', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
          const SizedBox(height: 2),
          Text(detail['director'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          const Text('Pemeran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935))),
          const SizedBox(height: 2),
          Text(detail['cast'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildJadwalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedDateIndex;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedDateIndex = index;
                    _selectedTime = null;
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF001935) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? const Color(0xFF001935) : Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dates[index]['day']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          _dates[index]['sub']!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, size: 18, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Cari bioskop', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF001935)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tune, size: 16, color: Color(0xFF001935)),
                      SizedBox(width: 4),
                      Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001935))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          ..._cinemas.map((cinema) {
            final cinemaName = cinema['name'] ?? cinema['title'] ?? '';
            final List<String> schedules = _getRandomSchedules(cinemaName, _selectedDateIndex);

            return Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_border, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        cinemaName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(cinema['tag'] ?? '', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cinema['type'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                      Text(cinema['price'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: schedules.map((time) {
                      final isSelected = _selectedTime == '${cinemaName}_$time';
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = '${cinemaName}_$time'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF001935) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}