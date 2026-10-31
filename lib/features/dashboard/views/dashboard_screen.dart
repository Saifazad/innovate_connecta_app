import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/purchased_sessions_service.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../resources/views/resources_screen.dart';
import '../../profile/views/certificates_screen.dart';
import '../../sessions/views/all_live_sessions_screen.dart';
import '../../sessions/views/all_purchased_recorded_sessions_screen.dart';
import '../../sessions/views/recorded_sessions_screen.dart';
import '../../sessions/widgets/purchased_recorded_session_card.dart';
import '../view_models/dashboard_view_model.dart';
import '../widgets/dashboard_live_card.dart';
import '../../../shared/widgets/app_stat_card.dart';
import '../../../app/main_navigation_screen.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardViewModel? viewModel;
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;

  const DashboardScreen({
    super.key,
    this.viewModel,
    this.showBottomNav = false,
    this.onTabSelected,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardViewModel _viewModel;
  bool _ownsViewModel = false;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color innerBoxBg = Color(0xFF0B101D);
  static const Color innerBoxBorder = Color(0xFF1B2438);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color goldAmber = Color(0xFFF59E0B);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = DashboardViewModel();
      _ownsViewModel = true;
      _viewModel.loadDashboardData();
    }

    PurchasedSessionsService.instance.purchaseCountNotifier.addListener(_onPurchasesChanged);
  }

  void _onPurchasesChanged() {
    if (mounted) {
      _viewModel.loadDashboardData();
    }
  }

  @override
  void dispose() {
    PurchasedSessionsService.instance.purchaseCountNotifier.removeListener(_onPurchasesChanged);
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
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
        appBar: _buildAppBar(context),
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return RefreshIndicator(
              color: brandPurple,
              backgroundColor: cardBg,
              onRefresh: () => _viewModel.loadDashboardData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // 1. Welcome Greeting Row (Avatar + Name)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildGreetingSection(),
                    ),
                    const SizedBox(height: 20),

                    // 2. Four Stat Cards (Live Sessions, Recordings, Resources, Certificates)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildStatCardsRow(),
                    ),
                    const SizedBox(height: 28),

                    // 3. Upcoming Live Sessions (Header + Horizontal Scrollable 3 Cards)
                    _buildUpcomingLiveSessionsSection(),
                    const SizedBox(height: 28),

                    // 4. Purchased Recorded Sessions Section
                    _buildPurchasedRecordedSection(),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: widget.showBottomNav
            ? AboutBottomNavBar(
                selectedIndex: 2,
                centerLabel: 'Dashboard',
                onItemTapped: _handleBottomNavTap,
              )
            : null,
      ),
    );
  }

  /// App Bar: "< My Dashboard"
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: darkCanvas,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
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
      title: Text(
        'My Dashboard',
        style: GoogleFonts.inter(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: false,
    );
  }

  /// 1. Greeting Section: Circular Avatar with Yellow Verified Badge + Welcome back, {Name}! 👋
  Widget _buildGreetingSection() {
    final displayName = _viewModel.greetingName;

    return Row(
      children: [
        // Avatar with verified badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [brandPurple, brandIndigo],
                ),
                border: Border.all(color: const Color(0xFF6366F1), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: brandPurple.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: _viewModel.profileImageUrl != null
                    ? Image.network(
                        _viewModel.profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildAvatarFallback(),
                      )
                    : _buildAvatarFallback(),
              ),
            ),
            // Yellow check badge
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: goldAmber,
                  shape: BoxShape.circle,
                  border: Border.all(color: darkCanvas, width: 2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),

        // Welcome back, {Name}! 👋
        Expanded(
          child: Text(
            'Welcome back, $displayName! 👋',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: const Color(0xFF1E293B),
      child: Center(
        child: Text(
          _viewModel.greetingName.isNotEmpty
              ? _viewModel.greetingName[0].toUpperCase()
              : 'A',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 2. Four Metric Stat Cards in a row:
  /// - Live Sessions (dynamic)
  /// - Recordings (dynamic)
  /// - Resources (static 8)
  /// - Certificates (dynamic count present)
  Widget _buildStatCardsRow() {
    return Row(
      children: [
        AppStatCard.metric(
          icon: Icons.calendar_today_rounded,
          iconColor: const Color(0xFF60A5FA),
          iconBgColor: const Color(0xFF1E3A8A).withValues(alpha: 0.4),
          title: 'Live Sessions',
          value: _viewModel.liveSessionsCount.toString(),
          subtitle: 'Purchased',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AllLiveSessionsScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
        AppStatCard.metric(
          icon: Icons.play_arrow_rounded,
          iconColor: const Color(0xFF34D399),
          iconBgColor: const Color(0xFF064E3B).withValues(alpha: 0.45),
          title: 'Recordings',
          value: _viewModel.recordedSessionsCount.toString(),
          subtitle: 'Available',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RecordedSessionsScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
        AppStatCard.metric(
          icon: Icons.folder_rounded,
          iconColor: const Color(0xFFFBBF24),
          iconBgColor: const Color(0xFF78350F).withValues(alpha: 0.45),
          title: 'Resources',
          value: _viewModel.resourcesCount.toString(),
          subtitle: 'Files',
          onTap: () {
            if (widget.onTabSelected != null) {
              widget.onTabSelected!(3);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ResourcesScreen()),
              );
            }
          },
        ),
        const SizedBox(width: 8),
        AppStatCard.metric(
          icon: Icons.military_tech_rounded,
          iconColor: const Color(0xFFC084FC),
          iconBgColor: const Color(0xFF581C87).withValues(alpha: 0.45),
          title: 'Certificates',
          value: _viewModel.certificatesCount.toString(),
          subtitle: 'Earned',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CertificatesScreen()),
            );
          },
        ),
      ],
    );
  }

  /// 3. Upcoming Live Sessions Section
  /// - Title: Upcoming Live Sessions
  /// - Subtitle: Your registered live classes and webinars
  /// - View All → (navigates to AllLiveSessionsScreen)
  /// - 3 Horizontal scrollable cards
  Widget _buildUpcomingLiveSessionsSection() {
    final sessions = _viewModel.upcomingLiveSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Live Sessions',
                      style: GoogleFonts.inter(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Your registered live classes and webinars',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AllLiveSessionsScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All ',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF818CF8),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF818CF8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal Scrollable Cards (top 3)
        SizedBox(
          height: 285,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return DashboardLiveCard(session: sessions[index]);
            },
          ),
        ),
      ],
    );
  }

  /// 4. Purchased Recorded Sessions Section
  /// - When no sessions purchased: Empty state card with 'Explore Masterclasses' CTA
  /// - When purchased: Top 3 cards in horizontal scroll + View All navigates to AllPurchasedRecordedSessionsScreen
  Widget _buildPurchasedRecordedSection() {
    final localPurchased =
        PurchasedSessionsService.instance.getPurchasedSessions();
    final purchased = _viewModel.purchasedRecordedSessions.isNotEmpty
        ? _viewModel.purchasedRecordedSessions
        : localPurchased;

    if (purchased.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorder, width: 1.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFF2DD4BF),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Purchased Recorded Sessions',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Watch your purchased session recordings',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const AllPurchasedRecordedSessionsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'View All (0) →',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF60A5FA),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Inner Empty State Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  color: innerBoxBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: innerBoxBorder, width: 1.1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cam Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFF141C2E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.videocam_rounded,
                        color: Color(0xFF64748B),
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Title
                    Text(
                      'No Purchased Recorded Sessions Yet',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'You have not purchased any recorded masterclasses yet.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // Explore Masterclasses CTA Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [brandPurple, brandIndigo],
                        ),
                        borderRadius: BorderRadius.circular(20),
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
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RecordedSessionsScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bolt_rounded,
                                  color: Color(0xFFFBBF24),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Explore Masterclasses',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
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
            ],
          ),
        ),
      );
    }

    // User has purchased sessions: display at most 3 cards
    final topPurchased = purchased.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF2DD4BF),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Purchased Recorded Sessions',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Watch your purchased session recordings',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const AllPurchasedRecordedSessionsScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All (${purchased.length}) ',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2DD4BF),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: Color(0xFF2DD4BF),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal Scrollable Cards (at most 3 cards as requested)
        SizedBox(
          height: 330,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: topPurchased.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return PurchasedRecordedSessionCard(
                session: topPurchased[index],
                orientation: Axis.horizontal,
              );
            },
          ),
        ),
      ],
    );
  }
}

