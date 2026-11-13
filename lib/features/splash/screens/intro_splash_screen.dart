import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/route_helper.dart';
import '../../../core/services/storage/shared_prefs.dart';
import 'animated_gradient_bg.dart';

// ─── Slide Data ───────────────────────────────────────────────────────────────
class _Slide {
  const _Slide({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;
}

const _slides = [
  _Slide(
    icon: Icons.sports_gymnastics,
    title: 'KIDS GYMNASTICS',
    body: 'Building confidence and strength from day one.',
  ),
  _Slide(
    icon: Icons.fitness_center,
    title: 'CALISTHENICS',
    body: 'Master bodyweight control and gravity-defying skills.',
  ),
  _Slide(
    icon: Icons.health_and_safety,
    title: 'RECOVERY',
    body: 'Relieve muscle tension and improve your mobility.',
  ),
  _Slide(
    icon: Icons.self_improvement,
    title: 'YOGA & WELLNESS',
    body: 'Improve flexibility and find your inner peace.',
  ),
];

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  final PageController _pageCtrl = PageController();
  int _page = 0;
  bool _permGranted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _requestPermissions();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_page < _slides.length - 1) {
        _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _timer?.cancel();
        _onGetStarted();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final loc = await Permission.locationWhenInUse.request();
    final notif = await Permission.notification.request();
    _permGranted = loc.isGranted && notif.isGranted;
    if (!_permGranted && mounted) {
      final blocked = loc.isPermanentlyDenied || notif.isPermanentlyDenied;
      if (blocked) await openAppSettings();
    }
  }

  Future<void> _onGetStarted() async {
    _timer?.cancel();
    if (!_permGranted) await _requestPermissions();
    if (mounted) {
      await SharedPrefs.setBool('splash_seen', true);
      Get.offAllNamed(RouteHelper.getWebviewRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  itemCount: _slides.length,
                  onPageChanged: (i) {
                    setState(() => _page = i);
                    _startAutoAdvance(); // Reset timer on manual swipe
                  },
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 3),
                          
                          // Elegant, simple icon container like Splash
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFB300).withOpacity(0.15), // Yellow glow
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              _slides[index].icon,
                              size: 100,
                              color: const Color(0xFF1F2937), // Dark grey
                            ),
                          ),
                          
                          const Spacer(flex: 2),
                          
                          Text(
                            _slides[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _slides[index].body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF1F2937).withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              height: 1.5,
                            ),
                          ),
                          
                          const Spacer(flex: 3),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Bottom Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: _buildNavigationRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _onGetStarted,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          child: const Text('SKIP'),
        ),
        Row(
          children: List.generate(
            _slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _page == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _page == index ? const Color(0xFFFFB300) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
                boxShadow: _page == index 
                  ? [BoxShadow(color: const Color(0xFFFFB300).withOpacity(0.5), blurRadius: 4)]
                  : null,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_page < _slides.length - 1) {
              _pageCtrl.nextPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
              );
            } else {
              _onGetStarted();
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          child: Text(_page == _slides.length - 1 ? 'START' : 'NEXT'),
        ),
      ],
    );
  }
}

// ─── Pulsing loading dots ──────────────────────────────────────────────────────
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _anim,
          builder: (_, __) {
            final delay = i * 0.33;
            final t = (((_ctrl.value - delay) % 1.0 + 1.0) % 1.0);
            final scale = 0.5 + 0.5 * (0.5 - (t - 0.5).abs() * 2).clamp(0.0, 0.5) * 2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.scale(
                scale: 0.7 + 0.3 * scale,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFB300).withOpacity(0.4 + 0.6 * scale),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
