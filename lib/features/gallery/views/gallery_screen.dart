import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/gallery_view_model.dart';
import '../widgets/gallery_card.dart';
import '../widgets/gallery_detail_dialog.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../../app/main_navigation_screen.dart';

class GalleryScreen extends StatefulWidget {
  final bool showBottomNav;

  const GalleryScreen({super.key, this.showBottomNav = false});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final GalleryViewModel _viewModel;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color topBarColor = Color(0xFF0A0F1D);
  static const Color goldAccent = Color(0xFFF59E0B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color subtitleColor = Color(0xFF94A3B8);
  static const Color chipBorder = Color(0xFF1E293B);
  static const Color chipBg = Color(0xFF131B2E);

  @override
  void initState() {
    super.initState();
    _viewModel = GalleryViewModel();
    _viewModel.fetchGalleries();
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
                          _viewModel.fetchGalleries(isRefresh: true),
                      child: Stack(
                        children: [
                          // Atmospheric background ambient glow (top-right purple mesh)
                          Positioned(
                            top: -40,
                            right: -60,
                            child: Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    brandPurple.withValues(alpha: 0.18),
                                    brandIndigo.withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),

                          CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            slivers: [
                              // Hero Title & Subtitle Section
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 16, 16, 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Event ',
                                              style: GoogleFonts.inter(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                letterSpacing: -0.4,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Gallery',
                                              style: GoogleFonts.inter(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w800,
                                                color: brandPurple,
                                                letterSpacing: -0.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Highlights and memorable moments from our masterclasses, campus drives, and corporate workshops.',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                          color: subtitleColor,
                                          height: 1.45,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),

                              // Filter Pills Row
                              SliverToBoxAdapter(
                                child: _buildFilterChips(),
                              ),

                              const SliverToBoxAdapter(
                                child: SizedBox(height: 18),
                              ),

                              // Main Gallery Grid or State View
                              _buildGalleryContent(),

                              const SliverToBoxAdapter(
                                child: SizedBox(height: 24),
                              ),
                            ],
                          ),
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
            ? AboutBottomNavBar(
                selectedIndex: -1,
                centerLabel: 'Dashboard',
                onItemTapped: (index) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => MainNavigationScreen(initialIndex: index),
                    ),
                    (route) => false,
                  );
                },
              )
            : null,
      ),
    );
  }

  /// Top App Bar matching the screenshot design
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: topBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered GALLERY title
          Center(
            child: Text(
              'GALLERY',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: goldAccent,
                letterSpacing: 2.8,
              ),
            ),
          ),

          // Left Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF131B2E),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF1E293B), width: 1.1),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Horizontal scrolling category filter chips
  Widget _buildFilterChips() {
    final categories = _viewModel.categories;
    final selectedId = _viewModel.selectedCategoryId;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // "All Photos" Chip
          _buildChip(
            label: 'All Photos',
            isSelected: selectedId == null || selectedId == 0,
            onTap: () => _viewModel.selectCategory(null),
          ),
          const SizedBox(width: 8),

          // Dynamic Category Chips
          ...categories.map((cat) {
            final isSelected = selectedId == cat.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
                label: cat.name,
                isSelected: isSelected,
                onTap: () => _viewModel.selectCategory(cat.id),
              ),
            );
          }),
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
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : chipBg,
          border: Border.all(
            color: isSelected ? Colors.transparent : chipBorder,
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brandPurple.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : subtitleColor,
          ),
        ),
      ),
    );
  }

  /// Builds the 2-column gallery grid or loading/error placeholders
  Widget _buildGalleryContent() {
    if (_viewModel.isLoading && _viewModel.rawGalleries.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    valueColor: AlwaysStoppedAnimation<Color>(brandPurple),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading event gallery...',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final items = _viewModel.displayedGalleries;

    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: chipBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: chipBorder),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: subtitleColor,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _viewModel.errorMessage ?? 'No photos found in this category',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _viewModel.fetchGalleries(isRefresh: true),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Reload Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.73,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return GalleryCard(
              item: item,
              onTap: () => GalleryDetailDialog.show(context, item),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
