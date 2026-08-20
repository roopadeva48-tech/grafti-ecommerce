import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/grafti_theme.dart';
import 'providers/grafti_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/concierge_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/search_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GraftiProvider()),
      ],
      child: const GraftiApp(),
    ),
  );
}

class GraftiApp extends StatelessWidget {
  const GraftiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grafti',
      debugShowCheckedModeBanner: false,
      theme: GraftiTheme.themeData,
      home: const AppNavigationController(),
    );
  }
}

class AppNavigationController extends StatefulWidget {
  const AppNavigationController({super.key});

  @override
  State<AppNavigationController> createState() => _AppNavigationControllerState();
}

class _AppNavigationControllerState extends State<AppNavigationController> {
  bool _splashCompleted = false;

  void completeSplash() {
    setState(() {
      _splashCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);

    // Flow 1: Splash Screen & Account Selection
    if (!_splashCompleted) {
      return SplashScreen(onSplashComplete: completeSplash);
    }

    // Flow 2: Authentication
    if (!provider.isAuthenticated) {
      return const AuthScreen();
    }

    // Flow 3: Authenticated Screen Coordinator
    return const MainNavigationWrapper();
  }
}

class MainNavigationWrapper extends StatelessWidget {
  const MainNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final activeIndex = provider.activeTab;

    // Detect if desktop viewport
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    final List<Widget> screens = [
      const NotificationsScreen(),
      const SearchScreen(),
      const HomeScreen(),
      const CartScreen(),
      const ProfileScreen(),
      const ConciergeScreen(),
    ];

    if (isDesktop) {
      // Desktop Layout: Left Sidebar + content
      return Scaffold(
        body: Row(
          children: [
            // Left Sidebar Navigation
            Container(
              width: 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: GraftiTheme.softLilac, width: 1.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 42,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'Grafti',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: GraftiTheme.darkPlum,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Handmade Custom Craft',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: GraftiTheme.mutedText.withOpacity(0.8),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Menu Items
                  Expanded(
                    child: ListView(
                      children: [
                        _buildSidebarItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          label: 'Discover Home',
                          index: 2,
                          activeIndex: activeIndex,
                          onTap: () => provider.setActiveTab(2),
                        ),
                        _buildSidebarItem(
                          icon: Icons.search_outlined,
                          activeIcon: Icons.search,
                          label: 'Search Items',
                          index: 1,
                          activeIndex: activeIndex,
                          onTap: () => provider.setActiveTab(1),
                        ),
                        _buildSidebarItem(
                          icon: Icons.lightbulb_outline,
                          activeIcon: Icons.auto_awesome,
                          label: 'AI Concierge',
                          index: 5,
                          activeIndex: activeIndex,
                          onTap: () => provider.setActiveTab(5),
                        ),
                        _buildSidebarItem(
                          icon: Icons.shopping_cart_outlined,
                          activeIcon: Icons.shopping_cart,
                          label: 'Shopping Cart',
                          index: 3,
                          activeIndex: activeIndex,
                          badgeCount: provider.cart.length,
                          onTap: () => provider.setActiveTab(3),
                        ),
                        _buildSidebarItem(
                          icon: Icons.notifications_none_outlined,
                          activeIcon: Icons.notifications_active,
                          label: 'Alerts & Messages',
                          index: 0,
                          activeIndex: activeIndex,
                          badgeCount: provider.unreadNotifications,
                          onTap: () => provider.setActiveTab(0),
                        ),
                        _buildSidebarItem(
                          icon: Icons.person_outline_outlined,
                          activeIcon: Icons.person,
                          label: 'Profile Settings',
                          index: 4,
                          activeIndex: activeIndex,
                          onTap: () => provider.setActiveTab(4),
                        ),
                      ],
                    ),
                  ),

                  // Footer Logged-in User Card
                  const Divider(color: GraftiTheme.softLilac),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: ClipOval(
                      child: Image.network(
                        '${provider.baseUrl}${provider.currentUser?.avatarUrl ?? "/images/avatar_deva.jpg"}',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => const Icon(Icons.person, color: GraftiTheme.darkPlum),
                      ),
                    ),
                    title: Text(
                      provider.currentUser?.name ?? 'Deva',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GraftiTheme.plumDarkText),
                    ),
                    subtitle: Text(
                      provider.accountTypeSelection.toUpperCase(),
                      style: const TextStyle(fontSize: 10, color: GraftiTheme.mutedText),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, size: 18, color: Colors.redAccent),
                      onPressed: () => provider.logout(),
                    ),
                  ),
                ],
              ),
            ),

            // Right Panel Page Viewer
            Expanded(
              child: IndexedStack(
                index: activeIndex,
                children: screens,
              ),
            ),
          ],
        ),
      );
    } else {
      // Mobile Layout: Bottom navigation overlay + content
      return Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: activeIndex,
              children: screens,
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: CustomBottomNavBar(),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int activeIndex,
    int badgeCount = 0,
    required VoidCallback onTap,
  }) {
    final isActive = index == activeIndex;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? GraftiTheme.secondaryPastelPink : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? GraftiTheme.darkPlum : GraftiTheme.mutedText,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? GraftiTheme.darkPlum : GraftiTheme.plumDarkText,
                    fontSize: 13,
                  ),
                ),
              ),
              if (badgeCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : GraftiTheme.secondaryPastelPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: GraftiTheme.darkPlum,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
