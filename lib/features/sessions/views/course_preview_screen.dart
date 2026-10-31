import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/purchased_sessions_service.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/recorded_session_model.dart';
import '../repository/sessions_repository.dart';
import 'course_checkout_screen.dart';

class CoursePreviewScreen extends StatefulWidget {
  final RecordedSessionModel? session;
  final String? slug;
  final int? courseId;
  final SessionsRepository? repository;
  final bool autoFetchDetails;

  const CoursePreviewScreen({
    super.key,
    this.session,
    this.slug,
    this.courseId,
    this.repository,
    this.autoFetchDetails = true,
  });

  @override
  State<CoursePreviewScreen> createState() => _CoursePreviewScreenState();
}

class _CoursePreviewScreenState extends State<CoursePreviewScreen> {
  int _selectedTabIndex = 0;
  late RecordedSessionModel _session;
  late final SessionsRepository _repository;
  bool _ownsRepository = false;
  bool _isEnrolled = false;
  bool _isLoading = false;
  String? _errorMessage;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandOrange = Color(0xFFF59E0B);
  static const Color cyanText = Color(0xFF38BDF8);
  static const Color subtitleColor = Color(0xFF94A3B8);

  RecordedSessionModel _getDefaultFallbackSession() {
    return RecordedSessionModel(
      id: widget.courseId ?? 12,
      title: 'System Design & Scalable Architecture',
      slug: widget.slug ?? 'system-design-scalable-architecture',
      categoryName: 'System Design',
      heading:
          'Learn to design scalable, reliable and production-ready software systems with real-world case studies.',
      duration: '14 Hours',
      lessons: '18 Lessons',
      discountPrice: '₹3,999',
      originalPrice: '₹4,999',
      rating: 4.9,
      courseOverview:
          'Learn the fundamentals of System Design and understand how large-scale software applications are designed and built. This course focuses on practical architecture concepts used in real-world engineering and technical interviews.\n\nYou will learn scalability, load balancing, caching, databases, APIs, message queues, microservices, database sharding, replication and fault tolerance. You will also design popular systems such as URL Shortener, Chat Application and Ride Booking System.',
      whatYouWillLearn:
          'Understand Low-Level Design and High-Level Design<br>Learn scalability and distributed system concepts<br>Design REST APIs and scalable backend services<br>Understand load balancing and caching<br>Learn database indexing, replication and sharding<br>Understand SQL vs NoSQL databases<br>Learn message queues and event-driven architecture<br>Understand microservices and monolithic architecture<br>Design systems like URL Shortener and Chat Application<br>Prepare for System Design interviews',
      instructorName: 'Kaif Alam',
      instructorDesignation: 'Full Stack Web Development Instructor',
      instructorExperience: '3+ Years Industry Experience in Web Development',
      instructorBio:
          'Full Stack Developer and mentor specializing in React, Node.js, Express.js, MongoDB, and modern web application development. Experienced in teaching practical, project-based development and scalable distributed architectures.',
      thumbnailUrl:
          'https://awsdemo.co.in/innovateconnect/storage/recorded-sessions/3R86FVyZDrOPCIRfmjSsSiRachdHTIp5omVZHu67.jpg',
      previewVideoUrl: 'https://youtu.be/ZGUrJK8Lgbo?si=T9NskkNtV1qeUh15',
    );
  }

  @override
  void initState() {
    super.initState();
    _session = widget.session ?? _getDefaultFallbackSession();

    final initialSlugOrId = widget.slug ??
        _session.slug ??
        (widget.courseId != null ? '${widget.courseId}' : '${_session.id}');
    final isPurchasedLocally =
        PurchasedSessionsService.instance.isPurchased(initialSlugOrId);
    _isEnrolled = widget.session?.isEnrolled == true ||
        _session.isEnrolled ||
        isPurchasedLocally;
    if (_isEnrolled) {
      _session = _session.copyWith(isEnrolled: true);
    }

    if (widget.repository != null) {
      _repository = widget.repository!;
    } else {
      _repository = SessionsRepository();
      _ownsRepository = true;
    }

    if (widget.autoFetchDetails) {
      _loadFreshDetails();
    }
  }

