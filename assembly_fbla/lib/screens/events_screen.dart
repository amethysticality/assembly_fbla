import 'package:flutter/material.dart';
import '../models/event.dart';
import 'calendar_screen.dart';

class EventsScreen extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onRegister;
  final Function(Event) onUnregister;
  final String? initialSearchQuery;
  final VoidCallback? onBack;
  final bool showBackArrow;

  const EventsScreen({
    super.key,
    required this.events,
    required this.onRegister,
    required this.onUnregister,
    this.initialSearchQuery,
    this.onBack,
    this.showBackArrow = false,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final TextEditingController _searchController;
  late List<Event> _filteredEvents;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery);
    _filteredEvents = widget.events;
    _filterEvents();
    _searchController.addListener(_filterEvents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEvents);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EventsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearchQuery != oldWidget.initialSearchQuery) {
      _searchController.text = widget.initialSearchQuery ?? '';
    }
    if (widget.showBackArrow != oldWidget.showBackArrow ||
        widget.initialSearchQuery != oldWidget.initialSearchQuery) {
      _filterEvents();
    }
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEvents = widget.events.where((event) {
        return event.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.showBackArrow
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
                onPressed: widget.onBack,
              )
            : null,
        title: const Text(
          'Events',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF3B82F6)),
            onPressed: () {
              final registeredEvents =
                  widget.events.where((event) => event.isRegistered).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CalendarScreen(registeredEvents: registeredEvents),
                ),
              );
            },
            tooltip: 'View in Calendar',
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredEvents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return _EventCard(
                  event: event,
                  onRegister: () => widget.onRegister(event),
                  onUnregister: () => widget.onUnregister(event),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onRegister;
  final VoidCallback onUnregister;

  const _EventCard({
    required this.event,
    required this.onRegister,
    required this.onUnregister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: event.categoryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: event.categoryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetail(Icons.calendar_today, event.date),
                const SizedBox(height: 8),
                _buildDetail(Icons.access_time, event.time),
                const SizedBox(height: 8),
                _buildDetail(Icons.location_on_outlined, event.location),
                const SizedBox(height: 8),
                _buildDetail(Icons.people_outline, event.attendees),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: event.isRegistered
                    ? ElevatedButton(
                        onPressed: onUnregister,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(const Color(0xFF3B82F6)),
                          foregroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                        child: const Text('Unregister'),
                      )
                    : ElevatedButton(
                        onPressed: onRegister,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(const Color(0xFFA4C8F9)),
                          foregroundColor: WidgetStateProperty.all(Colors.black),
                        ),
                        child: const Text('Register'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
