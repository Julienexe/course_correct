class Tutor {
  final String name;
  final double availability; // Percentage of available slots (0-1)
  final Map<String, int> specialties; // Subtopic -> Expertise level (1-5)
  final int experience; // Years of experience

  Tutor(
      {required this.name,
      required this.availability,
      required this.specialties,
      required this.experience});
}

class TutorMatcher {
  final List<Tutor> tutors;

  TutorMatcher({required this.tutors});

  List<Tutor> matchTutors(Map<String, int> studentScoresByTopic) {
    List<Map<String, dynamic>> tutorScores = tutors.map((tutor) {
      double availabilityScore = tutor.availability * 50;
      double specialtyScore =
          _calculateSpecialtyScore(tutor.specialties, studentScoresByTopic) *
              30;
      double experienceScore = (tutor.experience / 10) * 10;

      double totalScore = availabilityScore + specialtyScore + experienceScore;
      return {'tutor': tutor, 'score': totalScore};
    }).toList();

    tutorScores.sort((a, b) => b['score'].compareTo(a['score']));

    return tutorScores
        .map((tutorScore) => tutorScore['tutor'] as Tutor)
        .toList();
  }

  double _calculateSpecialtyScore(
      Map<String, int> specialties, Map<String, int> studentScoresByTopic) {
    double score = 0;
    int matchedTopics = 0;

    studentScoresByTopic.forEach((topic, studentScore) {
      if (specialties.containsKey(topic)) {
        score += specialties[topic]!;
        matchedTopics++;
      }
    });

    return matchedTopics == 0 ? 0 : score / matchedTopics;
  }
}

void main() {
  // Example tutors
  List<Tutor> tutors = [
    Tutor(
        name: 'Tutor A',
        availability: 0.8,
        specialties: {'CSS': 4, 'HTML': 5},
        experience: 5),
    Tutor(
        name: 'Tutor B',
        availability: 0.5,
        specialties: {'JavaScript': 3, 'Node.js': 2},
        experience: 3),
    Tutor(
        name: 'Tutor C',
        availability: 0.9,
        specialties: {'React': 4, 'CSS': 5},
        experience: 8),
  ];

  TutorMatcher matcher = TutorMatcher(tutors: tutors);

  // Example student scores
  Map<String, int> studentScoresByTopic = {
    'CSS': 1,
    'HTML': 2,
    'JavaScript': 3
  };

  List<Tutor> matchedTutors = matcher.matchTutors(studentScoresByTopic);

  // Output the best matched tutor
  print('Best matched tutor: ${matchedTutors.first.name}');
  // Optionally, show other available tutors
}
