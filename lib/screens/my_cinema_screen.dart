import 'dart:math';
import 'package:flutter/material.dart';
import 'select_seat_screen.dart';
import 'home_screen.dart'; // Impor disesuaikan ke home_screen.dart
import 'my_tickets_screen.dart';

class MyCinemaScreen extends StatefulWidget {
  final String? initialCinemaName;

  const MyCinemaScreen({super.key, this.initialCinemaName});

  @override
  State<MyCinemaScreen> createState() => _MyCinemaScreenState();
}

class _MyCinemaScreenState extends State<MyCinemaScreen> {
  String _searchQuery = '';
  String? _selectedCinemaName;
  int _selectedDateIndex = 0;
  int _navIndex = 1;

  final List<Map<String, String>> _datesList = [
    {'date': '16 Okt', 'day': 'HARI INI'},
    {'date': '17 Okt', 'day': 'SAB'},
    {'date': '18 Okt', 'day': 'MIN'},
    {'date': '19 Okt', 'day': 'SEN'},
    {'date': '20 Okt', 'day': 'SEL'},
    {'date': '21 Okt', 'day': 'RAB'},
    {'date': '22 Okt', 'day': 'KAM'},
    {'date': '23 Okt', 'day': 'JUM'},
    {'date': '24 Okt', 'day': 'SAB'},
    {'date': '25 Okt', 'day': 'MIN'},
    {'date': '26 Okt', 'day': 'SEN'},
    {'date': '27 Okt', 'day': 'SEL'},
    {'date': '28 Okt', 'day': 'RAB'},
    {'date': '29 Okt', 'day': 'KAM'},
    {'date': '30 Okt', 'day': 'JUM'},
    {'date': '31 Okt', 'day': 'SAB'},
  ];

  final List<Map<String, String>> _cinemasList = const [
    {
      'name': 'CIPUTRA WORLD XXI',
      'address': 'Ciputra World Lt. 4, Jl. Mayjen Sungkono No. 89, Gunungsari, Surabaya 60224',
      'phone': '(031) 51200021',
      'tag': 'XXI',
      'mapUrl': 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=112.7183,-7.2887&z=15&l=map&size=600,250&pt=112.7183,-7.2887,pm2rdm',
    },
    {
      'name': 'PAKUWON CITY XXI',
      'address': 'East Coast Center Lt. 3, Jl. Kejawan Putih Mulyo, Mulyorejo, Surabaya 60112',
      'phone': '(031) 5914121',
      'tag': 'XXI',
      'mapUrl': 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=112.8021,-7.2758&z=15&l=map&size=600,250&pt=112.8021,-7.2758,pm2rdm',
    },
    {
      'name': 'ROYAL XXI',
      'address': 'Royal Plaza Lt. 3, Jl. Ahmad Yani No. 16-18, Wonokromo, Surabaya 60243',
      'phone': '(031) 8271121',
      'tag': 'XXI',
      'mapUrl': 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=112.7350,-7.3090&z=15&l=map&size=600,250&pt=112.7350,-7.3090,pm2rdm',
    },
    {
      'name': 'TRANS ICON MALL XXI',
      'address': 'Trans Icon Mall Lt. 3, Jl. Ahmad Yani No. 260, Gayungan, Surabaya 60235',
      'phone': '(031) 99851121',
      'tag': 'XXI',
      'mapUrl': 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=112.7301,-7.3392&z=15&l=map&size=600,250&pt=112.7301,-7.3392,pm2rdm',
    },
    {
      'name': 'BG JUNCTION CGV',
      'address': 'BG Junction Lt. LL, Jl. Bubutan No. 1-7, Bubutan, Surabaya 60174',
      'phone': '08176881341',
      'tag': 'CGV',
      'mapUrl': 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=112.7342,-7.2536&z=15&l=map&size=600,250&pt=112.7342,-7.2536,pm2rdm',
    },
  ];

  final List<Map<String, dynamic>> _playingMovies = const [
    {
      'title': 'KUASA GELAP: PERJANJIAN DAR...',
      'genre': 'Horror',
      'duration': '1j 36m',
      'director': 'Rizal Mantovani',
      'ageRating': 'R 13+',
      'poster': 'assets/images/kuasa_gelap.jpg',
      'price': 'Rp30.000 - Rp35.000',
      'priceValue': 30000,
    },
    {
      'title': 'STREET FIGHTER',
      'genre': 'Action / Sci-Fi',
      'duration': '1j 42m',
      'director': 'Danny & Michael Philippou',
      'ageRating': 'R 13+',
      'poster': 'assets/images/street_fighter.jpg',
      'price': 'Rp30.000 - Rp35.000',
      'priceValue': 30000,
    },
    {
      'title': 'IBU, BAGAIMANA AKU TANPAMU?',
      'genre': 'Drama / Family',
      'duration': '1j 48m',
      'director': 'Rudi Soedjarwo',
      'ageRating': 'SU',
      'poster': 'assets/images/ibu.jpg',
      'price': 'Rp30.000 - Rp35.000',
      'priceValue': 30000,
    },
    {
      'title': 'OTHER MOMMY',
      'genre': 'Horror / Thriller',
      'duration': '1j 38m',
      'director': 'David F. Sandberg',
      'ageRating': 'D 17+',
      'poster': 'assets/images/other_mommy.jpg',
      'price': 'Rp30.000 - Rp35.000',
      'priceValue': 30000,
    },
    {
      'title': 'WARGA RUSUN 609',
      'genre': 'Comedy / Horror',
      'duration': '1j 35m',
      'director': 'Anggy Umbara',
      'ageRating': 'R 13+',
      'poster': 'assets/images/warga_rusun.jpg',
      'price': 'Rp30.000 - Rp35.000',
      'priceValue': 30000,
    },
  ];

