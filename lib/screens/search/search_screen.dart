import 'package:flutter/material.dart';

import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import '../athletes/athlete_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AthleteService athleteService = AthleteService();
  final searchController = TextEditingController();

  String selectedWeightClass = 'All';
  String selectedCountry = 'All';
  String selectedAthleteType = 'All';
  String selectedGym = 'All';
  String selectedCoach = 'All';

  bool isLoading = false;
  List<Athlete> results = [];

  final List<String> weightClasses = [
    'All',
    'Atomweight',
    'Strawweight',
    'Flyweight',
    'Bantamweight',
    'Featherweight',
    'Lightweight',
    'Welterweight',
    'Middleweight',
    'Light Heavyweight',
    'Heavyweight',
  ];

  final List<String> countries = [
    'All',
    'Pakistan',
    'India',
    'Afghanistan',
    'Bangladesh',
    'UAE',
  ];

  final List<String> athleteTypes = [
    'All',
    'Amateur',
    'Professional',
  ];

  final List<String> gyms = [
    'All',
    '3G MMA',
    'Fight Fortress',
    'Pakido',
    'K7',
  ];

  final List<String> coaches = [
    'All',
    'Ovais Shah',
    'Nadeem Akhter',
    'Aleem',
  ];

  Future<void> runSearch() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await athleteService.advancedSearchAthletes(
        searchText: searchController.text.trim(),
        weightClass: selectedWeightClass,
        country: selectedCountry,
        athleteType: selectedAthleteType,
        gym: selectedGym,
        coach: selectedCoach,
      );

      if (!mounted) return;

      setState(() {
        results = data;
      });
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

  Widget buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;

          onChanged(value);
          runSearch();
        },
      ),
    );
  }

  Widget buildAthleteCard(Athlete athlete) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(
          athlete.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${athlete.nickname}\n'
          '${athlete.weightClass} • ${athlete.athleteType} • ${athlete.country}\n'
          '${athlete.gym} • ${athlete.coach}',
        ),
        isThreeLine: true,
        trailing: Text(
          '${athlete.rankingPoints} pts',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
  }

  void resetFilters() {
    setState(() {
      searchController.clear();
      selectedWeightClass = 'All';
      selectedCountry = 'All';
      selectedAthleteType = 'All';
      selectedGym = 'All';
      selectedCoach = 'All';
      results = [];
    });

    runSearch();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      runSearch();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
        actions: [
          IconButton(
            onPressed: resetFilters,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search athlete name or nickname',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => runSearch(),
                  ),

                  const SizedBox(height: 10),

                  buildDropdown(
                    label: 'Weight Class',
                    value: selectedWeightClass,
                    items: weightClasses,
                    onChanged: (value) {
                      selectedWeightClass = value;
                    },
                  ),

                  buildDropdown(
                    label: 'Country',
                    value: selectedCountry,
                    items: countries,
                    onChanged: (value) {
                      selectedCountry = value;
                    },
                  ),

                  buildDropdown(
                    label: 'Athlete Type',
                    value: selectedAthleteType,
                    items: athleteTypes,
                    onChanged: (value) {
                      selectedAthleteType = value;
                    },
                  ),

                  buildDropdown(
                    label: 'Gym',
                    value: selectedGym,
                    items: gyms,
                    onChanged: (value) {
                      selectedGym = value;
                    },
                  ),

                  buildDropdown(
                    label: 'Coach',
                    value: selectedCoach,
                    items: coaches,
                    onChanged: (value) {
                      selectedCoach = value;
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : results.isEmpty
                    ? const Center(
                        child: Text('No athletes found'),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return buildAthleteCard(results[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}