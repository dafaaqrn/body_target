import 'package:flutter/material.dart';
import '../models/weight_entry.dart';
import '../services/weight_service.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final WeightService _weightService = WeightService();
  final TextEditingController _weightController = TextEditingController();

  // Fungsi ini dipanggil saat tombol "Simpan" ditekan
  void _saveWeight() async {
    final text = _weightController.text;
    if (text.isEmpty) return;

    final weight = double.tryParse(text);
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan angka yang valid')),
      );
      return;
    }

    await _weightService.addWeight(weight, DateTime.now());
    _weightController.clear(); // kosongkan input setelah tersimpan

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berat badan tersimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berat Badan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Berat badan (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveWeight,
                  child: const Text('Simpan'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bagian riwayat (list)
            Expanded(
              child: StreamBuilder<List<WeightEntry>>(
                stream: _weightService.getWeightEntries(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Belum ada data. Yuk input berat badan pertama!'));
                  }

                  final entries = snapshot.data!;
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.monitor_weight),
                          title: Text('${entry.weightKg} kg'),
                          subtitle: Text(
                            '${entry.date.day}/${entry.date.month}/${entry.date.year}',
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
      ),
    );
  }
}