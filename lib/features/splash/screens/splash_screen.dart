import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/image_constants.dart';
import '../controllers/splash_controller.dart';
import 'animated_gradient_bg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: AnimatedGradientBackground(
        child: Stack(
          children: [
            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo with soft glow
                  Container(
                    padding: const EdgeInsets.all(24),
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
                    child: Image.asset(
                      ImageConstants.logo,
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.fitness_center,
                        size: 100,
                        color: Color(0xFF1F2937), // Dark grey
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'VOLTAGE ACADEMY',
                    style: TextStyle(
                      color: Color(0xFF1F2937), // Dark grey
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'YOUR COMPLETE FITNESS JOURNEY',
                    style: TextStyle(
                      color: const Color(0xFF1F2937).withOpacity(0.6), // Dark grey
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const _PulsingDots(),
                ],
              ),
            ),
          ],
        ),
      ),
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
