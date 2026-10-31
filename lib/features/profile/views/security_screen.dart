import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/security_view_model.dart';
import '../widgets/security/password_strength_bar.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  late final SecurityViewModel _viewModel;

  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isChangePasswordExpanded = false;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color fieldBg = Color(0xFF0B101D);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _viewModel = SecurityViewModel();
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    FocusScope.of(context).unfocus();

    final success = await _viewModel.updatePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
      confirmPassword: _confirmController.text,
    );

    if (!mounted) return;

    if (success) {
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
      setState(() => _isChangePasswordExpanded = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.successMessage ?? 'Password updated successfully!'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      setState(() => _isChangePasswordExpanded = true);
      if (_viewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.errorMessage!),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
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
                          // Eyebrow
                          Text(
                            'LOGIN & SECURITY',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF94A3B8),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Change Password Card
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
                                // Interactive Dropdown Header: Icon + Title + Subtitle + Animated Chevron
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isChangePasswordExpanded = !_isChangePasswordExpanded;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF261942),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: brandPurple.withValues(alpha: 0.4),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: Color(0xFFC084FC),
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Change Password',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                _isChangePasswordExpanded
                                                    ? 'Enter details to update password'
                                                    : 'Tap to expand & change password',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: _isChangePasswordExpanded ? const Color(0xFFC084FC) : textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedRotation(
                                          turns: _isChangePasswordExpanded ? 0.5 : 0.0,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: _isChangePasswordExpanded
                                                  ? brandPurple.withValues(alpha: 0.2)
                                                  : Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: _isChangePasswordExpanded
                                                  ? const Color(0xFFC084FC)
                                                  : const Color(0xFF64748B),
                                              size: 26,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Expandable Dropdown Form Content
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeInOutCubic,
                                  child: _isChangePasswordExpanded
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 16),
                                            const Divider(color: Color(0xFF1E293B), height: 1),
                                            const SizedBox(height: 20),

                                            // Current Password Field
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Current Password *',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w500,
                                                    color: _viewModel.fieldErrors.containsKey('current')
                                                        ? const Color(0xFFEF4444)
                                                        : textMuted,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Password reset link sent to your registered email.'),
                                                        backgroundColor: Color(0xFF1E293B),
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Forgot password?',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: const Color(0xFFC084FC),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            _buildPasswordField(
                                              controller: _currentController,
                                              hint: 'password123',
                                              prefixIcon: Icons.lock_outline_rounded,
                                              isObscured: _obscureCurrent,
                                              onToggleVisibility: () =>
                                                  setState(() => _obscureCurrent = !_obscureCurrent),
                                              errorText: _viewModel.fieldErrors['current'],
                                              onChanged: (_) => _viewModel.clearFieldError('current'),
                                            ),
                                            const SizedBox(height: 18),

                                            // New Password Field
                                            Text(
                                              'New Password *',
                                              style: GoogleFonts.inter(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                                color: _viewModel.fieldErrors.containsKey('new')
                                                    ? const Color(0xFFEF4444)
                                                    : textMuted,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            _buildPasswordField(
                                              controller: _newController,
                                              hint: 'Minimum 6 characters',
                                              prefixIcon: Icons.key_rounded,
                                              isObscured: _obscureNew,
                                              onToggleVisibility: () =>
                                                  setState(() => _obscureNew = !_obscureNew),
                                              errorText: _viewModel.fieldErrors['new'],
                                              onChanged: (_) {
                                                _viewModel.clearFieldError('new');
                                                setState(() {});
                                              },
                                            ),
                                            const SizedBox(height: 14),

                                            // Password Strength Bar
                                            PasswordStrengthBar(password: _newController.text),
                                            const SizedBox(height: 18),

                                            // Confirm New Password Field
                                            Text(
                                              'Confirm New Password *',
                                              style: GoogleFonts.inter(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                                color: _viewModel.fieldErrors.containsKey('confirm')
                                                    ? const Color(0xFFEF4444)
                                                    : textMuted,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            _buildPasswordField(
                                              controller: _confirmController,
                                              hint: 'Re-enter new password',
                                              prefixIcon: Icons.check_circle_outline_rounded,
                                              isObscured: _obscureConfirm,
                                              onToggleVisibility: () =>
                                                  setState(() => _obscureConfirm = !_obscureConfirm),
                                              errorText: _viewModel.fieldErrors['confirm'],
                                              onChanged: (_) => _viewModel.clearFieldError('confirm'),
                                            ),
                                            const SizedBox(height: 24),

                                            // Update Password Button
                                            SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  gradient: const LinearGradient(
                                                    colors: [brandIndigo, brandPurple],
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
                                                  onPressed: _viewModel.isLoading ? null : _handleUpdatePassword,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.transparent,
                                                    shadowColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25),
                                                    ),
                                                  ),
                                                  child: _viewModel.isLoading
                                                      ? const SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2.2,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(
                                                              Icons.laptop_chromebook_rounded,
                                                              color: Colors.white,
                                                              size: 18,
                                                            ),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              'Update Password',
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
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
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
          ),
          Center(
            child: Text(
              'SECURITY',
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? const Color(0xFFEF4444) : cardBorder,
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  prefixIcon,
                  color: const Color(0xFF94A3B8),
                  size: 19,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscured,
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
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: onToggleVisibility,
              ),
            ],
          ),
        ),
        if (hasError) ...[
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
