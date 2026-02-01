
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account'),
            subtitle: Text('Privacy, security, change number'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Message, group & call tones'),
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Storage and data'),
            subtitle: Text('Network usage, auto-download'),
          ),
           ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            subtitle: Text('Help center, contact us, privacy policy'),
          ),
        ],
      ),
    );
  }
}
