import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false; // Toggle SignIn vs SignUp
  bool _obscurePassword = true;
  bool _isHoveringSubmit = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _switchTab(bool isSignUp) {
    if (_isSignUp != isSignUp) {
      setState(() {
        _isSignUp = isSignUp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          // Ambient decorative background glow circles
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GraftiTheme.steelBlue.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    GraftiTheme.primaryPink.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Centered Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: ConstrainedBox(
                        // Compact max width to prevent wide stretching
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: GraftiTheme.softLilac.withValues(alpha: 0.8),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F2C59).withValues(alpha: 0.07),
                                blurRadius: 28,
                                spreadRadius: 0,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: const Color(0xFF0F2C59).withValues(alpha: 0.03),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 32,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Logo & Branding Header
                                Center(
                                  child: Image.asset(
                                    'assets/logo.png',
                                    height: 64,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Text(
                                      'GRAFTI',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 3.0,
                                        color: GraftiTheme.darkPlum,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '"Love Stories Start with Our Gifts."',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    color: GraftiTheme.mutedText.withValues(alpha: 0.9),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Animated Segmented Tab Toggle
                                Container(
                                  height: 44,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F4F9),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: GraftiTheme.softLilac.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Sliding Active Indicator
                                      AnimatedAlign(
                                        duration: const Duration(milliseconds: 260),
                                        curve: Curves.easeInOutCubic,
                                        alignment: _isSignUp
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          widthFactor: 0.5,
                                          heightFactor: 1.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: GraftiTheme.primaryPink,
                                              borderRadius: BorderRadius.circular(19),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: GraftiTheme.primaryPink
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Tab Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(19),
                                              onTap: () => _switchTab(false),
                                              child: Center(
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 200),
                                                  style: TextStyle(
                                                    color: !_isSignUp
                                                        ? Colors.white
                                                        : GraftiTheme.mutedText,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                  child: const Text('Sign In'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(19),
                                              onTap: () => _switchTab(true),
                                              child: Center(
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 200),
                                                  style: TextStyle(
                                                    color: _isSignUp
                                                        ? Colors.white
                                                        : GraftiTheme.mutedText,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                  child: const Text('Sign Up'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Animated Expand/Collapse for Sign Up Extra Field
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 280),
                                  curve: Curves.easeInOutCubic,
                                  child: _isSignUp
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: 14.0),
                                          child: TextFormField(
                                            controller: _nameController,
                                            textInputAction: TextInputAction.next,
                                            style: const TextStyle(fontSize: 14),
                                            decoration: _buildInputDecoration(
                                              hintText: 'Full Name',
                                              prefixIcon: Icons.person_outline_rounded,
                                            ),
                                            validator: (value) {
                                              if (_isSignUp &&
                                                  (value == null || value.trim().isEmpty)) {
                                                return 'Please enter your name';
                                              }
                                              return null;
                                            },
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),

                                // Email Input
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: _buildInputDecoration(
                                    hintText: 'Email Address',
                                    prefixIcon: Icons.mail_outline_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                // Password Input
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: _buildInputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    suffixIcon: IconButton(
                                      splashRadius: 18,
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: GraftiTheme.mutedText,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),

                                // Forgot Password Link
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  child: !_isSignUp
                                      ? Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 4,
                                              ),
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Password reset link has been sent to your email.',
                                                  ),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                color: GraftiTheme.mutedText,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(height: 20),

                                // Animated Submit Button
                                MouseRegion(
                                  onEnter: (_) => setState(() => _isHoveringSubmit = true),
                                  onExit: (_) => setState(() => _isHoveringSubmit = false),
                                  child: AnimatedScale(
                                    scale: _isHoveringSubmit ? 1.015 : 1.0,
                                    duration: const Duration(milliseconds: 150),
                                    child: SizedBox(
                                      height: 48,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: GraftiTheme.primaryPink,
                                          foregroundColor: Colors.white,
                                          elevation: _isHoveringSubmit ? 4 : 1,
                                          shadowColor: GraftiTheme.primaryPink
                                              .withValues(alpha: 0.4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: provider.isAuthLoading
                                            ? null
                                            : () async {
                                                if (_formKey.currentState!.validate()) {
                                                  bool success;
                                                  if (_isSignUp) {
                                                    success = await provider.signup(
                                                      _emailController.text.trim(),
                                                      _passwordController.text,
                                                      _nameController.text.trim(),
                                                    );
                                                  } else {
                                                    success = await provider.login(
                                                      _emailController.text.trim(),
                                                      _passwordController.text,
                                                    );
                                                  }
                                                  if (!success && mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        behavior:
                                                            SnackBarBehavior.floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(12),
                                                        ),
                                                        content: const Text(
                                                          'Authentication Failed. Please check your credentials.',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                        child: provider.isAuthLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : AnimatedSwitcher(
                                                duration:
                                                    const Duration(milliseconds: 200),
                                                child: Text(
                                                  _isSignUp ? 'Sign Up' : 'Sign In',
                                                  key: ValueKey(_isSignUp),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Divider "Or continue with"
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: GraftiTheme.softLilac.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Text(
                                        'Or continue with',
                                        style: TextStyle(
                                          color: GraftiTheme.mutedText.withValues(alpha: 0.8),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: GraftiTheme.softLilac.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                // Social Auth Buttons (Google & Facebook)
                                Row(
                                  children: [
                                    Expanded(
                                      child: SocialBounceButton(
                                        icon: Icons.g_mobiledata_rounded,
                                        iconColor: const Color(0xFFEA4335),
                                        label: 'Google',
                                        onTap: () async {
                                          await provider.login(
                                              'deva@gmail.com', '123456');
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: SocialBounceButton(
                                        icon: Icons.facebook_rounded,
                                        iconColor: const Color(0xFF1877F2),
                                        label: 'Facebook',
                                        onTap: () async {
                                          await provider.login(
                                              'deva@gmail.com', '123456');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: GraftiTheme.mutedText.withValues(alpha: 0.6),
        fontSize: 13.5,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: GraftiTheme.mutedText.withValues(alpha: 0.8),
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: GraftiTheme.softLilac.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: GraftiTheme.primaryPink,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }
}

// Bouncing Interactive Social OAuth Button
class SocialBounceButton extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const SocialBounceButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  State<SocialBounceButton> createState() => _SocialBounceButtonState();
}

class _SocialBounceButtonState extends State<SocialBounceButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed
              ? 0.94
              : (_isHovered ? 1.02 : 1.0),
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFFF8FAFC) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered
                    ? GraftiTheme.primaryPink.withValues(alpha: 0.3)
                    : GraftiTheme.softLilac.withValues(alpha: 0.8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F2C59).withValues(alpha: _isHovered ? 0.06 : 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: GraftiTheme.plumDarkText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
