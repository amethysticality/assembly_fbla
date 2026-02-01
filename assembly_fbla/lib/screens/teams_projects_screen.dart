
import 'package:flutter/material.dart';

class TeamsProjectsScreen extends StatelessWidget {
  const TeamsProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams & Projects'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Project Alpha'),
            subtitle: Text('Competitive event preparation team'),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Community Service Initiative'),
            subtitle: Text('Organizing the annual food drive'),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('State Conference Planning'),
            subtitle: Text('Logistics and coordination team'),
          ),
        ],
      ),
    );
  }
}
