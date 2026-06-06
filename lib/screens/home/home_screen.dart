import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/premium_card.dart';

import '../athletes/athletes_screen.dart';
import '../rankings/rankings_screen.dart';
import '../events/events_screen.dart';
import '../gyms/gyms_screen.dart';
import '../coaches/coaches_screen.dart';
import '../search/search_screen.dart';

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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [AppTheme.red, AppTheme.amber],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CageID'),
                Text(
                  'MMA Records & Rankings',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroSection(),
            const SizedBox(height: 20),
            _statsSection(),
            const SizedBox(height: 24),
            const Text(
              'Manage Platform',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: [
                _menuCard(
                  context,
                  title: 'Search',
                  icon: Icons.search,
                  screen: const SearchScreen(),
                ),
                _menuCard(
                  context,
                  title: 'Athletes',
                  icon: Icons.sports_mma,
                  screen: const AthletesScreen(),
                ),
                _menuCard(
                  context,
                  title: 'Rankings',
                  icon: Icons.emoji_events,
                  screen: const RankingsScreen(),
                ),
                _menuCard(
                  context,
                  title: 'Events',
                  icon: Icons.calendar_month,
                  screen: const EventsScreen(),
                ),
                _menuCard(
                  context,
                  title: 'Gyms',
                  icon: Icons.fitness_center,
                  screen: const GymsScreen(),
                ),
                _menuCard(
                  context,
                  title: 'Coaches',
                  icon: Icons.person,
                  screen: const CoachesScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7F1D1D),
            Color(0xFF18181B),
            Color(0xFF09090B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pakistan MMA Database',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Track fighters, rankings, gyms, coaches, events and official MMA records.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsSection() {
    return const Row(
      children: [
        Expanded(
          child: _StatBox(title: 'Athletes', value: 'Active'),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatBox(title: 'Rankings', value: 'Live'),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatBox(title: 'Events', value: 'Updated'),
        ),
      ],
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return PremiumCard(
      onTap: () => openScreen(context, screen),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 38, color: AppTheme.red),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppTheme.amber,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}