import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final user = provider.currentUser;

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'My Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
        ),
        actions: [
          // Sign Out button
          IconButton(
            icon: const Icon(Icons.logout, color: GraftiTheme.primaryPink),
            onPressed: () {
              provider.logout();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Top Profile Header card
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // Profile Ring
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x11531853),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          '${provider.baseUrl}${user?.avatarUrl ?? "/images/avatar_deva.jpg"}',
                          width: 112,
                          height: 112,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 56, color: GraftiTheme.darkPlum),
                        ),
                      ),
                    ),
                    // Floating Edit Pencil icon
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: GraftiTheme.primaryPink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Username & Role Tag
              Text(
                user?.name ?? 'Deva',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GraftiTheme.darkPlum,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: provider.accountTypeSelection == 'business'
                      ? const Color(0xFFE8F5E9)
                      : GraftiTheme.softLilac.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  provider.accountTypeSelection.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: provider.accountTypeSelection == 'business'
                        ? const Color(0xFF2E7D32)
                        : GraftiTheme.darkPlum,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Settings/Navigation list
              _buildSettingsCard(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                subtitle: user?.phoneNumber ?? '+1 (555) 019-2834',
                onTap: () {},
              ),
              _buildSettingsCard(
                icon: Icons.credit_card_outlined,
                title: 'Payment Mode',
                subtitle: user?.paymentMode ?? 'Saved Cards, UPI, Wallets',
                onTap: () {},
              ),
              _buildSettingsCard(
                icon: Icons.location_on_outlined,
                title: 'Location Settings',
                subtitle: user?.location ?? 'Saved Addresses & GPS Pin',
                onTap: () {},
              ),
              _buildSettingsCard(
                icon: Icons.local_shipping_outlined,
                title: 'Delivery Address',
                subtitle: user?.deliveryAddress ?? '123 Magic Ribbon Way, Craftland',
                onTap: () {},
              ),
              _buildSettingsCard(
                icon: Icons.support_agent_outlined,
                title: 'Help Line & Support',
                subtitle: 'Grafti chat helpline available 24/7',
                onTap: () {
                  provider.setActiveTab(5); // Switch to AI concierge chat
                },
              ),

              const SizedBox(height: 96), // Buffer for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
        border: Border.all(color: GraftiTheme.softLilac.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: GraftiTheme.softLilac.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: GraftiTheme.darkPlum,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: GraftiTheme.plumDarkText,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: GraftiTheme.mutedText,
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: GraftiTheme.mutedText,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}