  Future<void> _loadFreshDetails() async {
    String? targetSlug = widget.slug ?? _session.slug;
    final targetId = widget.courseId ?? _session.id;

    if (targetSlug == null || targetSlug.trim().isEmpty) {
      final title = _session.title.toLowerCase();
      if (title.contains('system') && title.contains('design')) {
        targetSlug = 'system-design-scalable-architecture';
      }
    }

    if (widget.session == null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final fresh = await _repository.fetchRecordedSessionDetails(
        slug: targetSlug,
        id: targetId,
      );

      if (fresh != null && mounted) {
        final slugOrId = fresh.slug ??
            (widget.slug ??
                (targetSlug ?? '${fresh.id}'));
        final isPurchased =
            PurchasedSessionsService.instance.isPurchased(slugOrId) ||
                widget.session?.isEnrolled == true ||
                fresh.isEnrolled;

        setState(() {
          _session = fresh.copyWith(isEnrolled: isPurchased);
          _isEnrolled = isPurchased;
          _isLoading = false;
          _errorMessage = null;
        });
        return;
      }
    } catch (e) {
      if (mounted && widget.session == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load course details. Please try again.';
        });
        return;
      }
    }

    if (mounted && _isLoading) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (_ownsRepository) {
      _repository.dispose();
    }
    super.dispose();
  }

  void _handleShare() {
    final link =
        'https://awsdemo.co.in/innovateconnect/recorded-sessions/${_session.slug ?? _session.id}';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Course link copied to clipboard!',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleWatchPreview() {
    final videoUrl = _session.previewVideoUrl;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
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
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Course Preview',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _session.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.video_collection_outlined,
                      color: cyanText,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        videoUrl != null && videoUrl.isNotEmpty
                            ? 'Preview Video Stream Ready'
                            : 'Interactive preview available for enrolled learners.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Close Preview',
                  icon: Icons.close_rounded,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEnrollment() {
    if (_isEnrolled) {
      _handleWatchPreview();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseCheckoutScreen(session: _session),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.session == null) {
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
            child: Column(
              children: [
                _buildTopAppBar(),
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: brandPurple),
                        SizedBox(height: 16),
                        Text(
                          'Loading Course Preview...',
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null && widget.session == null) {
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
            child: Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Color(0xFFEF4444),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _loadFreshDetails,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Try Again'),
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
                ),
              ],
            ),
          ),
        ),
      );
    }

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
              _buildTopAppBar(),
              if (_isLoading)
                const LinearProgressIndicator(
                  backgroundColor: darkCanvas,
                  color: brandPurple,
                  minHeight: 2,
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildMediaCard(),
                      const SizedBox(height: 18),
                      _buildCourseHeaderInfo(),
                      const SizedBox(height: 22),
                      _buildTabBar(),
                      const SizedBox(height: 16),
                      _buildTabContent(),
                      const SizedBox(
                        height: 100,
                      ), // Spacing for bottom sticky bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomStickyBar(),
      ),
    );
  }

  /// Top App Bar matching the screenshot
  Widget _buildTopAppBar() {
    return Container(
      color: darkCanvas,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Circular Back Button
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                shape: BoxShape.circle,
                border: Border.all(color: cardBorder, width: 1.1),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

          // Centered Eyebrow & Title
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'INNOVATE CONNECTA',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC084FC),
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Course Preview',
                  style: GoogleFonts.inter(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          // Circular Share Button
          GestureDetector(
            onTap: _handleShare,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                shape: BoxShape.circle,
                border: Border.all(color: cardBorder, width: 1.1),
              ),
              child: const Icon(
                Icons.share_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Top Media Player / Video Thumbnail Banner Card
  Widget _buildMediaCard() {
    final hasThumbnail =
        _session.thumbnailUrl != null &&
        _session.thumbnailUrl!.trim().isNotEmpty;

    return Container(
      height: 205,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image or vibrant Fallback Banner
            if (hasThumbnail) ...[
              Positioned.fill(
                child: Image.network(
                  _session.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackThumbnail(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildFallbackThumbnail();
                  },
                ),
              ),
              // Subtle scrim gradient so image is clearly visible without becoming a black box
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        const Color(0xFF0F172A).withValues(alpha: 0.50),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ] else
              _buildFallbackThumbnail(),

            // Center Glowing Play Button
            Center(
              child: GlowPlayButton(
                size: 56,
                iconSize: 30,
                onTap: _handleWatchPreview,
              ),
            ),

            // Bottom Left Duration & Lessons Pill
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF334155),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: cyanText,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${_session.duration} • ${_session.lessons}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cyanText,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackThumbnail() {
    final catDisplay = _session.categoryName.trim().isNotEmpty
        ? _session.categoryName.toUpperCase()
        : 'MASTERCLASS';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF2E1065), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
              width: 1.2,
            ),
          ),
          child: Text(
            catDisplay,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFC084FC),
              letterSpacing: 1.8,
            ),
          ),
        ),
      ),
    );
  }

  /// Course Header Section: Category pill, Title, Subheading, Meta info, Price, CTA buttons
  Widget _buildCourseHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF28133C),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF581C87), width: 1.0),
          ),
          child: Text(
            _session.categoryName,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFC084FC),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          _session.title,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.25,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 10),

        // Subtitle / Heading
        Text(
          _session.heading ??
              'Learn to design scalable, reliable and production-ready software systems with real-world case studies.',
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: subtitleColor,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),

        // Meta Info Row (Comprehensive & 14 Hours • 18 Lessons)
        Wrap(
          spacing: 14,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: cyanText,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  'Comprehensive',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: cyanText,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_circle_outline_rounded,
                  color: cyanText,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  '${_session.duration} • ${_session.lessons}',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: cyanText,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Price Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _session.discountPrice.isNotEmpty
                  ? _session.discountPrice
                  : '₹3,999',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: brandOrange,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                _session.originalPrice.isNotEmpty
                    ? _session.originalPrice
                    : '₹4,999',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Primary Button: Buy Course & Enroll Now
        SizedBox(
          width: double.infinity,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _handleEnrollment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _isEnrolled
                          ? 'Enrolled • Access Course'
                          : 'Buy Course & Enroll Now',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
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
        ),
        const SizedBox(height: 12),

        // Secondary Button: Watch Preview
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: _handleWatchPreview,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              side: const BorderSide(color: cardBorder, width: 1.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Watch Preview',
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
      ],
    );
  }

  /// Custom Sleek Tab Bar: Course Overview, What You'll Learn, About Instructor
  Widget _buildTabBar() {
    final tabs = ['Course Overview', "What You'll Learn", 'About Instructor'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1.0),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 12, left: 2, right: 2),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? brandPurple : Colors.transparent,
                      width: 2.2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : subtitleColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Dynamic Tab Content depending on selected tab
  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 1:
        return _buildWhatYouWillLearnTab();
      case 2:
        return _buildAboutInstructorTab();
      case 0:
      default:
        return _buildCourseOverviewTab();
    }
  }

  /// Tab 1: Course Overview (About this masterclass + Pricing/Instructor Card)
  Widget _buildCourseOverviewTab() {
    final overviewText =
        _session.courseOverview ??
        'Learn the fundamentals of System Design and understand how large-scale software applications are designed and built. This course focuses on practical architecture concepts used in real-world engineering and technical interviews.\n\nYou will learn scalability, load balancing, caching, databases, APIs, message queues, microservices, database sharding, replication and fault tolerance. You will also design popular systems such as URL Shortener, Chat Application and Ride Booking System.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: About This Masterclass
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorder, width: 1.1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About This Masterclass',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                overviewText,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFCBD5E1),
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Card 2: Pricing, Instant Access & Instructor Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorder, width: 1.1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badges Row: INSTANT ACCESS & Secure 256-bit
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: brandOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'INSTANT ACCESS',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF10B981),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Secure 256-bit',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Large Price & Strikethrough
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _session.discountPrice.isNotEmpty
                        ? _session.discountPrice
                        : '₹3,999',
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      _session.originalPrice.isNotEmpty
                          ? _session.originalPrice
                          : '₹4,999',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'One-time payment • Lifetime unlimited video access',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 18),

              // Button: Buy Course & Enroll Now
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    onPressed: _handleEnrollment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Buy Course & Enroll Now',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
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
              ),
              const SizedBox(height: 18),

              // Instructor Tile
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B101C),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cardBorder, width: 1.0),
                ),
                child: Row(
                  children: [
                    // Instructor Avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: brandPurple.withValues(alpha: 0.6),
                          width: 1.2,
                        ),
                      ),
                      child: ClipOval(
                        child:
                            _session.instructorImageUrl != null &&
                                _session.instructorImageUrl!.isNotEmpty
                            ? Image.network(
                                _session.instructorImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildAvatarFallback(),
                              )
                            : _buildAvatarFallback(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _session.instructorName ?? 'Kaif Alam',
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _session.instructorDesignation ??
                                'Full Stack Web Development Instructor',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: subtitleColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Share This Course Row
              Text(
                'Share This Course',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildSocialShareIcon(Icons.facebook_rounded, _handleShare),
                  const SizedBox(width: 12),
                  _buildSocialShareIcon(Icons.close_rounded, _handleShare), // X
                  const SizedBox(width: 12),
                  _buildSocialShareIcon(
                    Icons.business_center_rounded,
                    _handleShare,
                  ), // LinkedIn
                  const SizedBox(width: 12),
                  _buildSocialShareIcon(
                    Icons.chat_bubble_outline_rounded,
                    _handleShare,
                  ), // WhatsApp
                  const SizedBox(width: 12),
                  _buildSocialShareIcon(
                    Icons.link_rounded,
                    _handleShare,
                  ), // Copy Link
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Tab 2: What You'll Learn
  Widget _buildWhatYouWillLearnTab() {
    final points = _session.learningPoints;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 1.1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "What You'll Learn",
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_rounded,
                      color: Color(0xFF10B981),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFCBD5E1),
                        height: 1.45,
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

  /// Tab 3: About Instructor
  Widget _buildAboutInstructorTab() {
    final instName = _session.instructorName ?? 'Kaif Alam';
    final instDesig =
        _session.instructorDesignation ??
        'Full Stack Web Development Instructor';
    final instExp =
        _session.instructorExperience ??
        '3+ Years Industry Experience in Web Development';
    final instBio =
        _session.instructorBio ??
        'Full Stack Developer and mentor specializing in React, Node.js, Express.js, MongoDB, and modern web application development. Experienced in teaching practical, project-based development and scalable distributed architectures.';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder, width: 1.1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: brandPurple, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: brandPurple.withValues(alpha: 0.25),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child:
                      _session.instructorImageUrl != null &&
                          _session.instructorImageUrl!.isNotEmpty
                      ? Image.network(
                          _session.instructorImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildAvatarFallback(),
                        )
                      : _buildAvatarFallback(),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            instName,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF38BDF8),
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      instDesig,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131B2E),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cardBorder),
                      ),
                      child: Text(
                        instExp,
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
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Instructor Biography',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            instBio,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFCBD5E1),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    final initials =
        (_session.instructorName != null && _session.instructorName!.isNotEmpty)
        ? _session.instructorName!
              .trim()
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
        : 'KA';

    return Container(
      color: const Color(0xFF1E1B4B),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFC084FC),
        ),
      ),
    );
  }

  Widget _buildSocialShareIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF0B101C),
          shape: BoxShape.circle,
          border: Border.all(color: cardBorder, width: 1.1),
        ),
        child: Icon(icon, size: 16, color: subtitleColor),
      ),
    );
  }

  /// Sticky Bottom Floating Bar matching screenshot
  Widget _buildBottomStickyBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        border: const Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Column: Total Price + Numbers
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PRICE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          _session.discountPrice.isNotEmpty
                              ? _session.discountPrice
                              : '₹3,999',
                          style: GoogleFonts.inter(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          _session.originalPrice.isNotEmpty
                              ? _session.originalPrice
                              : '₹4,999',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            decoration: TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Right Button: Enroll Now
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _handleEnrollment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  // Override any app-wide infinite minimum button width.
                  // This button is a non-flex child of a Row, so its minimum
                  // width must remain finite.
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isEnrolled ? 'Enrolled' : 'Enroll Now',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
