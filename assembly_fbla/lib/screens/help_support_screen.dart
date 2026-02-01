
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help Center'),
          ),
          ListTile(
            leading: Icon(Icons.contact_phone_outlined),
            title: Text('Contact Us'),
          ),
          ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Terms and Privacy Policy'),
          ),
           ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Info'),
          ),
        ],
      ),
    );
  }
}
