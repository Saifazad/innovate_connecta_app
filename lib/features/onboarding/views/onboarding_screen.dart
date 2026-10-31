import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/views/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const Color brandNavy = Color(0xFF0C2B6E);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color textDark = Color(0xFF0C2B6E);
  static const Color textSub = Color(0xFF64748B);
  static const Color pillarBg = Color(0xFFEDF4FE);
  static const Color dividerColor = Color(0xFFE2E8F0);

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnim = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _onSignIn() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
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
        body: CustomPaint(
          painter: const OnboardingBackgroundPainter(),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Column(
                            children: [
                              const Spacer(flex: 3),

                              // --- 1. App Logo Squircle Card ---
                              ScaleTransition(
                                scale: _scaleAnim,
                                child: Container(
                                  width: 144,
                                  height: 144,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF1E3A8A)
                                            .withValues(alpha: 0.10),
                                        blurRadius: 32,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(22),
                                  child: Image.asset(
                                    'assets/icon/app_icon_raw.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // --- 2. Title Block ---
                              // Line 1: Welcome to
                              Text(
                                'Welcome to',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: textDark,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 3),

                              // Line 2: InnoVate Connecta
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'InnoVate ',
                                      style: GoogleFonts.inter(
                                        fontSize: 29,
                                        fontWeight: FontWeight.w800,
                                        color: textDark,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Connecta',
                                      style: GoogleFonts.inter(
                                        fontSize: 29,
                                        fontWeight: FontWeight.w800,
                                        color: brandOrange,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // --- 3. Subtitle ---
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 34),
                                child: Text(
                                  'Empowering enterprises and\nentrepreneurs to connect,\ncollaborate, and scale.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w400,
                                    color: textSub,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // --- 4. Three Feature Pillars: Connect | Collaborate | Scale ---
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Pillar 1: Connect
                                    _buildPillarItem(
                                      iconWidget: _buildConnectIcon(),
                                      label: 'Connect',
                                    ),

                                    // Divider 1
                                    _buildVerticalDivider(),

                                    // Pillar 2: Collaborate
                                    _buildPillarItem(
                                      iconWidget: _buildCollaborateIcon(),
                                      label: 'Collaborate',
                                    ),

                                    // Divider 2
                                    _buildVerticalDivider(),

                                    // Pillar 3: Scale
                                    _buildPillarItem(
                                      iconWidget: _buildScaleIcon(),
                                      label: 'Scale',
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(flex: 4),

                              // --- 5. Action Buttons ---
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Primary Pill Button: "Get Started  →"
                                    Container(
                                      width: double.infinity,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: brandNavy
                                                .withValues(alpha: 0.32),
                                            blurRadius: 18,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _onGetStarted,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: brandNavy,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Get Started',
                                              style: GoogleFonts.inter(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Secondary Text Button: "Sign In with Account"
                                    SizedBox(
                                      width: double.infinity,
                                      height: 44,
                                      child: TextButton(
                                        onPressed: _onSignIn,
                                        style: TextButton.styleFrom(
                                          foregroundColor: brandNavy,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Sign In with Account',
                                          style: GoogleFonts.inter(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.1,
                                            color: brandNavy,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Vertical Divider between feature pillars
  Widget _buildVerticalDivider() {
    return Container(
      height: 38,
      width: 1.2,
      color: dividerColor,
    );
  }

  /// Single Feature Pillar Item (Connect, Collaborate, Scale)
  Widget _buildPillarItem({
    required Widget iconWidget,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: pillarBg,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(child: iconWidget),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textDark,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  /// Connect: People Team Icon
  Widget _buildConnectIcon() {
    return const Icon(
      Icons.groups_rounded,
      color: brandNavy,
      size: 27,
    );
  }

  /// Collaborate: Chat bubble with 3 Orange dots
  Widget _buildCollaborateIcon() {
    return SizedBox(
      width: 26,
      height: 26,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: brandNavy,
            size: 25,
          ),
          Positioned(
            top: 7.5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 3.2,
                  height: 3.2,
                  decoration: const BoxDecoration(
                    color: brandOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 2.2),
                Container(
                  width: 3.2,
                  height: 3.2,
                  decoration: const BoxDecoration(
                    color: brandOrange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 2.2),
                Container(
                  width: 3.2,
                  height: 3.2,
                  decoration: const BoxDecoration(
                    color: brandOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Scale: 3 Navy Histogram Bars + Orange Upward Trend Arrow
  Widget _buildScaleIcon() {
    return SizedBox(
      width: 26,
      height: 26,
      child: Stack(
        children: [
          Positioned(
            left: 3,
            bottom: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 3.8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: brandNavy,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 2.8),
                Container(
                  width: 3.8,
                  height: 13,
                  decoration: BoxDecoration(
                    color: brandNavy,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 2.8),
                Container(
                  width: 3.8,
                  height: 18,
                  decoration: BoxDecoration(
                    color: brandNavy,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 1,
            top: 1,
            child: Icon(
              Icons.north_east_rounded,
              color: brandOrange,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws the curved wave backgrounds, orange accents, and dot grids
class OnboardingBackgroundPainter extends CustomPainter {
  const OnboardingBackgroundPainter();

  static const Color navyWave = Color(0xFF0C2B6E);
  static const Color orangeLine = Color(0xFFF97316);
  static const Color dotColor = Color(0xFFB8CDEC);
  static const Color softBlueBlob = Color(0xFFEFF5FD);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Top-Right Soft Blue Shape
    final blobPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.62, 0)
      ..cubicTo(
        size.width * 0.60,
        size.height * 0.08,
        size.width * 0.72,
        size.height * 0.19,
        size.width,
        size.height * 0.16,
      )
      ..close();
    canvas.drawPath(blobPath, Paint()..color = softBlueBlob);

    // 2. Top-Left Navy Wave
    final navyTopPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height * 0.155)
      ..cubicTo(
        size.width * 0.06,
        size.height * 0.175,
        size.width * 0.22,
        size.height * 0.135,
        size.width * 0.38,
        0,
      )
      ..close();
    canvas.drawPath(navyTopPath, Paint()..color = navyWave);

    // 3. Top-Left Orange Accent Curve
    final orangeTopPath = Path()
      ..moveTo(0, size.height * 0.095)
      ..cubicTo(
        size.width * 0.12,
        size.height * 0.165,
        size.width * 0.28,
        size.height * 0.105,
        size.width * 0.46,
        0,
      );
    canvas.drawPath(
      orangeTopPath,
      Paint()
        ..color = orangeLine
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // 4. Bottom-Right Navy Wave
    final navyBottomPath = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.58, size.height)
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.915,
        size.width * 0.82,
        size.height * 0.875,
        size.width,
        size.height * 0.825,
      )
      ..close();
    canvas.drawPath(navyBottomPath, Paint()..color = navyWave);

    // 5. Bottom-Right Orange Accent Curve
    final orangeBottomPath = Path()
      ..moveTo(size.width * 0.52, size.height)
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.895,
        size.width * 0.78,
        size.height * 0.845,
        size.width,
        size.height * 0.805,
      );
    canvas.drawPath(
      orangeBottomPath,
      Paint()
        ..color = orangeLine
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // 6. Dot Grid Top-Right (3 cols x 4 rows)
    _drawDotGrid(
      canvas,
      startX: size.width - 55,
      startY: size.height * 0.082,
      cols: 3,
      rows: 4,
      spacing: 14,
      radius: 2.2,
      color: dotColor,
    );

    // 7. Dot Grid Bottom-Left (3 cols x 4 rows)
    _drawDotGrid(
      canvas,
      startX: 24,
      startY: size.height * 0.88,
      cols: 3,
      rows: 4,
      spacing: 14,
      radius: 2.2,
      color: dotColor,
    );
  }

  void _drawDotGrid(
    Canvas canvas, {
    required double startX,
    required double startY,
    required int cols,
    required int rows,
    required double spacing,
    required double radius,
    required Color color,
  }) {
    final paint = Paint()..color = color;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(startX + (c * spacing), startY + (r * spacing)),
          radius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
