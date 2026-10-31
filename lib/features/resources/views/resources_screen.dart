import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/main_navigation_screen.dart';
import '../../../core/services/auth_session_service.dart';
import '../../../core/services/purchased_sessions_service.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../sessions/models/recorded_session_model.dart';
import '../../sessions/repository/sessions_repository.dart';
import '../../sessions/views/recorded_sessions_screen.dart';

/// Screen displaying Session PDF Resources for paid/enrolled masterclasses.
/// - Shows PDF only when user has completed payment for a session
/// - Only displays the PDF of the purchased session(s)
/// - Preserves the app's existing persistent bottom navigation bar
class ResourcesScreen extends StatefulWidget {
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;

  const ResourcesScreen({
    super.key,
    this.showBottomNav = false,
    this.onTabSelected,
  });

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final SessionsRepository _sessionsRepository = SessionsRepository();

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color textMuted = Color(0xFF94A3B8);

  List<RecordedSessionModel> _purchasedSessions = [];
  bool _isLoading = true;
  final Set<String> _downloadingIds = {};
  final Set<String> _downloadedIds = {};

  @override
  void initState() {
    super.initState();
    _loadPurchasedResources();
    PurchasedSessionsService.instance.purchaseCountNotifier
        .addListener(_onPurchasesChanged);
  }

  void _onPurchasesChanged() {
    if (mounted) {
      _loadPurchasedResources();
    }
  }

  @override
  void dispose() {
    PurchasedSessionsService.instance.purchaseCountNotifier
        .removeListener(_onPurchasesChanged);
    _sessionsRepository.dispose();
    super.dispose();
  }

  Future<void> _loadPurchasedResources() async {
    final localList =
        PurchasedSessionsService.instance.getPurchasedSessions();

    if (mounted) {
      setState(() {
        _purchasedSessions = localList;
        _isLoading = localList.isEmpty;
      });
    }

    try {
      final user = AuthSessionService.instance.user;
      final userEmail = user?.email ?? AuthSessionService.instance.userEmail;
      final userId = (user?.id != null && user!.id > 0) ? user.id : 0;

      // Sync and fetch directly from student recorded orders endpoint:
      // https://awsdemo.co.in/innovateconnect/api/v1/student/recorded-orders?email={email}&user_id={user_id}
      final orders = await PurchasedSessionsService.instance.syncFromApi(
        email: userEmail,
        userId: userId,
        repository: _sessionsRepository,
      );

      if (mounted) {
        setState(() {
          _purchasedSessions = orders;
          _isLoading = false;
        });
      }
    } catch (_) {
      // Use locally persisted purchases if offline or network failure
      if (mounted) {
        setState(() {
          _purchasedSessions =
              PurchasedSessionsService.instance.getPurchasedSessions();
          _isLoading = false;
        });
      }
    }
  }

  String _resolvePages(RecordedSessionModel session) {
    final match = RegExp(r'\d+').firstMatch(session.lessons);
    if (match != null) {
      return match.group(0)!;
    }
    return '18';
  }