  List<String> _getDynamicSchedules(int dateIndex, String movieTitle) {
    final List<List<String>> timePools = [
      ['11:45', '13:50', '16:00', '18:10', '20:20'],
      ['12:15', '14:30', '16:45', '19:00', '21:15'],
      ['12:55', '15:05', '17:15', '19:25', '20:30'],
      ['13:00', '15:20', '17:40', '20:00', '21:40'],
      ['12:30', '14:45', '17:00', '19:15', '21:30'],
      ['13:15', '15:30', '18:15', '20:45'],
    ];

    int seed = dateIndex + movieTitle.length + (_selectedCinemaName?.length ?? 0);
    int selectedPool = seed % timePools.length;
    return timePools[selectedPool];
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialCinemaName != null) {
      _selectedCinemaName = widget.initialCinemaName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: _selectedCinemaName != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF001935), size: 20),
                onPressed: () => setState(() => _selectedCinemaName = null),
              )
            : null,
        title: _selectedCinemaName != null
            ? Text(
                _selectedCinemaName!,
                style: const TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 16),
              )
            : Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Cari bioskop pilihanmu...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF001935), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
      ),
      body: _selectedCinemaName == null ? _buildCinemaListView() : _buildCinemaDetailView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyTixHomeScreen()),
              (route) => false,
            );
          } else if (index == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyTicketsScreen()),
              (route) => false,
            );
          } else {
            setState(() {
              _navIndex = index;
              _selectedCinemaName = null;
            });
          }
        },
        selectedItemColor: const Color(0xFF001935),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'Bioskop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Tiket',
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaListView() {
    final filteredList = _cinemasList.where((cinema) {
      return cinema['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.location_on, color: Color(0xFF001935), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'SURABAYA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001935), letterSpacing: 0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filteredList.isEmpty
              ? const Center(
                  child: Text('Bioskop tidak ditemukan', style: TextStyle(color: Colors.grey, fontSize: 14)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final cinema = filteredList[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cinema['tag'] == 'CGV' ? Colors.red.shade50 : Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cinema['tag']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: cinema['tag'] == 'CGV' ? Colors.red : Colors.amber.shade900,
                            ),
                          ),
                        ),
                        title: Text(
                          cinema['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001935)),
                        ),
                        subtitle: Text(
                          cinema['address']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Color(0xFF001935)),
                        onTap: () {
                          setState(() {
                            _selectedCinemaName = cinema['name'];
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCinemaDetailView() {
    final cinema = _cinemasList.firstWhere(
      (c) => c['name'] == _selectedCinemaName,
      orElse: () => _cinemasList[0],
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 170,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Color(0xFFE2E8F0)),
                      child: Image.network(
                        cinema['mapUrl']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF001935),
                          child: const Center(
                            child: Icon(Icons.map, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF001935),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.near_me, color: Color(0xFFFBBF24), size: 14),
                            SizedBox(width: 4),
                            Text('Peta Lokasi Asli', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              cinema['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF001935)),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.star_border, size: 16, color: Color(0xFF001935)),
                            label: const Text('FAVORIT', style: TextStyle(color: Color(0xFF001935), fontWeight: FontWeight.bold, fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: const BorderSide(color: Color(0xFF001935)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(child: Text(cinema['address']!, style: const TextStyle(fontSize: 12, color: Colors.black87))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(cinema['phone']!, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 54,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _datesList.length,
                      itemBuilder: (context, index) {
                        bool isSelected = _selectedDateIndex == index;
                        final dateObj = _datesList[index];

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDateIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF001935) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF001935) : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dateObj['date']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: isSelected ? Colors.white : const Color(0xFF001935),
                                  ),
                                ),
                                Text(
                                  dateObj['day']!,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? const Color(0xFFFBBF24) : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: _playingMovies.map((movie) {
                      final schedules = _getDynamicSchedules(_selectedDateIndex, movie['title']);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    movie['poster'],
                                    width: 75,
                                    height: 110,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 75,
                                      height: 110,
                                      color: const Color(0xFF001935),
                                      child: const Icon(Icons.movie, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie['title'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF001935)),
                                      ),
                                      const SizedBox(height: 6),
                                      Text('Genre: ${movie['genre']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      Text('Durasi: ${movie['duration']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          movie['ageRating'],
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
                                        ),
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
                                const Text('REGULAR 2D', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF001935))),
                                Text(movie['price'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: schedules.map((time) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectSeatScreen(
                                          movieTitle: movie['title'],
                                          cinemaName: _selectedCinemaName!,
                                          dateText: _datesList[_selectedDateIndex]['date']!,
                                          timeText: time,
                                          ticketPrice: movie['priceValue'],
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Text(
                                      time,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF001935)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}