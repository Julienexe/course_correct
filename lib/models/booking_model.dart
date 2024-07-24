class Booking {
  final String tutorId;
  final String studentId;
  final DateTime startTime;
  final DateTime endTime;

  Booking({
    required this.tutorId,
    required this.studentId,
    required this.startTime,
    required this.endTime,
  });

  // Add methods to convert to/from Firestore
}
