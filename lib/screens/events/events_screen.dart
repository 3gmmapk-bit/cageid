import 'package:flutter/material.dart';

import '../../services/event_service.dart';
import '../../services/role_service.dart';
import 'add_event_screen.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventService service = EventService();
  final RoleService roleService = RoleService();

  Future<void> openAddEvent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEventScreen(),
      ),
    );

    setState(() {});
  }

  Future<void> deleteEvent(String id) async {
    await service.deleteEvent(id);
    setState(() {});
  }

  Widget buildDeleteButton(String eventId) {
    return FutureBuilder<bool>(
      future: roleService.isSuperAdmin(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () async {
            await deleteEvent(eventId);
          },
        );
      },
    );
  }

  Widget buildAddButton() {
    return FutureBuilder<bool>(
      future: roleService.canManageEvents(),
      builder: (context, snapshot) {
        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: openAddEvent,
          child: const Icon(Icons.add),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      floatingActionButton: buildAddButton(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: service.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading events: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text('No events found.'),
            );
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              final eventId = event['id'];
              final eventName = event['name'] ?? 'Unnamed Event';
              final eventDate = event['event_date'] ?? '';
              final venue = event['venue'] ?? '';
              final city = event['city'] ?? '';
              final country = event['country'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.event),
                  ),
                  title: Text(eventName),
                  subtitle: Text(
                    '$eventDate\n$venue, $city, $country',
                  ),
                  isThreeLine: true,
                  trailing: buildDeleteButton(eventId),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(
                          event: event,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}