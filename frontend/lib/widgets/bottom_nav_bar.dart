import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final activeIndex = provider.activeTab;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
        border: Border.all(
          color: GraftiTheme.softLilac.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            icon: Icons.notifications_none_outlined,
            activeIcon: Icons.notifications_active,
            label: 'Alerts',
            badgeCount: provider.unreadNotifications,
            activeIndex: activeIndex,
            onTap: () => provider.setActiveTab(0),
          ),
          _buildNavItem(
            context: context,
            index: 1,
            icon: Icons.search_outlined,
            activeIcon: Icons.search,
            label: 'Search',
            activeIndex: activeIndex,
            onTap: () => provider.setActiveTab(1),
          ),
          _buildNavItem(
            context: context,
            index: 2,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            activeIndex: activeIndex,
            onTap: () => provider.setActiveTab(2),
          ),
          _buildNavItem(
            context: context,
            index: 3,
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart,
            label: 'Cart',
            badgeCount: provider.cart.length,
            activeIndex: activeIndex,
            onTap: () => provider.setActiveTab(3),
          ),
          _buildNavItem(
            context: context,
            index: 4,
            icon: Icons.person_outline_outlined,
            activeIcon: Icons.person,
            label: 'Profile',
            activeIndex: activeIndex,
            onTap: () => provider.setActiveTab(4),
          ),
          _buildNavItem(
            context: context,
            index: 5,
            icon: Icons.lightbulb_outline,
            activeIcon: Icons.auto_awesome, // Wand/Sparkle aesthetic
            label: 'Concierge',
            activeIndex: activeIndex,
            onTap: () => provider.setActiveTab(5),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
    required int activeIndex,
    required VoidCallback onTap,
  }) {
    final isActive = activeIndex == index;
    final activeColor = GraftiTheme.primaryPink;
    final inactiveColor = GraftiTheme.mutedText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedScale(
                scale: isActive ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? activeColor : inactiveColor,
                  size: 26,
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: GraftiTheme.secondaryPastelPink,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
                        style: const TextStyle(
                          color: GraftiTheme.darkPlum,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 4,
            width: isActive ? 16 : 0,
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }
}
