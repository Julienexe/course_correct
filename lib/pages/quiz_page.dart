import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  final String topic;

  QuizPage({required this.topic});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestions(widget.topic);
  }

  Future<void> fetchQuestions(String topic) async {
    // Mock API response
    final response = await Future.delayed(
      Duration(seconds: 2),
      () => http.Response(jsonEncode(mockQuizData(topic)), 200),
    );

    if (response.statusCode == 200) {
      setState(() {
        questions = (jsonDecode(response.body) as List)
            .map((data) => Question.fromJson(data))
            .toList();
        isLoading = false;
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz on ${widget.topic}'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (currentQuestionIndex >= questions.length) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz on ${widget.topic}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'You got $correctAnswers out of ${questions.length} correct.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              if (correctAnswers >= questions.length / 2)
                Text(
                  'You can continue with the course.',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                )
              else
                Text(
                  'We recommend you to review the previous level.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz on ${widget.topic}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              questions[currentQuestionIndex].question,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ...questions[currentQuestionIndex].options.map((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: questions[currentQuestionIndex].selectedOption,
                  onChanged: (value) {
                    setState(() {
                      questions[currentQuestionIndex].selectedOption = value;
                    });
                  },
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (questions[currentQuestionIndex].selectedOption ==
                        questions[currentQuestionIndex].correctAnswer) {
                      correctAnswers++;
                    }
                    currentQuestionIndex++;
                  });
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  String? selectedOption;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.selectedOption,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}

List<Map<String, dynamic>> mockQuizData(String topic) {
  // Mock quiz data based on the topic
  if (topic == 'Web Development') {
    return [
      {
        'question': 'What is HTML?',
        'options': [
          'A programming language',
          'A markup language',
          'A database',
          'An operating system'
        ],
        'correctAnswer': 'A markup language',
      },
      {
        'question': 'What is CSS used for?',
        'options': [
          'Styling web pages',
          'Programming logic',
          'Database management',
          'Server configuration'
        ],
        'correctAnswer': 'Styling web pages',
      },
    ];
  } else if (topic == 'Data Structures & Algorithms') {
    return [
      {
        'question': 'What is a binary tree?',
        'options': [
          'A tree with binary data',
          'A tree with two children nodes',
          'A tree with multiple roots',
          'A tree that balances itself'
        ],
        'correctAnswer': 'A tree with two children nodes',
      },
      {
        'question': 'What is the time complexity of binary search?',
        'options': ['O(n)', 'O(n^2)', 'O(log n)', 'O(1)'],
        'correctAnswer': 'O(log n)',
      },
    ];
  } else if (topic == 'Programming Basics') {
    return [
      {
        'question': 'What is a variable?',
        'options': [
          'A storage location',
          'A data type',
          'A programming construct',
          'A function'
        ],
        'correctAnswer': 'A storage location',
      },
      {
        'question': 'What is a loop?',
        'options': [
          'A conditional statement',
          'A function call',
          'A repeated execution of code',
          'A variable declaration'
        ],
        'correctAnswer': 'A repeated execution of code',
      },
    ];
  }
  return [];
}
