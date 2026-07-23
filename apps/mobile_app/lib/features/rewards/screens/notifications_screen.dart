import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _MockNotification(
        type: 'like',
        icon: Icons.favorite,
        color: Colors.red,
        title: 'Priya M. liked your post',
        body: 'Your DIY project post received a new like',
        timeAgo: '5m ago',
        read: false,
      ),
      _MockNotification(
        type: 'comment',
        icon: Icons.comment,
        color: Colors.blue,
        title: 'Rahul K. commented on your post',
        body: '"This is amazing! Where did you get the materials?"',
        timeAgo: '1h ago',
        read: false,
      ),
      _MockNotification(
        type: 'badge',
        icon: Icons.emoji_events,
        color: Colors.amber,
        title: 'New badge earned!',
        body: 'You earned the "Recycler" badge for recycling 10 items',
        timeAgo: '3h ago',
        read: true,
      ),
      _MockNotification(
        type: 'marketplace',
        icon: Icons.storefront,
        color: AppColors.primary,
        title: 'New inquiry on your listing',
        body: 'Someone is interested in your "2nd Year Textbooks"',
        timeAgo: '1d ago',
        read: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: n.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(n.icon, color: n.color, size: 20),
            ),
            title: Text(
              n.title,
              style: TextStyle(
                fontWeight: n.read ? FontWeight.normal : FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.body,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  n.timeAgo,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
            trailing: !n.read
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _MockNotification {
  final String type;
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String timeAgo;
  final bool read;
  const _MockNotification({
    required this.type,
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.read,
  });
}
