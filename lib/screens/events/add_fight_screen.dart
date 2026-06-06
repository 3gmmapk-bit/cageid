import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import '../../services/fight_service.dart';

class AddFightScreen extends StatefulWidget {
  final String eventId;

  const AddFightScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<AddFightScreen> createState() => _AddFightScreenState();
}

class _AddFightScreenState extends State<AddFightScreen> {
  final AthleteService athleteService = AthleteService();
  final FightService fightService = FightService();

  String? redFighterId;
  String? blueFighterId;

  final weightClassController = TextEditingController();

  bool isSaving = false;

  Future<void> saveFight() async {
    if (redFighterId == null || blueFighterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select both fighters')),
      );
      return;
    }

    if (redFighterId == blueFighterId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fighters must be different')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await fightService.addFight(
        eventId: widget.eventId,
        fighterRed: redFighterId!,
        fighterBlue: blueFighterId!,
        weightClass: weightClassController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving fight: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    weightClassController.dispose();
    super.dispose();
  }

  DropdownMenuItem<String> buildAthleteItem(Athlete athlete) {
    return DropdownMenuItem<String>(
      value: athlete.id,
      child: Text(athlete.fullName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fight'),
      ),
      body: FutureBuilder<List<Athlete>>(
        future: athleteService.getAthletes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading athletes: ${snapshot.error}'),
            );
          }

          final athletes = snapshot.data ?? [];

          if (athletes.length < 2) {
            return const Center(
              child: Text('Add at least 2 athletes before creating a fight.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: redFighterId,
                  decoration: const InputDecoration(
                    labelText: 'Red Corner Fighter',
                    border: OutlineInputBorder(),
                  ),
                  items: athletes.map(buildAthleteItem).toList(),
                  onChanged: (value) {
                    setState(() {
                      redFighterId = value;
                    });
                  },
                ),

                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: blueFighterId,
                  decoration: const InputDecoration(
                    labelText: 'Blue Corner Fighter',
                    border: OutlineInputBorder(),
                  ),
                  items: athletes.map(buildAthleteItem).toList(),
                  onChanged: (value) {
                    setState(() {
                      blueFighterId = value;
                    });
                  },
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: weightClassController,
                  decoration: const InputDecoration(
                    labelText: 'Weight Class',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : saveFight,
                    child: isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Save Fight'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}