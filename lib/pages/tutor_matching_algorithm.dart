//import firebase firestore

class TutorModelMatcher {
  final List<Map> tutors;

  TutorModelMatcher({required this.tutors});

  List<Map> matchTutors(Map<String, int> studentScoresByTopic) {
    List<Map<String, dynamic>> tutorsScores = tutors.map((tutors) {
      var availabilityScore = tutors["availability"] * 50;
      double specialtyScore = _calculateSpecialtyScore(
              tutors["subtopics"], studentScoresByTopic) *
          30;
      double experienceScore = (tutors["experience"] / 10) * 10;

      double totalScore = availabilityScore + specialtyScore + experienceScore;
      return {'Tutor': tutors["name"], 'score': totalScore, 'email': tutors["email"]};
    }).toList();

    tutorsScores.sort((a, b) => b['score'].compareTo(a['score']));

    return tutorsScores;
  }

  double _calculateSpecialtyScore(
      Map specialties, Map<String, int> studentScoresByTopic) {
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




