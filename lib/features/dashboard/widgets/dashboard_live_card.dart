import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../sessions/models/live_session_model.dart';
import '../../sessions/widgets/session_detail_dialog.dart';

class DashboardLiveCard extends StatelessWidget {
  final LiveSessionModel session;

  const DashboardLiveCard({
    super.key,
    required this.session,
  });

  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color goldAmber = Color(0xFFF59E0B);
  static const Color yellowFee = Color(0xFFFBBF24);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final catName = session.categoryName.isNotEmpty
        ? session.categoryName
        : 'Corporate Skills';
    final badge = session.badgeText ?? 'Popular';
    final fee = session.fee.isNotEmpty ? session.fee : '₹99';
    final originalFee =
        session.originalFee.isNotEmpty ? session.originalFee : '₹199';

    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Category Tag + Popular Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      catName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: goldAmber,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: goldAmber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: goldAmber.withValues(alpha: 0.5),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: goldAmber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 2. Title
              Text(
                session.title,
                style: GoogleFonts.inter(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // 3. Description
              Text(
                session.description,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // 4. Date Row
              Row(
                children: [
                  const Text('🗓 ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFFCBD5E1),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Date: ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: session.date),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // 5. Fee Row
              Row(
                children: [
                  const Text('₹ ',
                      style: TextStyle(fontSize: 12, color: yellowFee)),
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFFCBD5E1),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Participation Fee: ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: fee.startsWith('₹') ? fee : '₹$fee',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: yellowFee,
                              fontSize: 12.5,
                            ),
                          ),
                          const TextSpan(text: '  '),
                          TextSpan(
                            text: originalFee.startsWith('₹')
                                ? originalFee
                                : '₹$originalFee',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 6. View Details Button
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [brandPurple, brandIndigo],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: brandPurple.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () =>
                    SessionDetailDialog.showLiveSession(context, session),
                child: Center(
                  child: Text(
                    'View Details',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

