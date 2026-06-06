import 'package:flutter/material.dart';
import '../profile/user_profile_screen.dart';
import '../../services/auth_service.dart';
import '../../widgets/home_card.dart';

import '../athletes/athletes_screen.dart';
import '../rankings/rankings_screen.dart';
import '../events/events_screen.dart';
import '../gyms/gyms_screen.dart';
import '../coaches/coaches_screen.dart';
import '../search/search_screen.dart';
import '../media/media_screen.dart';
import '../news/news_screen.dart';
import '../dashboard/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService authService = AuthService();

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> logout() async {
    await authService.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CageID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          children: [
            HomeCard(
              title: 'Athletes',
              icon: Icons.person,
              onTap: () => openScreen(
                context,
                const AthletesScreen(),
              ),
            ),
            HomeCard(
              title: 'Rankings',
              icon: Icons.leaderboard,
              onTap: () => openScreen(
                context,
                const RankingsScreen(),
              ),
            ),
            HomeCard(
              title: 'Profile',
              icon: Icons.person,
              onTap: () => openScreen(
                context,
                const UserProfileScreen(),
              ),
            ),
            HomeCard(
              title: 'Events',
              icon: Icons.event,
              onTap: () => openScreen(
                context,
                const EventsScreen(),
              ),
            ),
            HomeCard(
              title: 'Search',
              icon: Icons.search,
              onTap: () => openScreen(
                context,
                const SearchScreen(),
              ),
            ),
            HomeCard(
              title: 'Gyms',
              icon: Icons.fitness_center,
              onTap: () => openScreen(
                context,
                const GymsScreen(),
              ),
            ),
            HomeCard(
              title: 'Coaches',
              icon: Icons.sports_mma,
              onTap: () => openScreen(
                context,
                const CoachesScreen(),
              ),
            ),
            HomeCard(
              title: 'Media',
              icon: Icons.photo_library,
              onTap: () => openScreen(
                context,
                const MediaScreen(),
              ),
            ),
            HomeCard(
              title: 'News',
              icon: Icons.article,
              onTap: () => openScreen(
                context,
                const NewsScreen(),
              ),
            ),
            HomeCard(
              title: 'Dashboard',
              icon: Icons.analytics,
              onTap: () => openScreen(
                context,
                const DashboardScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}