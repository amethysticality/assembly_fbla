
import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Achievements'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Achievement 1'),
            subtitle: Text('Description of achievement 1'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Achievement 2'),
            subtitle: Text('Description of achievement 2'),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Achievement 3'),
            subtitle: Text('Description of achievement 3'),
          ),
        ],
      ),
    );
  }
}
