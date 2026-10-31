import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/views/services_screen.dart';
import '../../services/models/service_item.dart';
import '../../gallery/views/gallery_screen.dart';
import '../../gallery/models/gallery_item.dart';
import '../../gallery/widgets/gallery_card.dart';
import '../../gallery/widgets/gallery_detail_dialog.dart';
import '../../contact/views/contact_screen.dart';
import '../../about/views/our_values_screen.dart';
import '../../about/constants/about_strings.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../testimonials/views/testimonials_screen.dart';
import '../../testimonials/models/testimonial_model.dart';
import '../../testimonials/repository/testimonials_repository.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_live_session_card.dart';
import '../../sessions/views/all_live_sessions_screen.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../app/main_navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;
  final TestimonialsRepository? testimonialsRepository;

  const HomeScreen({
    super.key,
    this.showBottomNav = false,
    this.onTabSelected,
    this.testimonialsRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedGalleryChip = 0; // 0 = All Photos, 1 = Campus Drives, 2 = Corporate Sessions

  late final TestimonialsRepository _testimonialsRepo;
  List<TestimonialModel> _testimonials = [];
  bool _isLoadingTestimonials = true;

  static const List<TestimonialModel> _fallbackTestimonials = [
    TestimonialModel(
      id: 101,
      name: 'Arnav Khugshal',
      designation: 'BSc Chemistry',
      initials: 'AK',
      review:
          'InnoVate Connecta was very helpful for me. It also helped me decide what I need to do in order to reach my goal.',
      rating: 5.0,
      isVerified: true,
    ),
    TestimonialModel(
      id: 102,
      name: 'Navneet Singh',
      designation: 'MSc Computer Science',
      initials: 'NS',
      review:
          'InnoVate helped clarify my path towards corporate careers and helped me understand the practical expectations of industry.',
      rating: 5.0,
      isVerified: true,
    ),
    TestimonialModel(
      id: 103,
      name: 'Md Kaif',
      designation: 'BTech CSE',
      initials: 'MK',
      review:
          'Awesome experience! The workshops gave me hands-on experience that immediately helped in my campus recruitment drive.',
      rating: 5.0,
      isVerified: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _testimonialsRepo =
        widget.testimonialsRepository ?? TestimonialsRepository();
    _fetchTestimonials();
  }

  @override
  void dispose() {
    _testimonialsRepo.dispose();
    super.dispose();
  }

  Future<void> _fetchTestimonials() async {
    try {
      final response = await _testimonialsRepo.fetchTestimonials();
      if (mounted) {
        setState(() {
          if (response.status && response.data.isNotEmpty) {
            _testimonials = response.data;
          }
          _isLoadingTestimonials = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingTestimonials = false;
        });
      }
    }
  }

  Color _getAvatarColor(int id, String name) {
    const colors = [
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFFA855F7),
      Color(0xFF3B82F6),
      Color(0xFFEC4899),
      Color(0xFF06B6D4),
    ];
    final hash = id > 0 ? id : name.hashCode;
    return colors[hash.abs() % colors.length];
  }

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandAmber = Color(0xFFF59E0B);
  static const Color subtitleColor = Color(0xFF94A3B8);

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
        key: _scaffoldKey,
        backgroundColor: darkCanvas,
        drawer: const HomeDrawer(),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildTopAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildHeroSection(context),
                      const SizedBox(height: 28),
                      _buildLiveSessionsSection(context),
                      const SizedBox(height: 28),
                      _buildGallerySection(context),
                      const SizedBox(height: 28),
                      _buildProgramsSection(context),
                      const SizedBox(height: 28),
                      _buildValuesSection(context),
                      const SizedBox(height: 28),
                      _buildTestimonialsSection(context),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.showBottomNav
            ? AboutBottomNavBar(
                selectedIndex: 0,
                centerLabel: 'Dashboard',
                onItemTapped: (index) {
                  if (widget.onTabSelected != null) {
                    widget.onTabSelected!(index);
                  } else {
                    MainNavigationScreen.switchTab(context, index);
                  }
                },
              )
            : null,
      ),
    );
  }

  /// Top App Bar: Hamburger menu, Innovate Connecta logo, and notification icon
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: darkCanvas,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger Menu
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cardBorder, width: 1.1),
              ),
              child: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Logo Title: InnoVate (White) Connecta (Orange)
          const BrandLogo(fontSize: 18.5),

          // Notifications Icon
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications right now.'),
                  backgroundColor: Color(0xFF1E293B),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cardBorder, width: 1.1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 6.5,
                      height: 6.5,
                      decoration: const BoxDecoration(
                        color: brandOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Hero Section: MSME Badge, Headline, Subtitle, Explore Services CTA, Book & Contact
  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // MSME Registered Organisation Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF451A03).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: brandAmber.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: brandAmber,
                size: 13,
              ),
              const SizedBox(width: 6),
              Text(
                'MSME REGISTERED ORGANISATION',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: brandAmber,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Main Headline: Where Ambition Meets Innovation
        Text(
          'Where Ambition',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Meets ',
                style: GoogleFonts.inter(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFC084FC),
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Innovation',
                style: GoogleFonts.inter(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFFB923C),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Transform your professional journey with expert career guidance, hands-on workshops, internship placements, and upskilling programs, and more.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Explore Services Button (Navigates to ServicesScreen)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: brandPurple.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ServicesScreen(showBottomNav: false)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Explore Services →',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Static Book Live Session & Dynamic Contact Buttons
        Row(
          children: [
            // Book Live Session (Navigates to AllLiveSessionsScreen)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AllLiveSessionsScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF101726),
                  side: const BorderSide(color: cardBorder, width: 1.1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('📒 ', style: TextStyle(fontSize: 13)),
                    Flexible(
                      child: Text(
                        'Book Live Session',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Contact Button (Navigates to ContactScreen)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ContactScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF101726),
                  side: const BorderSide(color: cardBorder, width: 1.1),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Contact',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2. Section: UPCOMING PROGRAMS - Live Sessions (Static as requested)
  Widget _buildLiveSessionsSection(BuildContext context) {
    const sessions = LiveSessionData.sampleSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          eyebrow: 'Upcoming Programs',
          titlePrefix: 'Live ',
          titleHighlight: 'Sessions',
          subtitle:
              'Interactive masterclasses, mentorship sessions & workshops led by industry leaders.',
          actionLabel: 'View All →',
          onActionTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AllLiveSessionsScreen()),
            );
          },
        ),
        const SizedBox(height: 14),

        // Horizontal scrolling session cards
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return HomeLiveSessionCard(session: sessions[index]);
            },
          ),
        ),
      ],
    );
  }

  /// 3. Section: GALLERY - Event Gallery (3 Cards Horizontal Scroll, View All opens GalleryScreen)
  Widget _buildGallerySection(BuildContext context) {
    // 3 showcase gallery cards
    const galleryItems = GalleryItem.defaultShowcaseItems;
    final topThreeItems = galleryItems.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          eyebrow: 'Gallery',
          titlePrefix: 'Event ',
          titleHighlight: 'Gallery',
          subtitle:
              'Highlights and memorable moments from our masterclasses, campus drives, and corporate workshops.',
          actionLabel: 'View All →',
          onActionTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GalleryScreen()),
            );
          },
        ),
        const SizedBox(height: 12),

        // Horizontal Category Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildGalleryFilterChip('All Photos', 0),
              const SizedBox(width: 8),
              _buildGalleryFilterChip('Campus Drives', 1),
              const SizedBox(width: 8),
              _buildGalleryFilterChip('Corporate Sessions', 2),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 3 Horizontal Cards
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: topThreeItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = topThreeItems[index];
              return SizedBox(
                width: 155,
                child: GalleryCard(
                  item: item,
                  onTap: () => GalleryDetailDialog.show(context, item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryFilterChip(String label, int index) {
    final isSelected = _selectedGalleryChip == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedGalleryChip = index);
        if (index > 0) {
          // If clicked on specific category, opens full gallery
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const GalleryScreen()),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                )
              : null,
          color: isSelected ? null : const Color(0xFF131B2E),
          border: Border.all(
            color: isSelected ? Colors.transparent : cardBorder,
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : subtitleColor,
          ),
        ),
      ),
    );
  }

  /// 4. Section: PROGRAMS - Our Services (Horizontal cards, View All opens ServicesScreen)
  Widget _buildProgramsSection(BuildContext context) {
    final services = ServiceItem.defaultServices.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          eyebrow: 'Programs',
          titlePrefix: 'Our ',
          titleHighlight: 'Services',
          actionLabel: 'View All →',
          onActionTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ServicesScreen(showBottomNav: false)),
            );
          },
        ),
        const SizedBox(height: 14),

        SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildHomeServiceCard(context, service);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHomeServiceCard(BuildContext context, ServiceItem service) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ServicesScreen(showBottomNav: false)),
        );
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cardBorder, width: 1.1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF251239),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: brandPurple.withValues(alpha: 0.35),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    service.icon,
                    color: const Color(0xFFC084FC),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  service.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),

                // Description
                Text(
                  service.description,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Tag Pill
            if (service.tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: brandPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: brandPurple.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  service.tags.first,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFC084FC),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 5. Section: CORE ETHOS - Our Values (Horizontal cards, View All opens OurValuesScreen)
  Widget _buildValuesSection(BuildContext context) {
    const valuesList = [
      (
        icon: Icons.school_rounded,
        iconColor: Color(0xFFF97316),
        iconBgColor: Color(0xFF2B1608),
        title: AboutStrings.value1Title,
        desc: AboutStrings.value1Desc,
      ),
      (
        icon: Icons.workspace_premium_rounded,
        iconColor: Color(0xFF38BDF8),
        iconBgColor: Color(0xFF0F203D),
        title: AboutStrings.value2Title,
        desc: AboutStrings.value2Desc,
      ),
      (
        icon: Icons.lightbulb_outline_rounded,
        iconColor: Color(0xFFF43F5E),
        iconBgColor: Color(0xFF2E1022),
        title: AboutStrings.value3Title,
        desc: AboutStrings.value3Desc,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          eyebrow: 'Core Ethos',
          titlePrefix: 'Our ',
          titleHighlight: 'Values',
          subtitle:
              'The fundamental principles that guide our programs, mentorship sessions, and educational collaborations.',
          actionLabel: 'View All →',
          onActionTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OurValuesScreen(showBottomNav: false)),
            );
          },
        ),
        const SizedBox(height: 14),

        SizedBox(
          height: 175,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: valuesList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final val = valuesList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OurValuesScreen(showBottomNav: false)),
                  );
                },
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: cardBorder, width: 1.1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: val.iconBgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: val.iconColor.withValues(alpha: 0.35),
                            width: 1.0,
                          ),
                        ),
                        child: Icon(val.icon, color: val.iconColor, size: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        val.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        val.desc,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 6. Section: TESTIMONIALS - What Our Students Say (Only 3 cards on Home, View All opens TestimonialsScreen)
  Widget _buildTestimonialsSection(BuildContext context) {
    final rawList =
        _testimonials.isNotEmpty ? _testimonials : _fallbackTestimonials;
    final displayList = rawList.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          eyebrow: 'Testimonials',
          titlePrefix: 'What Our ',
          titleHighlight: 'Students',
          titleSuffix: ' Say',
          actionLabel: 'View All →',
          onActionTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TestimonialsScreen()),
            );
          },
        ),
        const SizedBox(height: 14),

        if (_isLoadingTestimonials && _testimonials.isEmpty)
          SizedBox(
            height: 195,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                return Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: cardBorder, width: 1.1),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: brandPurple,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        else
          SizedBox(
            height: 195,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: displayList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final t = displayList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TestimonialsScreen()),
                    );
                  },
                  child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cardBorder, width: 1.1),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dynamic Stars based on t.rating
                            Row(
                              children: List.generate(
                                5,
                                (starIdx) => Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: Icon(
                                    starIdx < t.rating.round()
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: const Color(0xFFF59E0B),
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Review Quote
                            Text(
                              '"${t.review}"',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFE2E8F0),
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        // User Row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: _getAvatarColor(t.id, t.name),
                              backgroundImage: (t.avatarUrl != null &&
                                      t.avatarUrl!.trim().isNotEmpty)
                                  ? NetworkImage(t.avatarUrl!)
                                  : null,
                              child: (t.avatarUrl == null ||
                                      t.avatarUrl!.trim().isEmpty)
                                  ? Text(
                                      t.initials.isNotEmpty
                                          ? t.initials
                                          : (t.name.isNotEmpty
                                              ? t.name[0].toUpperCase()
                                              : 'U'),
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    t.designation.isNotEmpty
                                        ? t.designation
                                        : 'Student',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: subtitleColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (t.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B)
                                      .withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFF59E0B)
                                        .withValues(alpha: 0.35),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  'Verified ✓',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
