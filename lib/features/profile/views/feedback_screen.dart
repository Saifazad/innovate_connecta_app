import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/feedback_view_model.dart';
import '../widgets/feedback/recommendation_radio_group.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final FeedbackViewModel _viewModel;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _takeawayController = TextEditingController();
  final TextEditingController _suggestionsController = TextEditingController();

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color fieldBg = Color(0xFF0B101D);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _viewModel = FeedbackViewModel();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _takeawayController.dispose();
    _suggestionsController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitFeedback() async {
    FocusScope.of(context).unfocus();

    final success = await _viewModel.submitFeedback(
      name: _nameController.text,
      email: _emailController.text,
      keyTakeaway: _takeawayController.text,
      suggestions: _suggestionsController.text,
    );

    if (!mounted) return;

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _takeawayController.clear();
      _suggestionsController.clear();

      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: cardBorder, width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF10B981),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Feedback Received!',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _viewModel.successMessage ??
                      'Thank you for your valuable feedback! We appreciate your insights.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
          child: Column(
            children: [
              _buildTopAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Title
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Why Your ',
                                  style: GoogleFonts.inter(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Feedback',
                                  style: GoogleFonts.inter(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: brandPurple,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                TextSpan(
                                  text: '\nMatters',
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
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'At Innovate Connecta, every single feedback form is reviewed by our core curriculum committee to ensure our modules remain updated with current corporate hiring trends.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: textMuted,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form Card
                          Container(
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: cardBorder, width: 1.1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card Title Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: brandOrange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Session & Program Feedback',
                                            style: GoogleFonts.inter(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Please take 2 minutes to help us understand your learning journey.',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: textMuted,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Row 1: Full Name * & Email Address *
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildInputBox(
                                        label: 'Full Name *',
                                        hint: 'e.g. Siddharth Verma',
                                        controller: _nameController,
                                        errorText: _viewModel.fieldErrors['name'],
                                        onChanged: (_) =>
                                            _viewModel.clearFieldError('name'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInputBox(
                                        label: 'Email Address *',
                                        hint: 'siddharth@example.com',
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        errorText: _viewModel.fieldErrors['email'],
                                        onChanged: (_) =>
                                            _viewModel.clearFieldError('email'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Row 2: Which Session / Workshop did you attend? *
                                Text(
                                  'Which Session /Workshop did you attend? *',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: _viewModel.fieldErrors.containsKey('session_name')
                                        ? const Color(0xFFEF4444)
                                        : textMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: fieldBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _viewModel.fieldErrors.containsKey('session_name')
                                          ? const Color(0xFFEF4444)
                                          : cardBorder,
                                      width: 1.1,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _viewModel.selectedSession,
                                      hint: Text(
                                        'Select program attended',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFF94A3B8),
                                      ),
                                      dropdownColor: const Color(0xFF0F172A),
                                      isExpanded: true,
                                      items: FeedbackViewModel.availableSessions.map((s) {
                                        return DropdownMenuItem<String>(
                                          value: s,
                                          child: Text(
                                            s,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) => _viewModel.setSession(val),
                                    ),
                                  ),
                                ),
                                if (_viewModel.fieldErrors.containsKey('session_name')) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _viewModel.fieldErrors['session_name']!,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),

                                // Row 3: What was your key learning takeaway? *
                                Stack(
                                  children: [
                                    _buildInputBox(
                                      label: 'What was your key learning takeaway? *',
                                      hint: '',
                                      controller: _takeawayController,
                                      minLines: 3,
                                      maxLines: 4,
                                      errorText: _viewModel.fieldErrors['key_takeaway'],
                                      onChanged: (_) =>
                                          _viewModel.clearFieldError('key_takeaway'),
                                    ),
                                    if (_viewModel.fieldErrors.containsKey('key_takeaway'))
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'Please fill in this field.',
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Row 4: Suggestions for improvement
                                _buildInputBox(
                                  label: 'Suggestions for improvement',
                                  hint: '',
                                  controller: _suggestionsController,
                                  minLines: 3,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 18),

                                // Row 5: Recommendation Radio Group
                                RecommendationRadioGroup(
                                  selectedValue: _viewModel.selectedRecommendation,
                                  onChanged: (val) => _viewModel.setRecommendation(val),
                                ),
                                const SizedBox(height: 22),

                                // Submit Feedback Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF2563EB), Color(0xFFA855F7)],
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
                                      onPressed: _viewModel.isSubmitting
                                          ? null
                                          : _handleSubmitFeedback,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: _viewModel.isSubmitting
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Submit Feedback →',
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
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

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
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
                size: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Feedback',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildInputBox({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: hasError ? const Color(0xFFEF4444) : textMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 13.5,
              color: const Color(0xFF475569),
            ),
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? const Color(0xFFEF4444) : cardBorder,
                width: 1.1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: brandPurple,
                width: 1.3,
              ),
            ),
          ),
        ),
        if (hasError && minLines == 1) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ],
    );
  }
}
