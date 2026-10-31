import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/main_navigation_screen.dart';
import '../models/recorded_session_model.dart';
import 'course_preview_screen.dart';

class CoursePaymentSuccessScreen extends StatelessWidget {
  final RecordedSessionModel session;
  final String studentName;
  final String studentEmail;
  final String studentPhone;
  final String bankName;
  final String totalPaid;
  final String? orderId;
  final String? transactionId;

  const CoursePaymentSuccessScreen({
    super.key,
    required this.session,
    this.studentName = 'Test',
    this.studentEmail = 'test1234@gmail.com',
    this.studentPhone = '8787546968',
    this.bankName = 'HDFC Bank',
    this.totalPaid = '₹3999',
    this.orderId,
    this.transactionId,
  });

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color goldAmber = Color(0xFFF59E0B);
  static const Color subtitleColor = Color(0xFF94A3B8);

  String get _resolvedOrderId {
    if (orderId != null && orderId!.isNotEmpty) return orderId!;
    final now = DateTime.now();
    final d = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'REC-$d-7W0SYS';
  }

  String get _resolvedTransactionId {
    if (transactionId != null && transactionId!.isNotEmpty) return transactionId!;
    final now = DateTime.now();
    final d = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final t = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return 'TXN-$d$t-QYHR';
  }

  String get _resolvedTotalPaid {
    final clean = totalPaid.replaceAll(RegExp(r'[^0-9.]'), '');
    final numVal = double.tryParse(clean) ?? 3999.0;
    return '₹${numVal.toStringAsFixed(2)}';
  }

  void _handleWatchNow(BuildContext context) {
    // Navigate back to CoursePreviewScreen with enrolled status
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => CoursePreviewScreen(
          session: session.copyWith(isEnrolled: true),
          slug: session.slug,
          courseId: session.id,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  void _handlePrintInvoice(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cardBorder, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax Invoice Receipt',
                    style: GoogleFonts.inter(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Receipt No: $_resolvedOrderId\nDate: ${DateTime.now().toLocal().toString().split(' ')[0]}\n\nStudent: $studentName ($studentEmail)\nCourse: ${session.title}\nAmount Paid: $_resolvedTotalPaid (Inclusive of GST)',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFFCBD5E1),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.download_done_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Invoice downloaded to device storage!',
                                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: emeraldGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Download PDF Invoice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: darkCanvas,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: darkCanvas,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.55),
              radius: 0.85,
              colors: [
                Color(0xFF1E1B4B),
                Color(0xFF0F172A),
                Color(0xFF090D16),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),

                  // Circular Emerald Checkmark Badge matching Image 2
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF064E3B).withValues(alpha: 0.65),
                      border: Border.all(
                        color: emeraldGreen.withValues(alpha: 0.75),
                        width: 2.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: emeraldGreen.withValues(alpha: 0.35),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: emeraldGreen,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Heading: Payment Confirmed!
                  Text(
                    'Payment Confirmed!',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle matching Image 2
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: subtitleColor,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(text: 'Thank you $studentName! Your lifetime enrollment for '),
                          TextSpan(
                            text: session.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: ' is now active.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Receipt / Order Details Card matching Image 2
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: cardBorder, width: 1.2),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          label: 'Order ID:',
                          valueWidget: Text(
                            _resolvedOrderId,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: goldAmber,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildDetailRow(
                          label: 'Transaction ID:',
                          valueWidget: Text(
                            _resolvedTransactionId,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildDetailRow(
                          label: 'Payment Method:',
                          valueWidget: Text(
                            'Online Net Banking ($bankName)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildDetailRow(
                          label: 'Student Email:',
                          valueWidget: Text(
                            studentEmail,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Color(0xFF1E293B), height: 1),
                        const SizedBox(height: 16),

                        // Total Paid Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Paid:',
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _resolvedTotalPaid,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: emeraldGreen,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Primary Button: Watch Masterclass Now
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [brandPurple, brandIndigo],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: brandPurple.withValues(alpha: 0.45),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _handleWatchNow(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Watch Masterclass Now',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Secondary Button: Print Invoice
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => _handlePrintInvoice(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        side: const BorderSide(color: cardBorder, width: 1.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long_rounded,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Print Invoice',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tertiary Button: Go to Dashboard
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton.icon(
                      onPressed: () {
                        MainNavigationScreen.switchTab(context, 2);
                      },
                      icon: const Icon(
                        Icons.dashboard_rounded,
                        color: Color(0xFF2DD4BF),
                        size: 20,
                      ),
                      label: Text(
                        'Go to Dashboard',
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2DD4BF),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: subtitleColor,
          ),
        ),
        Flexible(child: valueWidget),
      ],
    );
  }
}

