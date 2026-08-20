import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final notifications = provider.notificationsList;

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                provider.clearNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications marked as read.')),
                );
              },
              child: const Text(
                'Mark read',
                style: TextStyle(color: GraftiTheme.primaryPink, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: notifications.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none, size: 64, color: GraftiTheme.softLilac),
                    SizedBox(height: 16),
                    Text(
                      'No new notifications',
                      style: TextStyle(color: GraftiTheme.mutedText),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final note = notifications[index];
                  // Simple logic to show unread visual difference
                  final isUnread = index < provider.unreadNotifications;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: GraftiTheme.softShadow,
                      border: Border.all(
                        color: isUnread ? GraftiTheme.primaryPink.withOpacity(0.5) : GraftiTheme.softLilac.withOpacity(0.3),
                        width: isUnread ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUnread ? GraftiTheme.secondaryPastelPink : GraftiTheme.softLilac.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUnread ? Icons.star : Icons.star_border,
                          color: GraftiTheme.darkPlum,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        note,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          color: GraftiTheme.plumDarkText,
                        ),
                      ),
                      trailing: isUnread
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: GraftiTheme.primaryPink,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
