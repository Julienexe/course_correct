// lib/models/student_progress.dart
import 'algorithm_practice_result.dart';

class StudentProgress {
  final String studentId;
  final String name;
  int progress;
  List<AlgorithmPracticeResult> practiceResults;

  StudentProgress({
    required this.studentId,
    required this.name,
    this.progress = 0,
    this.practiceResults = const [],
  });
}
