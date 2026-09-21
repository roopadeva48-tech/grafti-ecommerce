import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;
  const SplashScreen({required this.onSplashComplete, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _introController;
  late Animation<double> _lidOffset;
  late Animation<double> _ribbonScale;
  late Animation<double> _logoScale;
  late Animation<double> _optionsFade;
  late Animation<Offset> _optionsSlide;

  // Floating ambient animation
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Lid flies up
    _lidOffset = Tween<double>(begin: 0.0, end: -40.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // Ribbon unfolds
    _ribbonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.25, 0.65, curve: Curves.elasticOut),
      ),
    );

    // Logo scale
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Options fade and slide
    _optionsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    _optionsSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Continuous subtle floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _handleSelection(String role) async {
    setState(() {
      _selectedRole = role;
    });
    final provider = Provider.of<GraftiProvider>(context, listen: false);
    provider.setAccountTypeSelection(role);
    // Smooth feedback delay before transitioning
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) {
      widget.onSplashComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Stack(
        children: [
          // Ambient decorative background glow circles
          Positioned(
            top: -70,
            left: -70,
            child: Container(
              width: 250,
              height: 250,
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
            bottom: -90,
            right: -90,
            child: Container(
              width: 300,
              height: 300,
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

          // Main Centered Content Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  // Clean compact max width
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
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
                      vertical: 36,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated Gift Box Icon
                        AnimatedBuilder(
                          animation: Listenable.merge([_introController, _floatController]),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatAnim.value),
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  // Background soft pulse bubble
                                  Transform.scale(
                                    scale: _ribbonScale.value,
                                    child: Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: GraftiTheme.secondaryPastelPink
                                            .withValues(alpha: 0.85),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),

                                  // Gift Box Body
                                  Transform(
                                    alignment: Alignment.bottomCenter,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateZ(math.sin(_introController.value * math.pi * 3) *
                                          0.03 *
                                          (1 - _introController.value)),
                                    child: Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        color: GraftiTheme.primaryPink,
                                        borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(14),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: GraftiTheme.primaryPink
                                                .withValues(alpha: 0.25),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 14,
                                                height: 68,
                                                color: GraftiTheme.secondaryPastelPink,
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: 68,
                                                height: 14,
                                                color: GraftiTheme.secondaryPastelPink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Gift Box Lid (Flipping upwards)
                                  Positioned(
                                    top: -10,
                                    child: Transform.translate(
                                      offset: Offset(0, _lidOffset.value),
                                      child: Container(
                                        width: 76,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: GraftiTheme.primaryPink,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: GraftiTheme.primaryPink
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 16,
                                                  height: 20,
                                                  color: GraftiTheme.secondaryPastelPink,
                                                ),
                                              ),
                                              // Bow loops
                                              Positioned(
                                                top: -8,
                                                left: 16,
                                                child: Transform.rotate(
                                                  angle: -math.pi / 4,
                                                  child: Container(
                                                    width: 18,
                                                    height: 11,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: GraftiTheme.secondaryPastelPink,
                                                        width: 3.5,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: -8,
                                                right: 16,
                                                child: Transform.rotate(
                                                  angle: math.pi / 4,
                                                  child: Container(
                                                    width: 18,
                                                    height: 11,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: GraftiTheme.secondaryPastelPink,
                                                        width: 3.5,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),

                        // Logo & Tagline Header
                        ScaleTransition(
                          scale: _logoScale,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                height: 44,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Text(
                                  'GRAFTI',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3.0,
                                    color: GraftiTheme.darkPlum,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Everyone Deserves a Little Magic.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: GraftiTheme.mutedText.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Role Selection Options Section
                        FadeTransition(
                          opacity: _optionsFade,
                          child: SlideTransition(
                            position: _optionsSlide,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: GraftiTheme.softLilac.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Text(
                                        'Identify Your Magic Space',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: GraftiTheme.darkPlum.withValues(alpha: 0.85),
                                          fontSize: 12.5,
                                          letterSpacing: 0.5,
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

                                // Customer & Business Cards
                                Row(
                                  children: [
                                    Expanded(
                                      child: RoleChoiceCard(
                                        title: 'Customer',
                                        subtitle: 'Explore & Custom shop',
                                        icon: Icons.favorite_rounded,
                                        isSelected: _selectedRole == 'customer',
                                        onTap: () => _handleSelection('customer'),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: RoleChoiceCard(
                                        title: 'Business',
                                        subtitle: 'Showcase your craft',
                                        icon: Icons.storefront_rounded,
                                        isSelected: _selectedRole == 'business',
                                        onTap: () => _handleSelection('business'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
}

// Interactive Role Card with hover & selection micro-animations
class RoleChoiceCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  State<RoleChoiceCard> createState() => _RoleChoiceCardState();
}

class _RoleChoiceCardState extends State<RoleChoiceCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

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
              : (_isHovered ? 1.03 : 1.0),
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? GraftiTheme.primaryPink
                  : (_isHovered ? const Color(0xFFF8FAFC) : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? GraftiTheme.primaryPink
                    : (_isHovered
                        ? GraftiTheme.steelBlue.withValues(alpha: 0.4)
                        : GraftiTheme.softLilac.withValues(alpha: 0.9)),
                width: isSelected ? 2 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? GraftiTheme.primaryPink.withValues(alpha: 0.3)
                      : const Color(0xFF0F2C59).withValues(alpha: _isHovered ? 0.08 : 0.03),
                  blurRadius: isSelected ? 14 : (_isHovered ? 12 : 6),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : GraftiTheme.secondaryPastelPink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: isSelected ? Colors.white : GraftiTheme.primaryPink,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: isSelected ? Colors.white : GraftiTheme.plumDarkText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.85)
                        : GraftiTheme.mutedText,
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
