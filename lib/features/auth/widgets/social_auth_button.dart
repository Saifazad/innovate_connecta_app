import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const SocialAuthButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  /// Factory constructor for Google social login button
  factory SocialAuthButton.google({Key? key, VoidCallback? onTap}) {
    return SocialAuthButton(
      key: key,
      onTap: onTap,
      icon: const _GoogleIcon(size: 22),
    );
  }

  /// Factory constructor for Apple social login button
  factory SocialAuthButton.apple({Key? key, VoidCallback? onTap}) {
    return SocialAuthButton(
      key: key,
      onTap: onTap,
      icon: const Icon(
        Icons.apple,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: Colors.white12,
        highlightColor: Colors.white10,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF131B2E),
            border: Border.all(
              color: const Color(0xFF1E293B),
              width: 1.2,
            ),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

/// Crisp, pixel-perfect Google 'G' icon painter
class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Rect rect = Rect.fromLTWH(0, 0, w, h);

    // Blue sweep
    final Paint bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22;
    canvas.drawArc(rect.deflate(w * 0.11), -0.7, 1.4, false, bluePaint);

    // Green sweep
    final Paint greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22;
    canvas.drawArc(rect.deflate(w * 0.11), 0.7, 1.4, false, greenPaint);

    // Yellow sweep
    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22;
    canvas.drawArc(rect.deflate(w * 0.11), 2.1, 1.4, false, yellowPaint);

    // Red sweep
    final Paint redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22;
    canvas.drawArc(rect.deflate(w * 0.11), 3.5, 1.4, false, redPaint);

    // Blue horizontal bar
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final Rect barRect = Rect.fromLTWH(
      w * 0.45,
      h * 0.39,
      w * 0.52,
      h * 0.22,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(barRect, Radius.circular(w * 0.04)),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
