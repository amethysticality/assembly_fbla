import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event.dart';
import 'dart:collection';

class CalendarScreen extends StatefulWidget {
  final List<Event> registeredEvents;

  const CalendarScreen({super.key, this.registeredEvents = const []});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<Event>> _eventsByDate;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsByDate = _groupEvents(widget.registeredEvents);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Map<DateTime, List<Event>> _groupEvents(List<Event> events) {
    final data = LinkedHashMap<DateTime, List<Event>>(equals: isSameDay, hashCode: getHashCode);
    for (var event in events) {
      final date = _parseDate(event.date);
      final day = DateTime.utc(date.year, date.month, date.day);
      if (data[day] == null) {
        data[day] = [];
      }
      data[day]!.add(event);
    }
    return data;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _eventsByDate[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }
  
  DateTime _parseDate(String date) {
    final parts = date.split(' ');
    final month = _getMonthNumber(parts[0]);
    final day = int.parse(parts[1].replaceAll(',', ''));
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  int _getMonthNumber(String month) {
    switch (month) {
      case 'Jan': return 1;
      case 'Feb': return 2;
      case 'Mar': return 3;
      case 'Apr': return 4;
      case 'May': return 5;
      case 'Jun': return 6;
      case 'Jul': return 7;
      case 'Aug': return 8;
      case 'Sep': return 9;
      case 'Oct': return 10;
      case 'Nov': return 11;
      case 'Dec': return 12;
      default: return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () {},
                        title: Text(value[index].title),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}