
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.event),
            title: Text('New Event: FBLA State Conference'),
            subtitle: Text('The FBLA State Conference is just around the corner!'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('New Achievement Unlocked!'),
            subtitle: Text('You\'ve earned the "Top Learner" badge.'),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('New Message from Your Team'),
            subtitle: Text('Don\'t forget about the team meeting tomorrow.'),
          ),
        ],
      ),
    );
  }
}
