import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/contact_view_model.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../widgets/contact_dropdown_field.dart';
import '../../../shared/widgets/app_info_tile.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late final ContactViewModel _viewModel;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color subtitleColor = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _viewModel = ContactViewModel();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleFormSubmit() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final success = await _viewModel.submitForm(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      message: _messageController.text,
    );

    if (!mounted) return;

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();

      _showSuccessDialog(_viewModel.successMessage ??
          'Thank you for reaching out! An advisor will get back to you within 24 hours.');
    } else if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E293B), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF10B981),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Message Sent!',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: subtitleColor,
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
                    'Great',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFormCard(),
                          const SizedBox(height: 16),
                          _buildContactInfoCards(),
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

  /// Top App Bar matching the screenshot
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Left Back Button
          GestureDetector(
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
                border: Border.all(
                  color: const Color(0xFF1E293B),
                  width: 1.1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),

          // Centered Title: Contact Us
          Expanded(
            child: Text(
              'Contact Us',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // Right Spacer to maintain exact center alignment
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  /// Main Card: Send Us a Message Form
  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + "Send Us a Message"
          Row(
            children: [
              Transform.rotate(
                angle: -0.2,
                child: const Icon(
                  Icons.near_me_rounded,
                  color: brandOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Send Us a Message',
                style: GoogleFonts.inter(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            'Fill out the form below and an advisor will get back to you within 24 hours.',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          // Row 1: Full Name * & Email Address *
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Full Name *',
                  hint: 'e.g. Vikram Sharma',
                  controller: _nameController,
                  errorText: _viewModel.fieldErrors['name'],
                  onChanged: (_) => _viewModel.clearFieldError('name'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: 'Email Address *',
                  hint: 'vikram@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _viewModel.fieldErrors['email'],
                  onChanged: (_) => _viewModel.clearFieldError('email'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 2: Phone Number * & Inquiry Subject *
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Phone Number *',
                  hint: '+91 9810660607',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: _viewModel.fieldErrors['phone'],
                  onChanged: (_) => _viewModel.clearFieldError('phone'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ContactDropdownField(
                  label: 'Inquiry Subject *',
                  hint: 'Select topic',
                  value: _viewModel.selectedSubject,
                  items: ContactViewModel.subjects,
                  errorText: _viewModel.fieldErrors['subject'],
                  onChanged: (val) => _viewModel.setSubject(val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 3: Your Message *
          AppTextField(
            label: 'Your Message *',
            hint: 'Tell us how we can help you...',
            controller: _messageController,
            minLines: 4,
            maxLines: 5,
            errorText: _viewModel.fieldErrors['message'],
            onChanged: (_) => _viewModel.clearFieldError('message'),
          ),
          const SizedBox(height: 22),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [brandIndigo, brandPurple],
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
                onPressed: _viewModel.isSubmitting ? null : _handleFormSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Send Message Now →',
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
    );
  }

  /// Contact Info Cards below the form (Email Us & Call / WhatsApp)
  Widget _buildContactInfoCards() {
    return Column(
      children: [
        AppInfoTile.card(
          icon: Icons.mail_outline_rounded,
          iconColor: const Color(0xFFFB923C),
          iconBgColor: const Color(0xFF241814),
          iconBorderColor: const Color(0xFFEA580C).withValues(alpha: 0.35),
          label: 'Email Us',
          value: 'admin@innovateconnecta.com',
        ),
        const SizedBox(height: 12),
        AppInfoTile.card(
          icon: Icons.call_rounded,
          iconColor: const Color(0xFF818CF8),
          iconBgColor: const Color(0xFF131D33),
          iconBorderColor: const Color(0xFF6366F1).withValues(alpha: 0.35),
          label: 'Call / WhatsApp',
          value: '+91 9810660607',
        ),
      ],
    );
  }
}
