// Model untuk mencatat satu sesi olahraga/lari

class ExerciseEntry {
  final String id;
  final String type; // jenis olahraga, misal: "Lari", "Jalan Cepat"
  final double distanceKm; // jarak dalam km, misal: 5.0
  final int durationMinutes; // durasi dalam menit
  final DateTime date;

  ExerciseEntry({
    required this.id,
    required this.type,
    required this.distanceKm,
    required this.durationMinutes,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'date': date.toIso8601String(),
    };
  }

  factory ExerciseEntry.fromMap(String id, Map<String, dynamic> map) {
    return ExerciseEntry(
      id: id,
      type: map['type'] as String,
      distanceKm: (map['distanceKm'] as num).toDouble(),
      durationMinutes: map['durationMinutes'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }
}