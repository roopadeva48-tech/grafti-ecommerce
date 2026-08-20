import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false; // Toggle SignIn vs SignUp
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top curved banner
            ClipPath(
              clipper: HeaderCurveClipper(),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [GraftiTheme.softLilac, GraftiTheme.secondaryPastelPink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          'Grafti',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: GraftiTheme.darkPlum,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '"Love Stories Start with Our Gifts."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: GraftiTheme.darkPlum.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Form container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Segmented Sliding Toggle
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: GraftiTheme.softLilac.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            alignment: _isSignUp
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: GraftiTheme.primaryPink,
                                  borderRadius: BorderRadius.circular(21),
                                  boxShadow: GraftiTheme.softShadow,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isSignUp = false;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: !_isSignUp
                                            ? Colors.white
                                            : GraftiTheme.darkPlum,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isSignUp = true;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: _isSignUp
                                            ? Colors.white
                                            : GraftiTheme.darkPlum,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Toggle hint pointer indicator
                    Align(
                      alignment: _isSignUp ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AnimatedOpacity(
                          opacity: !_isSignUp ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "New User? Create Account ",
                                style: TextStyle(
                                    color: GraftiTheme.primaryPink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: GraftiTheme.primaryPink),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Inputs
                    if (_isSignUp) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outline,
                              color: GraftiTheme.mutedText),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: GraftiTheme.mutedText),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: GraftiTheme.mutedText),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: GraftiTheme.mutedText,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
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

                    if (!_isSignUp) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: GraftiTheme.mutedText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Primary Action button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GraftiTheme.primaryPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: provider.isAuthLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  bool success;
                                  if (_isSignUp) {
                                    success = await provider.signup(
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text,
                                    );
                                  } else {
                                    success = await provider.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  }
                                  if (!success && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Authentication Failed.'),
                                      ),
                                    );
                                  }
                                }
                              },
                        child: provider.isAuthLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isSignUp ? 'Sign Up' : 'Sign In',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Social logins
                    Row(
                      children: [
                        const Expanded(child: Divider(color: GraftiTheme.softLilac)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Or connect with',
                            style: TextStyle(
                              color: GraftiTheme.mutedText,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: GraftiTheme.softLilac)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialBounceButton(
                          icon: 'assets/google.png', // Fallback display icon
                          label: 'Google',
                          onTap: () async {
                            await provider.login('deva@gmail.com', '123456');
                          },
                        ),
                        const SizedBox(width: 24),
                        SocialBounceButton(
                          icon: 'assets/facebook.png',
                          label: 'Facebook',
                          onTap: () async {
                            await provider.login('deva@gmail.com', '123456');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
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

// Bouncing social oauth login node
class SocialBounceButton extends StatefulWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const SocialBounceButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  State<SocialBounceButton> createState() => _SocialBounceButtonState();
}

class _SocialBounceButtonState extends State<SocialBounceButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.9;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: GraftiTheme.softShadow,
            border: Border.all(color: GraftiTheme.softLilac.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(
                widget.label == 'Google'
                    ? Icons.g_mobiledata_rounded
                    : Icons.facebook_rounded,
                color: widget.label == 'Google' ? Colors.redAccent : Colors.blueAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: GraftiTheme.plumDarkText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Clipper for header wave
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    // Wave point control
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
