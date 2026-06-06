import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import '../../services/event_service.dart';
import '../athletes/athlete_detail_screen.dart';
import '../events/event_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AthleteService athleteService = AthleteService();
  final EventService eventService = EventService();

  final searchController = TextEditingController();

  List<Athlete> athletes = [];
  List<Map<String, dynamic>> events = [];

  bool isLoading = false;
  String searchType = 'Athletes';

  Future<void> runSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        athletes = [];
        events = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (searchType == 'Athletes') {
        final results = await athleteService.searchAthletes(query.trim());

        setState(() {
          athletes = results;
          events = [];
        });
      } else {
        final results = await eventService.searchEvents(query.trim());

        setState(() {
          events = results;
          athletes = [];
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search error: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildAthleteResults() {
    if (athletes.isEmpty && searchController.text.isNotEmpty) {
      return const Center(child: Text('No athletes found'));
    }

    return ListView.builder(
      itemCount: athletes.length,
      itemBuilder: (context, index) {
        final athlete = athletes[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(athlete.fullName),
            subtitle: Text(
              '${athlete.nickname} • ${athlete.gym}\n'
              '${athlete.weightClass} • ${athlete.wins}-${athlete.losses}-${athlete.draws}',
            ),
            isThreeLine: true,
            trailing: Text('${athlete.rankingPoints} pts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AthleteDetailScreen(
                    athlete: athlete,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildEventResults() {
    if (events.isEmpty && searchController.text.isNotEmpty) {
      return const Center(child: Text('No events found'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.event),
            ),
            title: Text(event['name'] ?? ''),
            subtitle: Text(
              '${event['event_date'] ?? ''}\n'
              '${event['venue'] ?? ''}, ${event['city'] ?? ''}',
            ),
            isThreeLine: true,
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
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSearched = searchController.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: searchType == 'Athletes'
                    ? 'Search athletes, gym, weight class'
                    : 'Search events, venue, city',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: runSearch,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: searchType,
              decoration: const InputDecoration(
                labelText: 'Search Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Athletes',
                  child: Text('Athletes'),
                ),
                DropdownMenuItem(
                  value: 'Events',
                  child: Text('Events'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  searchType = value!;
                  athletes = [];
                  events = [];
                  searchController.clear();
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (!hasSearched)
            const Expanded(
              child: Center(
                child: Text('Start typing to search CageID'),
              ),
            )
          else
            Expanded(
              child: searchType == 'Athletes'
                  ? buildAthleteResults()
                  : buildEventResults(),
            ),
        ],
      ),
    );
  }
}