import 'package:flutter/material.dart';

import '../../services/fight_service.dart';
import 'add_fight_screen.dart';
import 'add_fight_result_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final FightService fightService = FightService();

  Future<void> openAddFight() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddFightScreen(
          eventId: widget.event['id'],
        ),
      ),
    );

    setState(() {});
  }

  Future<void> openResultScreen(Map<String, dynamic> fight) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddFightResultScreen(
          fight: fight,
        ),
      ),
    );

    setState(() {});
  }

  String fighterName(Map<String, dynamic>? fighter) {
    if (fighter == null) return 'Unknown';
    return fighter['full_name'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final eventName = widget.event['name'] ?? 'Event';

    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddFight,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(eventName),
              subtitle: Text(
                '${widget.event['event_date'] ?? ''}\n'
                '${widget.event['venue'] ?? ''}, ${widget.event['city'] ?? ''}',
              ),
              isThreeLine: true,
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fight Card',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fightService.getFightsByEvent(widget.event['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading fights: ${snapshot.error}'),
                  );
                }

                final fights = snapshot.data ?? [];

                if (fights.isEmpty) {
                  return const Center(
                    child: Text('No fights added yet. Tap + to add fight.'),
                  );
                }

                return ListView.builder(
                  itemCount: fights.length,
                  itemBuilder: (context, index) {
                    final fight = fights[index];

                    final redName = fighterName(fight['red']);
                    final blueName = fighterName(fight['blue']);
                    final winnerName = fighterName(fight['winner']);
                    final completed = fight['is_completed'] == true;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text('$redName vs $blueName'),
                        subtitle: Text(
                          completed
                              ? 'Winner: $winnerName • ${fight['method']} • Round ${fight['round']}'
                              : '${fight['weight_class'] ?? ''} • Result pending',
                        ),
                        trailing: completed
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () => openResultScreen(fight),
                                child: const Text('Result'),
                              ),
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