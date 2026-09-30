import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  TimeOfDay _exerciseTime = const TimeOfDay(hour: 17, minute: 0); // default jam 5 sore

  // ID unik untuk pengingat olahraga (dipakai supaya bisa di-cancel/update nanti)
  static const int _exerciseReminderId = 1;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _exerciseTime,
    );
    if (picked != null) {
      setState(() {
        _exerciseTime = picked;
      });
    }
  }

    Future<void> _saveReminder() async {

    try {
      await _notificationService.scheduleDailyNotification(
        id: _exerciseReminderId,
        title: 'Waktunya Olahraga! 🏃',
        body: 'Ayo gerak sedikit hari ini, konsisten itu kuncinya.',
        hour: _exerciseTime.hour,
        minute: _exerciseTime.minute,
      );
    } catch (e) {
      print('ERROR saat menjadwalkan notifikasi: $e'); // sementara, untuk debug
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pengingat diatur setiap jam ${_exerciseTime.format(context)}',
          ),
        ),
      );
    }
  }

  Future<void> _cancelReminder() async {
    await _notificationService.cancelNotification(_exerciseReminderId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengingat dimatikan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Pengingat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengingat Olahraga Harian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: Text('Jam: ${_exerciseTime.format(context)}'),
              trailing: const Icon(Icons.edit),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveReminder,
                    child: const Text('Aktifkan Pengingat'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancelReminder,
                    child: const Text('Matikan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}