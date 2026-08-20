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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _lidOffset;
  late Animation<double> _ribbonScale;
  late Animation<double> _logoScale;
  late Animation<double> _optionsFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Animation 1: Lid flies up
    _lidOffset = Tween<double>(begin: 0.0, end: -45.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Animation 2: Ribbon flaps unfold
    _ribbonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Animation 3: Logo typography scales in
    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutBack),
      ),
    );

    // Animation 4: Account options fade in
    _optionsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start splash animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Central Gift Box Icon
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Ribbon background shine bubble
                      Transform.scale(
                        scale: _ribbonScale.value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: GraftiTheme.softLilac.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Gift Box Body
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateZ(math.sin(_controller.value * math.pi * 3) * 0.04 * (1 - _controller.value)),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: GraftiTheme.primaryPink,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                            boxShadow: GraftiTheme.softShadow,
                          ),
                          child: Center(
                            // Vertical and horizontal ribbon details
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 16,
                                    height: 80,
                                    color: GraftiTheme.secondaryPastelPink,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 80,
                                    height: 16,
                                    color: GraftiTheme.secondaryPastelPink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Gift Box Lid (flies upwards)
                      Positioned(
                        top: -12,
                        child: Transform.translate(
                          offset: Offset(0, _lidOffset.value),
                          child: Container(
                            width: 90,
                            height: 24,
                            decoration: BoxDecoration(
                              color: GraftiTheme.primaryPink,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: GraftiTheme.softShadow,
                            ),
                            child: Center(
                              // Ribbon lid bow
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 20,
                                      height: 24,
                                      color: GraftiTheme.secondaryPastelPink,
                                    ),
                                  ),
                                  // Top bows
                                  Positioned(
                                    top: -10,
                                    left: 20,
                                    child: Transform.rotate(
                                      angle: -math.pi / 4,
                                      child: Container(
                                        width: 22,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: GraftiTheme.secondaryPastelPink, width: 4),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: 20,
                                    child: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: Container(
                                        width: 22,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: GraftiTheme.secondaryPastelPink, width: 4),
                                          borderRadius: BorderRadius.circular(10),
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
                  );
                },
              ),
              const SizedBox(height: 48),
              // Brand logo typography
              ScaleTransition(
                scale: _logoScale,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 56,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'Grafti',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: GraftiTheme.darkPlum,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Everyone Deserves a Little Magic.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: GraftiTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Account Selection (fades in)
              FadeTransition(
                opacity: _optionsFade,
                child: Column(
                  children: [
                    Text(
                      'Identify Your Magic Space:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: GraftiTheme.darkPlum.withOpacity(0.8),
                        fontSize: 14,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAccountCard(
                            context: context,
                            title: 'Customer',
                            subtitle: 'Explore & Custom shop',
                            icon: Icons.favorite_border,
                            type: 'customer',
                            isSelected: provider.accountTypeSelection == 'customer',
                            onTap: () {
                              provider.setAccountTypeSelection('customer');
                              _handleSelection();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAccountCard(
                            context: context,
                            title: 'Business',
                            subtitle: 'Showcase your craft',
                            icon: Icons.storefront_outlined,
                            type: 'business',
                            isSelected: provider.accountTypeSelection == 'business',
                            onTap: () {
                              provider.setAccountTypeSelection('business');
                              _handleSelection();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected ? GraftiTheme.softShadow : [],
          border: Border.all(
            color: isSelected ? GraftiTheme.primaryPink : GraftiTheme.softLilac,
            width: isSelected ? 2.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? GraftiTheme.secondaryPastelPink : GraftiTheme.softLilac.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: GraftiTheme.darkPlum,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: GraftiTheme.plumDarkText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: GraftiTheme.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSelection() async {
    // Small delay to allow the user to see the selection change state, then proceed.
    await Future.delayed(const Duration(milliseconds: 400));
    widget.onSplashComplete();
  }
}
