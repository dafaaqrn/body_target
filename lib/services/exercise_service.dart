import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_entry.dart';

class ExerciseService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('exercise_entries');

  Future<void> addExercise({
    required String type,
    required double distanceKm,
    required int durationMinutes,
    required DateTime date,
  }) async {
    await _collection.add({
      'type': type,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'date': date.toIso8601String(),
    });
  }

  Stream<List<ExerciseEntry>> getExerciseEntries() {
    return _collection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExerciseEntry.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }
}