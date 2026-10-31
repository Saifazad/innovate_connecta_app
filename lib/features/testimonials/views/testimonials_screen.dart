import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/testimonials_view_model.dart';
import '../widgets/testimonial_card.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../../shared/widgets/widgets.dart';

class TestimonialsScreen extends StatefulWidget {
  final bool showBottomNav;

  const TestimonialsScreen({super.key, this.showBottomNav = false});

  @override
  State<TestimonialsScreen> createState() => _TestimonialsScreenState();
}

class _TestimonialsScreenState extends State<TestimonialsScreen> {
  late final TestimonialsViewModel _viewModel;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color topBarColor = Color(0xFF0A0F1D);
  static const Color brandOrange = Color(0xFFFF6B00);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color subtitleColor = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _viewModel = TestimonialsViewModel();
    _viewModel.fetchTestimonials();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
          bottom: !widget.showBottomNav,
          child: Column(
            children: [
              _buildTopAppBar(context),
              Expanded(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return RefreshIndicator(
                      color: brandPurple,
                      backgroundColor: const Color(0xFF131B2E),
                      onRefresh: () =>
                          _viewModel.fetchTestimonials(isRefresh: true),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          // Header and Rating Overview
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Eyebrow
                                  Text(
                                    'COMMUNITY VOICES',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: brandOrange,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Main Title
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'What Our ',
                                          style: GoogleFonts.inter(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Learners',
                                          style: GoogleFonts.inter(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            color: brandPurple,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Say',
                                          style: GoogleFonts.inter(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Subtitle
                                  Text(
                                    'Real feedback and success stories from students, educators, and professionals across the InnoVate Connecta ecosystem.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w400,
                                      color: subtitleColor,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Rating Summary Box
                                  if (_viewModel.allTestimonials.isNotEmpty)
                                    _buildRatingSummaryCard(),

                                  const SizedBox(height: 16),

                                  // Filter Pills
                                  if (_viewModel.allTestimonials.isNotEmpty)
                                    _buildFilterChips(),
                                ],
                              ),
                            ),
                          ),

                          // Dynamic Content Area
                          _buildContentSliver(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.showBottomNav
            ? const AboutBottomNavBar(selectedIndex: 2)
            : null,
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: topBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back button
          const AppBackButton(
            size: 38,
            borderRadius: 10,
            iconSize: 16,
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              'Testimonials',
              style: GoogleFonts.inter(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // Refresh button
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: 20,
            ),
            tooltip: 'Refresh',
            onPressed: () => _viewModel.fetchTestimonials(isRefresh: true),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummaryCard() {
    final avg = _viewModel.averageRating;
    final total = _viewModel.allTestimonials.length;
    final verified = _viewModel.verifiedCount;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F172A),
            brandPurple.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Row(
        children: [
          // Big rating score
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ 5.0',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  );
                }),
              ),
            ],
          ),

          const Spacer(),

          // Divider
          Container(height: 48, width: 1, color: const Color(0xFF1E293B)),

          const Spacer(),

          // Badges column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.rate_review_rounded,
                    color: brandPurple,
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$total Reviews',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF38BDF8),
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$verified 100% Verified',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final current = _viewModel.ratingFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip(
            label: 'All Reviews (${_viewModel.allTestimonials.length})',
            isSelected: current == 0,
            onTap: () => _viewModel.setRatingFilter(0),
          ),
          const SizedBox(width: 10),
          _buildChip(
            label: '★ 5 Stars Only',
            isSelected: current == 5,
            onTap: () => _viewModel.setRatingFilter(5),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? brandPurple.withValues(alpha: 0.18)
              : const Color(0xFF131B2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? brandPurple : const Color(0xFF1E293B),
            width: 1.1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? brandPurple : subtitleColor,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    if (_viewModel.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 2.8,
                  color: brandPurple,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Loading testimonials...',
                style: TextStyle(color: subtitleColor, fontSize: 13.5),
              ),
            ],
          ),
        ),
      );
    }

    if (_viewModel.errorMessage != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFF43F5E),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load testimonials',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _viewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13, color: subtitleColor),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _viewModel.fetchTestimonials(),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final items = _viewModel.testimonials;

    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.reviews_outlined,
                color: subtitleColor,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                'No testimonials available',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Check back soon for new community reviews.',
                style: GoogleFonts.inter(fontSize: 13, color: subtitleColor),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final testimonial = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TestimonialCard(testimonial: testimonial),
          );
        }, childCount: items.length),
      ),
    );
  }
}
