import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../onboarding/views/onboarding_screen.dart';
import '../../../app/main_navigation_screen.dart';
import '../../profile/view_models/profile_view_model.dart';
import '../../../core/services/auth_session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color brandNavy = Color(0xFF182467);
  static const Color brandOrange = Color(0xFFF97316);

  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final AnimationController _loaderController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  late final Animation<double> _flashOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.55, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.94)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 15,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.55),
      ),
    );

    _logoOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.22),
      ),
    );

    _ringScale = Tween<double>(
      begin: 0.35,
      end: 1.65,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.32,
          0.75,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _ringOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.8),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 0.0),
        weight: 70,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.32, 0.75),
      ),
    );

    _flashOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 65,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.40, 0.65),
      ),
    );

    _titleOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.55, 0.85),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.65),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(
          0.55,
          0.85,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _footerOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.75, 1.0),
      ),
    );

    _introController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          _pulseController.repeat(reverse: true);
        }

        // Smoothly navigate after splash plays: auto-login to Dashboard if valid session exists
        Future.delayed(const Duration(milliseconds: 600), () async {
          if (!mounted) return;

          final hasValid = AuthSessionService.instance.hasValidSession();
          if (hasValid) {
            // Check if token needs refresh
            if (AuthSessionService.instance.isTokenExpired) {
              final refreshed = await AuthSessionService.instance.refreshToken();
              if (!refreshed) {
                if (!mounted) return;
                _navigateToScreen(const OnboardingScreen());
                return;
              }
            }

            await ProfileViewModel.instance.restoreActiveSession();
            if (!mounted) return;
            _navigateToScreen(const MainNavigationScreen());
          } else {
            _navigateToScreen(const OnboardingScreen());
          }
        });
      }
    });

    _introController.forward();
  }

  void _navigateToScreen(Widget screen) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _introController,
        _pulseController,
      ]),
      builder: (context, child) {
        final double breathingScale =
            1.0 + (_pulseController.value * 0.045);

        return SizedBox(
          width: 260,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Expanding energy ring
              Opacity(
                opacity: _ringOpacity.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _ringScale.value,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: brandNavy,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: brandNavy.withValues(alpha: 0.25),
                          blurRadius: 22,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Orange energy flash
              Opacity(
                opacity: _flashOpacity.value.clamp(0.0, 1.0),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: brandOrange.withValues(alpha: 0.55),
                        blurRadius: 55,
                        spreadRadius: 22,
                      ),
                    ],
                  ),
                ),
              ),

              // Original brand logo
              Opacity(
                opacity: _logoOpacity.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: _logoScale.value * breathingScale,
                  child: Image.asset(
                    'assets/icon/app_icon_raw.png',
                    width: 185,
                    height: 185,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrandText() {
    return FadeTransition(
      opacity: _titleOpacity,
      child: SlideTransition(
        position: _titleSlide,
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'InnoVate ',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: brandNavy,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'Connecta',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: brandOrange,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'WHERE AMBITION MEETS INNOVATION',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _footerOpacity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _loaderController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loaderController.value * 2 * math.pi,
                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      brandOrange,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF374151),
              ),
              children: [
                TextSpan(
                  text: 'MSME',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    color: brandOrange,
                  ),
                ),
                const TextSpan(
                  text: ' Registered Organisation',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnimatedLogo(),
                    const SizedBox(height: 8),
                    _buildBrandText(),
                  ],
                ),
              ),
              const Spacer(flex: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    _loaderController.dispose();
    super.dispose();
  }
}