import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/weight_entry.dart';

class WeightService {
  // Ini "pintu masuk" ke database Firestore
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('weight_entries');

  // Fungsi untuk MENYIMPAN data berat badan baru
  Future<void> addWeight(double weightKg, DateTime date) async {
    await _collection.add({
      'weightKg': weightKg,
      'date': date.toIso8601String(),
    });
  }

  // Fungsi untuk MENGAMBIL semua data berat badan, urut dari terbaru
  // Stream artinya data ini akan otomatis update real-time kalau ada perubahan
  Stream<List<WeightEntry>> getWeightEntries() {
    return _collection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return WeightEntry.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }
}