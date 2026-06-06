import '../search/search_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/home_card.dart';
import '../athletes/athletes_screen.dart';
import '../rankings/rankings_screen.dart';
import '../events/events_screen.dart';
import '../gyms/gyms_screen.dart';
import '../coaches/coaches_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CageID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            HomeCard(
              title: 'Search',
              icon: Icons.search,
              onTap: () => openScreen(context, const SearchScreen()),
            ),
            HomeCard(
              title: 'Athletes',
              icon: Icons.person,
              onTap: () => openScreen(context, const AthletesScreen()),
            ),
            HomeCard(
              title: 'Rankings',
              icon: Icons.leaderboard,
              onTap: () => openScreen(context, const RankingsScreen()),
            ),
            HomeCard(
              title: 'Events',
              icon: Icons.event,
              onTap: () => openScreen(context, const EventsScreen()),
            ),
            HomeCard(
              title: 'Gyms',
              icon: Icons.fitness_center,
              onTap: () => openScreen(context, const GymsScreen()),
            ),
            HomeCard(
              title: 'Coaches',
              icon: Icons.sports_mma,
              onTap: () => openScreen(context, const CoachesScreen()),
            ),
          ],
        ),
      ),
    );
  }
}