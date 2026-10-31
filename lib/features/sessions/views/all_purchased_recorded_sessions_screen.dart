import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_session_service.dart';
import '../../../core/services/purchased_sessions_service.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../models/recorded_session_model.dart';
import '../widgets/purchased_recorded_session_card.dart';
import 'recorded_sessions_screen.dart';

/// Screen displaying all purchased/enrolled recorded sessions for the user.
/// Opened via 'View All' from the Dashboard's Purchased Recorded Sessions section.
class AllPurchasedRecordedSessionsScreen extends StatefulWidget {
  const AllPurchasedRecordedSessionsScreen({super.key});

  @override
  State<AllPurchasedRecordedSessionsScreen> createState() =>
      _AllPurchasedRecordedSessionsScreenState();
}

class _AllPurchasedRecordedSessionsScreenState
    extends State<AllPurchasedRecordedSessionsScreen> {
  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color textMuted = Color(0xFF94A3B8);

  List<RecordedSessionModel> _purchasedSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPurchasedSessions();
  }

  Future<void> _loadPurchasedSessions() async {
    final list = PurchasedSessionsService.instance.getPurchasedSessions();
    setState(() {
      _purchasedSessions = list;
      _isLoading = list.isEmpty;
    });

    try {
      final user = AuthSessionService.instance.user;
      final userEmail = user?.email ?? AuthSessionService.instance.userEmail;
      final userId = (user?.id != null && user!.id > 0) ? user.id : 0;

      final updated = await PurchasedSessionsService.instance.syncFromApi(
        email: userEmail,
        userId: userId,
      );
      if (mounted) {
        setState(() {
          _purchasedSessions = updated;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _purchasedSessions =
              PurchasedSessionsService.instance.getPurchasedSessions();
          _isLoading = false;
        });
      }
    }
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
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Top App Bar with '<' and 'All Purchased Recorded Sessions'
              _buildTopAppBar(),

              // 2. Main Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: brandPurple),
                      )
                    : _purchasedSessions.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            color: brandPurple,
                            backgroundColor: cardBg,
                            onRefresh: () async {
                              _loadPurchasedSessions();
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                              itemCount: _purchasedSessions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 18),
                              itemBuilder: (context, index) {
                                return PurchasedRecordedSessionCard(
                                  session: _purchasedSessions[index],
                                  orientation: Axis.vertical,
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: darkCanvas,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF1E293B),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          const AppBackButton(),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'All Purchased Recorded Sessions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorder, width: 1.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF141C2E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videocam_rounded,
                  color: Color(0xFF64748B),
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No Purchased Recorded Sessions Yet',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'You have not purchased any recorded masterclasses yet. Once you complete a purchase, your lifetime access sessions will appear here.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandPurple, brandIndigo],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: brandPurple.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RecordedSessionsScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore Masterclasses',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

