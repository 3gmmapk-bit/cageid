import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final EventService service = EventService();

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final venueController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController(text: 'Pakistan');

  bool isSaving = false;

  Future<void> saveEvent() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event name is required')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await service.addEvent(
        name: nameController.text.trim(),
        eventDate: dateController.text.trim(),
        venue: venueController.text.trim(),
        city: cityController.text.trim(),
        country: countryController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Widget buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    venueController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(nameController, 'Event Name'),
            buildField(dateController, 'Date YYYY-MM-DD'),
            buildField(venueController, 'Venue'),
            buildField(cityController, 'City'),
            buildField(countryController, 'Country'),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveEvent,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}