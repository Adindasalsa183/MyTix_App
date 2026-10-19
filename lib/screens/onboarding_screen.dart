import 'package:flutter/material.dart';

class MyTixOnboardingScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onExplore;

  const MyTixOnboardingScreen({super.key, required this.onNext, required this.onExplore});

  @override
  State<MyTixOnboardingScreen> createState() => _MyTixOnboardingScreenState();
}

class _MyTixOnboardingScreenState extends State<MyTixOnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Lebih banyak pilihan pembayaran!',
      'desc': 'Membeli tiket film semakin mudah! Ayo amankan kursimu dengan mencoba metode pembayaran baru dari kami!',
      'icon': '💳',
    },
    {
      'title': 'Audio, visual, dan hidangan yang sedap',
      'desc': 'Dengan MyTix Food, nikmati makanan sedap dari bioskop untuk pengalaman nonton maksimal.',
      'icon': '🍿',
    },
    {
      'title': 'Lebih seru dengan MyTix EVENTS!',
      'desc': 'Siap-siap, banyak hiburan menarik yang akan datang dengan event-event baru yang seru!',
      'icon': '🎟️',
    },
    {
      'title': 'MyTix VIP, lebih seru, koin melimpah, dapat hadiah!',
      'desc': 'Gabung MyTix VIP dan kumpulkan koin untuk mendapatkan hadiah dan diskon.',
      'icon': '👑',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('MyTix', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: widget.onExplore,
                    child: const Text('Lewati', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s['icon']!, style: const TextStyle(fontSize: 80)),
                        const SizedBox(height: 30),
                        Text(s['title']!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(s['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: _page == i ? const Color(0xFFFFB800) : Colors.white30),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: isLast
                  ? Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onNext,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF001935)),
                            child: const Text('Daftar', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: widget.onExplore,
                          child: const Text('Jelajahi MyTix', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: _page > 0 ? () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease) : null,
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38)),
                          child: const Text('KEMBALI', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF001935)),
                          child: const Text('LANJUT', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}