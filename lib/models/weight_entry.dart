// Model ini adalah "cetakan" untuk satu data berat badan.
// Setiap kali Anda input berat badan, datanya akan berbentuk seperti ini.

class WeightEntry {
  final String id; // ID unik, nanti diisi otomatis oleh Firestore
  final double weightKg; // berat badan dalam kg, misal: 85.0
  final DateTime date; // tanggal pencatatan

  WeightEntry({
    required this.id,
    required this.weightKg,
    required this.date,
  });

  // Mengubah data Dart menjadi Map, supaya bisa disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'weightKg': weightKg,
      'date': date.toIso8601String(),
    };
  }

  // Kebalikannya: mengubah data dari Firestore menjadi objek WeightEntry
  factory WeightEntry.fromMap(String id, Map<String, dynamic> map) {
    return WeightEntry(
      id: id,
      weightKg: (map['weightKg'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }
}