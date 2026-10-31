import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'login_screen.dart';
import '../models/auth_token.dart';
import '../models/auth_user.dart';
import '../../../core/services/auth_session_service.dart';
import '../repository/auth_repository.dart';
import '../../../app/main_navigation_screen.dart';
import '../../profile/view_models/profile_view_model.dart';
import '../../../shared/widgets/brand_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedCategory = 'College Student';
  String? _attachedResumeName;
  String? _attachedResumePath;
  List<int>? _attachedResumeBytes;

  static const List<String> _categories = [
    'College Student',
    'Recent Graduate',
    'Working Professional',
    'Researcher / Academician',
    'Other',
  ];

  static const Color darkCanvas = Color(0xFF0A0F1D);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color primaryPurple = Color(0xFF635BFF);
  static const Color fieldBackground = Color(0xFF0F172A);
  static const Color subtitleColor = Color(0xFF94A3B8);
  static const Color labelColor = Color(0xFFCBD5E1);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _authRepository.dispose();
    super.dispose();
  }

  Future<void> _onAttachResume() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (file != null) {

        // Verify PDF extension safety
        if (file.extension?.toLowerCase() != 'pdf') {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a valid PDF file.'),
              backgroundColor: Color(0xFFF43F5E),
            ),
          );
          return;
        }

        final fileSize = (await file.length()) ?? 0;

        // Max 10MB constraint (10 * 1024 * 1024 bytes)
        if (fileSize > 10 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File exceeds 10MB limit. Please choose a smaller PDF.'),
              backgroundColor: Color(0xFFF43F5E),
            ),
          );
          return;
        }

        final double sizeInMb = fileSize / (1024 * 1024);
        final String sizeStr = sizeInMb >= 1.0
            ? '${sizeInMb.toStringAsFixed(1)} MB'
            : '${(fileSize / 1024).toStringAsFixed(0)} KB';

        final fileBytes = await file.readAsBytes();

        setState(() {
          _attachedResumeName = '${file.name} ($sizeStr)';
          _attachedResumePath = file.path;
          _attachedResumeBytes = fileBytes;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not pick resume: $e'),
          backgroundColor: const Color(0xFFF43F5E),
        ),
      );
    }
  }

  void _onRemoveResume() {
    setState(() {
      _attachedResumeName = null;
      _attachedResumePath = null;
      _attachedResumeBytes = null;
    });
  }

  Future<void> _onCreateAccount() async {
    if (_isLoading) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name.'),
          backgroundColor: Color(0xFFF43F5E),
        ),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address.'),
          backgroundColor: Color(0xFFF43F5E),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please create a password.'),
          backgroundColor: Color(0xFFF43F5E),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        phone: phone.isNotEmpty ? phone : null,
        field: _selectedCategory,
        password: password,
        resumePath: _attachedResumePath,
        resumeBytes: _attachedResumeBytes,
        resumeFileName: _attachedResumeName?.split(' (').first,
      );

      if (!mounted) return;

      if (response.status) {
        final token = response.token ??
            AuthToken(
              tokenType: 'Bearer',
              token: 'auth_reg_${DateTime.now().millisecondsSinceEpoch}',
              expiresIn: 86400 * 30,
            );
        final user = response.user ??
            AuthUser(
              id: 1,
              name: name,
              email: email,
              phone: phone.isNotEmpty ? phone : null,
              field: _selectedCategory,
            );
        await AuthSessionService.instance.saveSession(
          token: token,
          user: user,
        );

        await ProfileViewModel.instance.onUserRegistered(
          name: name,
          email: email,
          phone: phone.isNotEmpty ? phone : null,
          field: _selectedCategory,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isNotEmpty
                  ? response.message
                  : 'Account created successfully!',
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const MainNavigationScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.firstErrorMessage),
            backgroundColor: const Color(0xFFF43F5E),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                if (Navigator.of(context).canPop()) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 16),
                ],

                // --- 1. Brand Logo & Title Row ---
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/icon/app_icon_raw.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const BrandLogo(fontSize: 18.5),
                  ],
                ),
                const SizedBox(height: 36),

                // --- 2. Screen Headings ---
                Text(
                  'Create Account',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Join our professional community',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: subtitleColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 28),

                // --- 3. Full Name * ---
                AppTextField(
                  label: 'Full Name',
                  isRequired: true,
                  hintText: 'e.g. Rahul Sharma',
                  controller: _nameController,
                ),
                const SizedBox(height: 18),

                // --- 4. Email Address * ---
                AppTextField(
                  label: 'Email Address',
                  isRequired: true,
                  hintText: 'apitest@gmail.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),

                // --- 5. Phone Number * ---
                AppTextField(
                  label: 'Phone Number',
                  isRequired: true,
                  hintText: 'e.g. +919876543210',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 18),

                // --- 6. Select Your Field / Category * (Dropdown) ---
                _buildCategoryDropdown(),
                const SizedBox(height: 18),

                // --- 7. Create Password * ---
                AppTextField(
                  label: 'Create Password',
                  isRequired: true,
                  hintText: '•••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // --- 8. Upload Resume / CV (Optional) ---
                _buildResumeUploadBox(),
                const SizedBox(height: 32),

                // --- 9. Create Free Account Button (Vibrant Purple with Glow) ---
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: primaryPurple.withValues(alpha: 0.45),
                        blurRadius: 22,
                        spreadRadius: 1,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onCreateAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create Free Account',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 44),

                // --- 10. Footer Link: "Already have an account? Login" ---
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: subtitleColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Custom Dropdown for Field / Category with blue highlight for selected option
  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with required asterisk
        RichText(
          text: TextSpan(
            text: 'Select Your Field / Category',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Dropdown Container
        Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fieldBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF2563EB).withValues(alpha: 0.8),
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF94A3B8),
                size: 22,
              ),
              selectedItemBuilder: (BuildContext context) {
                return _categories.map((String value) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFF8FAFC),
                      ),
                    ),
                  );
                }).toList();
              },
              items: _categories.map((String value) {
                final bool isSelected = value == _selectedCategory;
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1D4ED8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Custom Upload Resume / CV Box matching the mockup
  Widget _buildResumeUploadBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label Row: Left title & Right constraint text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Resume / CV (Optional)',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
            Text(
              'PDF only • Max 10MB',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Upload attachment container
        GestureDetector(
          onTap: _onAttachResume,
          child: Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: fieldBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _attachedResumeName != null
                    ? brandOrange
                    : const Color(0xFF334155),
                width: 1.2,
              ),
            ),
            child: _attachedResumeName == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Orange Document Upload Badge
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: brandOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: 'Click to attach your Resume / CV (',
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: const Color(0xFFCBD5E1),
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: 'PDF',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(text: ')'),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: brandOrange,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _attachedResumeName!,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFF8FAFC),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _onRemoveResume,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close_rounded,
                            color: Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
