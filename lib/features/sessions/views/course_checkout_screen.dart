import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_session_service.dart';
import '../../../core/services/purchased_sessions_service.dart';
import '../models/recorded_session_model.dart';
import 'course_payment_success_screen.dart';

class CourseCheckoutScreen extends StatefulWidget {
  final RecordedSessionModel session;

  const CourseCheckoutScreen({
    super.key,
    required this.session,
  });

  @override
  State<CourseCheckoutScreen> createState() => _CourseCheckoutScreenState();
}

class _CourseCheckoutScreenState extends State<CourseCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color inputBg = Color(0xFF0F172A);
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color cyanText = Color(0xFF38BDF8);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color subtitleColor = Color(0xFF94A3B8);

  final List<String> _banks = [
    'HDFC Bank',
    'State Bank of India',
    'ICICI Bank',
    'Axis Bank',
    'Kotak Mahindra Bank',
    'Punjab National Bank',
  ];
  String _selectedBank = 'HDFC Bank';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final authUser = AuthSessionService.instance.user;
    final storedEmail = AuthSessionService.instance.userEmail;
    _nameController = TextEditingController(
      text: (authUser != null && authUser.name.trim().isNotEmpty)
          ? authUser.name.trim()
          : 'Test Student',
    );
    _emailController = TextEditingController(
      text: (authUser != null && authUser.email.trim().isNotEmpty)
          ? authUser.email.trim()
          : (storedEmail != null && storedEmail.trim().isNotEmpty)
              ? storedEmail.trim()
              : 'livesession@gmail.com',
    );
    _phoneController = TextEditingController(
      text: (authUser != null && authUser.phone != null && authUser.phone!.trim().isNotEmpty)
          ? authUser.phone!.trim()
          : '8787546968',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _cleanPayablePrice {
    final raw = widget.session.discountPrice.trim();
    if (raw.isEmpty) return '₹3999';
    return raw;
  }

  String get _cleanOriginalPrice {
    final raw = widget.session.originalPrice.trim();
    if (raw.isEmpty) return '₹4,999';
    return raw;
  }

  void _handlePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate safe encrypted gateway transit
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    final studentName = _nameController.text.trim();
    final studentEmail = _emailController.text.trim();
    final studentPhone = _phoneController.text.trim();

    // Record persistent purchase
    await PurchasedSessionsService.instance.recordPurchase(
      session: widget.session,
      studentName: studentName,
      studentEmail: studentEmail,
      studentPhone: studentPhone,
      bankName: _selectedBank,
      totalPaid: _cleanPayablePrice,
    );

    // Navigate to Payment Confirmed Screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CoursePaymentSuccessScreen(
          session: widget.session.copyWith(isEnrolled: true),
          studentName: studentName,
          studentEmail: studentEmail,
          studentPhone: studentPhone,
          bankName: _selectedBank,
          totalPaid: _cleanPayablePrice,
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
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildTopAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _buildOrderSummaryCard(),
                        const SizedBox(height: 20),
                        _buildStudentContactCard(),
                        const SizedBox(height: 20),
                        _buildPaymentOptionCard(),
                        const SizedBox(height: 120), // Spacing for sticky bottom button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomPayButton(),
      ),
    );
  }

  /// Top App Bar matching Image 1: '<  Secure Checkout   [100% Encrypted]'
  Widget _buildTopAppBar() {
    return Container(
      color: darkCanvas,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38,
              height: 38,
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

          // Title
          Text(
            'Secure Checkout',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),

          // 100% Encrypted Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF064E3B).withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: emeraldGreen.withValues(alpha: 0.55),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_rounded,
                  color: emeraldGreen,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  '100% Encrypted',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: emeraldGreen,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Order Summary Card matching Image 1
  Widget _buildOrderSummaryCard() {
    final hasThumb = widget.session.thumbnailUrl != null &&
        widget.session.thumbnailUrl!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          // Thumbnail Banner Image
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF22304A), width: 1.0),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: hasThumb
                  ? Image.network(
                      widget.session.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildThumbnailFallback(),
                    )
                  : _buildThumbnailFallback(),
            ),
          ),
          const SizedBox(height: 14),

          // Course Title
          Text(
            widget.session.title,
            style: GoogleFonts.inter(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Meta Info: 14 Hours • 18 Lessons
          Row(
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: cyanText,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                widget.session.duration,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cyanText,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '•',
                style: TextStyle(color: Color(0xFF475569), fontSize: 13),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.book_rounded,
                color: cyanText,
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                widget.session.lessons,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cyanText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 14),

          // Price Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Regular Price:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              Text(
                _cleanOriginalPrice,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Masterclass Fee:',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: subtitleColor,
                ),
              ),
              Text(
                _cleanPayablePrice,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF1E293B), height: 1),
          const SizedBox(height: 14),

          // Total Payable Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Total Payable:',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                _cleanPayablePrice,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: cyanText,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Security reassurance pill
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: emeraldGreen,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  '100% Secure Checkout • Instant Video Access',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6EE7B7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailFallback() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: brandPurple.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: brandPurple.withValues(alpha: 0.5)),
            ),
            child: Text(
              widget.session.categoryName.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFC084FC),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Step 1: Student Contact Information Card matching Image 1
  Widget _buildStudentContactCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1 Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: brandPurple,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Student Contact Information',
                style: GoogleFonts.inter(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Full Name
          _buildFieldLabel('Full Name'),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: _nameController,
            hint: 'Enter your full name',
            keyboardType: TextInputType.name,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
          ),
          const SizedBox(height: 16),

          // Email Address
          _buildFieldLabel('Email Address'),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: _emailController,
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter email';
              if (!v.contains('@') || !v.contains('.')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone Number
          _buildFieldLabel('Phone Number'),
          const SizedBox(height: 8),
          _buildTextInput(
            controller: _phoneController,
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter phone number' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE2E8F0),
          ),
        ),
        const SizedBox(width: 3),
        const Text(
          '*',
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 13,
          color: const Color(0xFF475569),
        ),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandPurple, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.4),
        ),
      ),
    );
  }

  /// Step 2: Payment Option Card matching Image 1
  Widget _buildPaymentOptionCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1.2),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 2 Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: brandPurple,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Payment Option',
                style: GoogleFonts.inter(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Online Net Banking Card with Selected Badge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2E3D5B), width: 1.1),
            ),
            child: Row(
              children: [
                // Purple Bank Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: brandPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Online Net Banking',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Instant & Secure Bank Transfer',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selected Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF064E3B).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: emeraldGreen.withValues(alpha: 0.7),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        color: emeraldGreen,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Selected',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Bank Dropdown
          _buildFieldLabel('Choose Your Bank'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardBorder, width: 1.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBank,
                isExpanded: true,
                dropdownColor: const Color(0xFF131B2E),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF94A3B8),
                ),
                items: _banks.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(
                      bank,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newBank) {
                  if (newBank != null) {
                    setState(() {
                      _selectedBank = newBank;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Encrypted note
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.lock_rounded,
                  color: emeraldGreen,
                  size: 13,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "You will be safely routed to your bank's encrypted payment gateway.",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bottom Sticky Action Button matching Image 1
  Widget _buildBottomPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        border: const Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: brandPurple.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pay $_cleanPayablePrice & Unlock Masterclass',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Terms Disclaimer
            Text(
              'By enrolling, you agree to our Terms and Privacy Policy.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

