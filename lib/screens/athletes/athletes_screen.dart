import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import 'add_athlete_screen.dart';

class AthletesScreen extends StatefulWidget {
  const AthletesScreen({super.key});

  @override
  State<AthletesScreen> createState() =>
      _AthletesScreenState();
}

class _AthletesScreenState
    extends State<AthletesScreen> {

  final service = AthleteService();

  late Future<List<Athlete>>
  athletesFuture;

  @override
  void initState() {
    super.initState();

    athletesFuture =
        service.getAthletes();
  }

  void refresh() {
    setState(() {
      athletesFuture =
          service.getAthletes();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text('Athletes'),
      ),

      floatingActionButton:
      FloatingActionButton(
        child:
        const Icon(Icons.add),

        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddAthleteScreen(),
            ),
          );

          refresh();
        },
      ),

      body: FutureBuilder<
          List<Athlete>>(
        future: athletesFuture,

        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final athletes =
              snapshot.data!;

          return ListView.builder(
            itemCount:
            athletes.length,

            itemBuilder:
                (context, index) {

              final athlete =
              athletes[index];

              return ListTile(

                title: Text(
                  athlete.fullName,
                ),

                subtitle: Text(
                  athlete.weightClass,
                ),

                trailing:
                IconButton(
                  icon:
                  const Icon(
                    Icons.delete,
                  ),

                  onPressed:
                      () async {

                    await service
                        .deleteAthlete(
                        athlete.id!);

                    refresh();
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