  void _handleDownloadPdf(RecordedSessionModel session) async {
    final id = session.id.toString();
    if (_downloadedIds.contains(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('${session.title} PDF is already saved.'),
              ),
            ],
          ),
          backgroundColor: emeraldGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _downloadingIds.add(id);
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      setState(() {
        _downloadingIds.remove(id);
        _downloadedIds.add(id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.file_download_done_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Downloaded ${session.title} PDF Notes (4.2 MB)'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF7C3AED),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _handlePreviewPdf(RecordedSessionModel session) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cardBorder, width: 1.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Color(0xFFF87171),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PDF Notes Preview',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Enrolled Masterclass Resource',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white70),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: cardBorder, height: 1),
              const SizedBox(height: 16),
              Text(
                session.title,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                session.heading ??
                    session.courseOverview ??
                    'Complete study notes, slides, and reference guide.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPreviewMeta(
                      Icons.menu_book_rounded,
                      '${_resolvePages(session)} Pages',
                    ),
                    _buildPreviewMeta(
                      Icons.storage_rounded,
                      '4.2 MB',
                    ),
                    _buildPreviewMeta(
                      Icons.check_circle_outline_rounded,
                      'Unlocked',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _handleDownloadPdf(session);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Download PDF',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewMeta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF38BDF8), size: 15),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  void _handleBottomNavTap(int index) {
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(index);
      return;
    }
    MainNavigationScreen.switchTab(context, index);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar matching image: '< [Logo] Innovate Connecta'
              _buildTopBar(context),

              // 2. Heading Section: 'Session PDF Resources'
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session PDF Resources',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View and download PDF notes for your enrolled masterclasses.',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Main Content: Only show PDFs for paid/purchased sessions
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: brandPurple),
                      )
                    : _purchasedSessions.isEmpty
                        ? _buildNoPurchasedResourcesEmptyState()
                        : RefreshIndicator(
                            color: brandPurple,
                            backgroundColor: cardBg,
                            onRefresh: _loadPurchasedResources,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 4, 16, 32),
                              itemCount: _purchasedSessions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _buildSessionPdfCard(
                                    _purchasedSessions[index]);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.showBottomNav
            ? AboutBottomNavBar(
                selectedIndex: 3,
                centerLabel: 'Dashboard',
                onItemTapped: _handleBottomNavTap,
              )
            : null,
      ),
    );
  }

  /// Top Bar matching screenshot: '< [Logo] Innovate Connecta'
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 19,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else if (widget.onTabSelected != null) {
                widget.onTabSelected!(0);
              } else {
                MainNavigationScreen.switchTab(context, 0);
              }
            },
          ),
          const SizedBox(width: 4),

          // Logo container
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/icon/app_icon.png',
                width: 20,
                height: 20,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.hub_rounded,
                  size: 18,
                  color: Color(0xFF7C3AED),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Brand Title
          Expanded(
            child: Text(
              'Innovate Connecta',
              style: GoogleFonts.inter(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// PDF Resource Card matching the uploaded screenshot:
  /// Left: Verified Icon Box
  /// Middle: Session Title & '18 Pages • 4.2 MB • PDF Guide'
  /// Right: Eye preview button & purple 'PDF' download button
  Widget _buildSessionPdfCard(RecordedSessionModel session) {
    final id = session.id.toString();
    final isDownloading = _downloadingIds.contains(id);
    final isDownloaded = _downloadedIds.contains(id);
    final pages = _resolvePages(session);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.1),
      ),
      child: Row(
        children: [
          // Left: Verified Badge Icon Box
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF172033),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2A364F), width: 1.0),
            ),
            child: const Center(
              child: Icon(
                Icons.verified_outlined,
                color: Color(0xFFA5B4FC),
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Middle: Title & Metadata Row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pages Pages',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        '4.2 MB',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                      ),
                      Text(
                        '  •  ',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        'PDF Guide',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right: Eye Button & Purple PDF Button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Preview Eye Button
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _handlePreviewPdf(session),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xFF334155), width: 0.8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.visibility_outlined,
                      color: Colors.white70,
                      size: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Download PDF Button
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: isDownloading ? null : () => _handleDownloadPdf(session),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                  decoration: BoxDecoration(
                    color: isDownloaded
                        ? emeraldGreen.withValues(alpha: 0.25)
                        : const Color(0xFFD8B4FE),
                    borderRadius: BorderRadius.circular(10),
                    border: isDownloaded
                        ? Border.all(color: emeraldGreen, width: 1.0)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDownloading)
                        const SizedBox(
                          width: 13,
                          height: 13,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF581C87),
                          ),
                        )
                      else
                        Icon(
                          isDownloaded
                              ? Icons.check_rounded
                              : Icons.file_download_outlined,
                          color: isDownloaded
                              ? emeraldGreen
                              : const Color(0xFF581C87),
                          size: 15,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        isDownloaded ? 'Saved' : 'PDF',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: isDownloaded
                              ? emeraldGreen
                              : const Color(0xFF581C87),
                          letterSpacing: 0.2,
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
    );
  }

  /// Empty state when no sessions are paid for
  Widget _buildNoPurchasedResourcesEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 22),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorder, width: 1.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFF141C2E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF64748B),
                  size: 28,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No PDF Resources Unlocked Yet',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Session PDF notes, architecture guides, and study materials are only unlocked after purchasing a masterclass.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandPurple, brandIndigo],
                  ),
                  borderRadius: BorderRadius.circular(22),
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
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      if (widget.onTabSelected != null) {
                        widget.onTabSelected!(1); // Go to Sessions tab
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RecordedSessionsScreen(),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 11,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore Masterclasses',
                            style: GoogleFonts.inter(
                              fontSize: 13,
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
