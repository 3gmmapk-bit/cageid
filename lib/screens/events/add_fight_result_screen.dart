import 'package:flutter/material.dart';

import '../../services/fight_service.dart';

class AddFightResultScreen extends StatefulWidget {
  final Map<String, dynamic> fight;

  const AddFightResultScreen({
    super.key,
    required this.fight,
  });

  @override
  State<AddFightResultScreen> createState() => _AddFightResultScreenState();
}

class _AddFightResultScreenState extends State<AddFightResultScreen> {
  final FightService fightService = FightService();

  String? winnerId;
  String method = 'Decision';

  final roundController = TextEditingController();
  final timeController = TextEditingController();

  bool isSaving = false;

  String fighterName(Map<String, dynamic>? fighter) {
    if (fighter == null) return 'Unknown';
    return fighter['full_name'] ?? 'Unknown';
  }

  Future<void> saveResult() async {
    if (winnerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select winner')),
      );
      return;
    }

    final redId = widget.fight['fighter_red'];
    final blueId = widget.fight['fighter_blue'];
    final loserId = winnerId == redId ? blueId : redId;

    setState(() => isSaving = true);

    try {
      await fightService.addFightResult(
        fightId: widget.fight['id'],
        winnerId: winnerId!,
        loserId: loserId,
        method: method,
        round: int.tryParse(roundController.text.trim()) ?? 1,
        fightTime: timeController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving result: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    roundController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final redName = fighterName(widget.fight['red']);
    final blueName = fighterName(widget.fight['blue']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fight Result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('$redName vs $blueName'),
                subtitle: const Text('Select winner and method'),
              ),
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: winnerId,
              decoration: const InputDecoration(
                labelText: 'Winner',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: widget.fight['fighter_red'],
                  child: Text(redName),
                ),
                DropdownMenuItem(
                  value: widget.fight['fighter_blue'],
                  child: Text(blueName),
                ),
              ],
              onChanged: (value) {
                setState(() => winnerId = value);
              },
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: method,
              decoration: const InputDecoration(
                labelText: 'Method',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Decision', child: Text('Decision')),
                DropdownMenuItem(value: 'KO/TKO', child: Text('KO/TKO')),
                DropdownMenuItem(value: 'Submission', child: Text('Submission')),
                DropdownMenuItem(value: 'Draw', child: Text('Draw')),
                DropdownMenuItem(value: 'No Contest', child: Text('No Contest')),
              ],
              onChanged: (value) {
                setState(() => method = value!);
              },
            ),

            const SizedBox(height: 14),

            TextField(
              controller: roundController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Round',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time e.g. 03:25',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveResult,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Result'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}