import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../view_models/sessions_view_model.dart';
import '../widgets/horizontal_live_session_card.dart';
import '../widgets/horizontal_recorded_session_card.dart';
import '../widgets/session_header.dart';
import '../../../shared/widgets/widgets.dart';
import 'all_live_sessions_screen.dart';
import 'recorded_sessions_screen.dart';

class SessionsScreen extends StatefulWidget {
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;

  const SessionsScreen({
    super.key,
    this.showBottomNav = false,
    this.onTabSelected,
  });

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late final SessionsViewModel _viewModel;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandRed = Color(0xFFEF4444);

  @override
  void initState() {
    super.initState();
    _viewModel = SessionsViewModel();
    _viewModel.init();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _navigateToAllLiveSessions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AllLiveSessionsScreen(viewModel: _viewModel),
      ),
    );
  }

  void _navigateToRecordedSessions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordedSessionsScreen(viewModel: _viewModel),
      ),
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
    final liveSessions = _viewModel.liveSessions;
    final recordedSessions = _viewModel.recordedSessions;
    final topLiveSessions = liveSessions.take(3).toList();
    final topRecordedSessions = recordedSessions.take(3).toList();

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
              // Header
              SessionHeader(
                title: 'Sessions',
                subtitle: 'Masterclasses, live workshops & recordings',
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    MainNavigationScreen.switchTab(context, 0);
                  }
                },
              ),

              // Main Body with pull-to-refresh
              Expanded(
                child: RefreshIndicator(
                  color: brandPurple,
                  backgroundColor: const Color(0xFF131B2E),
                  onRefresh: () => _viewModel.init(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION 1: LIVE SESSIONS (Top 3 Cards Horizontal Scroll)
                        _buildSectionHeader(
                          iconWidget: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: brandRed,
                            ),
                          ),
                          title: 'Live Sessions',
                          tagLabel: 'LIVE & UPCOMING',
                          tagBg: brandRed.withValues(alpha: 0.15),
                          tagBorder: brandRed.withValues(alpha: 0.35),
                          tagTextColor: const Color(0xFFF87171),
                          onViewAllTap: _navigateToAllLiveSessions,
                        ),
                        const SizedBox(height: 14),

                        // Horizontal Live Sessions List
                        SizedBox(
                          height: 285,
                          child:
                              _viewModel.isLoadingLive &&
                                  topLiveSessions.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: brandPurple,
                                  ),
                                )
                              : _viewModel.liveError != null &&
                                    topLiveSessions.isEmpty
                              ? _buildErrorWidget(
                                  message: _viewModel.liveError!,
                                  onRetry: () => _viewModel.fetchLiveSessions(),
                                )
                              : topLiveSessions.isEmpty
                              ? _buildEmptyWidget(
                                  'No live sessions available right now.',
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: topLiveSessions.length,
                                  separatorBuilder: (context, _) =>
                                      const SizedBox(width: 14),
                                  itemBuilder: (context, index) {
                                    return HorizontalLiveSessionCard(
                                      session: topLiveSessions[index],
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 28),

                        // SECTION 2: RECORDED SESSIONS (Top 3 Cards Horizontal Scroll)
                        _buildSectionHeader(
                          iconWidget: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: brandPurple.withValues(alpha: 0.2),
                              border: Border.all(
                                color: brandPurple.withValues(alpha: 0.5),
                                width: 1.0,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 14,
                                color: brandPurple,
                              ),
                            ),
                          ),
                          title: 'Recorded Sessions',
                          tagLabel: 'On Demand',
                          tagBg: const Color(0xFF1E293B),
                          tagBorder: const Color(0xFF334155),
                          tagTextColor: const Color(0xFF94A3B8),
                          onViewAllTap: _navigateToRecordedSessions,
                        ),
                        const SizedBox(height: 14),

                        // Horizontal Recorded Sessions List
                        SizedBox(
                          height: 330,
                          child:
                              _viewModel.isLoadingRecorded &&
                                  topRecordedSessions.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: brandPurple,
                                  ),
                                )
                              : _viewModel.recordedError != null &&
                                    topRecordedSessions.isEmpty
                              ? _buildErrorWidget(
                                  message: _viewModel.recordedError!,
                                  onRetry: () =>
                                      _viewModel.fetchRecordedSessions(),
                                )
                              : topRecordedSessions.isEmpty
                              ? _buildEmptyWidget(
                                  'No recorded sessions available right now.',
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: topRecordedSessions.length,
                                  separatorBuilder: (context, _) =>
                                      const SizedBox(width: 14),
                                  itemBuilder: (context, index) {
                                    return HorizontalRecordedSessionCard(
                                      session: topRecordedSessions[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.showBottomNav
            ? AboutBottomNavBar(
                selectedIndex: 1,
                onItemTapped: _handleBottomNavTap,
              )
            : null,
      ),
    );
  }

  Widget _buildSectionHeader({
    required Widget iconWidget,
    required String title,
    required String tagLabel,
    required Color tagBg,
    required Color tagBorder,
    required Color tagTextColor,
    required VoidCallback onViewAllTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AppBadge(
                  label: tagLabel,
                  backgroundColor: tagBg,
                  borderColor: tagBorder,
                  textColor: tagTextColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onViewAllTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: brandPurple,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 13,
                  color: brandPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 36,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 15),
              label: Text(
                'Retry',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.inter(fontSize: 13, color: Colors.white60),
      ),
    );
  }
}
