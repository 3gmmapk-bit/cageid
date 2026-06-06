import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService service = DashboardService();

  Map<String, int> countByField(
    List<Map<String, dynamic>> athletes,
    String field,
  ) {
    final Map<String, int> result = {};

    for (final athlete in athletes) {
      final value = athlete[field]?.toString() ?? 'Unknown';
      if (value.isEmpty) continue;

      result[value] = (result[value] ?? 0) + 1;
    }

    return result;
  }

  int totalByField(List<Map<String, dynamic>> athletes, String field) {
    int total = 0;

    for (final athlete in athletes) {
      total += (athlete[field] ?? 0) as int;
    }

    return total;
  }

  Widget statCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 22, 12, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildBarChart(Map<String, int> data) {
    final entries = data.entries.toList();

    if (entries.isEmpty) {
      return const Center(child: Text('No chart data available'));
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          barGroups: List.generate(entries.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: entries[index].value.toDouble(),
                  width: 18,
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= entries.length) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      entries[index].key,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }

  Widget buildTopRankedList(List<Map<String, dynamic>> athletes) {
    if (athletes.isEmpty) {
      return const Center(child: Text('No ranked athletes yet'));
    }

    return Column(
      children: List.generate(athletes.length, (index) {
        final athlete = athletes[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('#${index + 1}'),
            ),
            title: Text(athlete['full_name'] ?? 'Unknown'),
            subtitle: Text(
              '${athlete['weight_class'] ?? ''} • ${athlete['athlete_type'] ?? ''}',
            ),
            trailing: Text(
              '${athlete['ranking_points'] ?? 0} pts',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Dashboard'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          service.getAthleteCount(),
          service.getGymCount(),
          service.getCoachCount(),
          service.getEventCount(),
          service.getTopRankedAthletes(),
          service.getAllAthletes(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Dashboard error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data as List;

          final athleteCount = data[0] as int;
          final gymCount = data[1] as int;
          final coachCount = data[2] as int;
          final eventCount = data[3] as int;
          final topAthletes = data[4] as List<Map<String, dynamic>>;
          final allAthletes = data[5] as List<Map<String, dynamic>>;

          final proCount = allAthletes
              .where((a) => a['athlete_type'] == 'Professional')
              .length;

          final amateurCount = allAthletes
              .where((a) => a['athlete_type'] == 'Amateur')
              .length;

          final totalWins = totalByField(allAthletes, 'wins');
          final totalLosses = totalByField(allAthletes, 'losses');
          final totalDraws = totalByField(allAthletes, 'draws');

          final weightClassData =
              countByField(allAthletes, 'weight_class');

          final athleteTypeData =
              countByField(allAthletes, 'athlete_type');

          return SingleChildScrollView(
            child: Column(
              children: [
                sectionTitle('Platform Overview'),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(12),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    statCard(
                      'Athletes',
                      athleteCount.toString(),
                      Icons.person,
                    ),
                    statCard(
                      'Gyms',
                      gymCount.toString(),
                      Icons.fitness_center,
                    ),
                    statCard(
                      'Coaches',
                      coachCount.toString(),
                      Icons.sports_mma,
                    ),
                    statCard(
                      'Events',
                      eventCount.toString(),
                      Icons.event,
                    ),
                  ],
                ),

                sectionTitle('Athlete Types'),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(12),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    statCard(
                      'Professional',
                      proCount.toString(),
                      Icons.workspace_premium,
                    ),
                    statCard(
                      'Amateur',
                      amateurCount.toString(),
                      Icons.sports,
                    ),
                  ],
                ),

                sectionTitle('Fight Record Totals'),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(12),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                  children: [
                    statCard(
                      'Wins',
                      totalWins.toString(),
                      Icons.emoji_events,
                    ),
                    statCard(
                      'Losses',
                      totalLosses.toString(),
                      Icons.close,
                    ),
                    statCard(
                      'Draws',
                      totalDraws.toString(),
                      Icons.remove,
                    ),
                  ],
                ),

                sectionTitle('Top 10 Ranked Athletes'),
                buildTopRankedList(topAthletes),

                sectionTitle('Athletes by Type'),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: buildBarChart(athleteTypeData),
                ),

                sectionTitle('Athletes by Weight Class'),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: buildBarChart(weightClassData),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}