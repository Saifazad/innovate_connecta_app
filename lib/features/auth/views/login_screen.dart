import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../widgets/social_auth_button.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../models/auth_token.dart';
import '../models/auth_user.dart';
import '../../../core/services/auth_session_service.dart';
import '../repository/auth_repository.dart';
import '../../../app/main_navigation_screen.dart';
import '../../profile/view_models/profile_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  bool _obscurePassword = true;

  static const Color darkCanvas = Color(0xFF0A0F1D);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color primaryPurple = Color(0xFF635BFF);
  static const Color subtitleColor = Color(0xFF94A3B8);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authRepository.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

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
          content: Text('Please enter your password.'),
          backgroundColor: Color(0xFFF43F5E),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (response.status) {
        final token =
            response.token ??
            AuthToken(
              tokenType: 'Bearer',
              token: 'auth_${DateTime.now().millisecondsSinceEpoch}',
              expiresIn: 86400 * 30,
            );
        final user =
            response.user ??
            AuthUser(id: 1, name: email.split('@').first, email: email);
        await AuthSessionService.instance.saveSession(token: token, user: user);

        await ProfileViewModel.instance.onUserLoggedIn(
          email: email,
          authUser: response.user,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message.isNotEmpty
                  ? response.message
                  : 'Login successful!',
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
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
                  'Welcome Back',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Please log in to continue',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: subtitleColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),

                // --- 3. Email Address Field ---
                AppTextField(
                  label: 'Email Address',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.mail_outline_rounded,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // --- 4. Password Field with "show password" toggle ---
                AppTextField(
                  label: 'Password',
                  hintText: '••••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  headerTrailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Text(
                      _obscurePassword ? 'show password' : 'hide password',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                const SizedBox(height: 14),

                // --- 5. Forgot Password Action ---
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: brandOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // --- 6. Login Button with Glowing Violet Shadow ---
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
                    onPressed: _isLoading ? null : _onLogin,
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
                                'Login',
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
                const SizedBox(height: 32),

                // --- 7. Divider: OR CONNECT WITH ---
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFF1E293B), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR CONNECT WITH',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFF1E293B), thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- 8. Social Auth Buttons (Google & Apple) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialAuthButton.google(
                      onTap: () {
                        // Handle Google authentication
                      },
                    ),
                    const SizedBox(width: 20),
                    SocialAuthButton.apple(
                      onTap: () {
                        // Handle Apple authentication
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 54),

                // --- 9. Footer Link: "Don't have an account? Register" ---
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: subtitleColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: brandOrange,
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
}
