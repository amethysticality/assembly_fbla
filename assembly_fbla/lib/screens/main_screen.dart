import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../screens/home_screen.dart';
import '../screens/events_screen.dart';
import '../screens/learning_screen.dart';
import '../screens/resources_screen.dart';
import '../screens/profile_screen.dart';
import 'auth_wrapper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _initialSearchQuery;
  bool _showBackArrowOnEvents = false;
  bool _showBackArrowOnLearning = false;

  final List<Event> _events = [
    Event(
      title: 'Intro to Competitive Events',
      category: 'Workshop',
      categoryColor: const Color(0xFF10B981),
      date: 'Jan 15, 2026',
      time: '10:00 AM - 12:00 PM',
      location: 'Room 101',
      attendees: '32 attendees',
    ),
    Event(
      title: 'Stock Market Game Kickoff',
      category: 'Competition',
      categoryColor: const Color(0xFFEF4444),
      date: 'Jan 20, 2026',
      time: '1:00 PM - 2:00 PM',
      location: 'Auditorium',
      attendees: '78 attendees',
    ),
    Event(
      title: 'Leadership Workshop',
      category: 'Workshop',
      categoryColor: const Color(0xFF8B5CF6),
      date: 'Jan 25, 2026',
      time: '2:00 PM - 4:00 PM',
      location: 'Room 204',
      attendees: '45 attendees',
      isRegistered: true,
    ),
    Event(
      title: 'CTSO State Competition',
      category: 'Competition',
      categoryColor: const Color(0xFFEC4899),
      date: 'Feb 5, 2026',
      time: '9:00 AM - 5:00 PM',
      location: 'Convention Center',
      attendees: '250 attendees',
    ),
    Event(
      title: 'Guest Speaker: CEO of Tech Innovations',
      category: 'Networking',
      categoryColor: const Color(0xFFF59E0B),
      date: 'Feb 12, 2026',
      time: '6:00 PM - 7:00 PM',
      location: 'Main Hall',
      attendees: '120 attendees',
    ),
    Event(
      title: 'Resume Building Workshop',
      category: 'Career',
      categoryColor: const Color(0xFF3B82F6),
      date: 'Feb 20, 2026',
      time: '3:00 PM - 4:30 PM',
      location: 'Library',
      attendees: '28 attendees',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _initialSearchQuery = null;
      _showBackArrowOnEvents = false;
      _showBackArrowOnLearning = false;
    });
  }

  void _navigateToHome() {
    setState(() {
      _selectedIndex = 0;
      _initialSearchQuery = null;
      _showBackArrowOnEvents = false;
      _showBackArrowOnLearning = false;
    });
  }

  void _navigateToEventsFromHome() {
    setState(() {
      _selectedIndex = 1;
      _initialSearchQuery = null;
      _showBackArrowOnEvents = true;
    });
  }

  void _navigateToLearningFromHome() {
    setState(() {
      _selectedIndex = 2; // Learning is at index 2
      _showBackArrowOnLearning = true;
    });
  }

  void _navigateToEvent(Event event) {
    setState(() {
      _initialSearchQuery = event.title;
      _selectedIndex = 1;
      _showBackArrowOnEvents = true;
    });
  }

  void _registerForEvent(Event event) {
    setState(() {
      event.isRegistered = true;
    });
  }

  void _unregisterForEvent(Event event) {
    setState(() {
      event.isRegistered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final registeredEvents = _events.where((event) => event.isRegistered).toList();

    final user = Provider.of<User?>(context);

    final List<Widget> screens = [
      HomeScreen(
        onNavigateToEvents: _navigateToEventsFromHome,
        onNavigateToEvent: _navigateToEvent,
        onNavigateToLearning: _navigateToLearningFromHome,
        registeredEvents: registeredEvents,
      ),
      EventsScreen(
        events: _events,
        onRegister: _registerForEvent,
        onUnregister: _unregisterForEvent,
        initialSearchQuery: _initialSearchQuery,
        onBack: _navigateToHome,
        showBackArrow: _showBackArrowOnEvents,
      ),
      LearningScreen(
        onBack: _navigateToHome,
        showBackArrow: _showBackArrowOnLearning,
      ),
      const ResourcesScreen(),
      user == null ? const AuthWrapper() : const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF6B7280),
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
