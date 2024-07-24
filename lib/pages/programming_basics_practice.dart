import 'dart:math';
import 'package:flutter/material.dart';
import 'tutor_dashboard.dart';

class ProgrammingBasicsPracticePage extends StatefulWidget {
  final String studentId;

  ProgrammingBasicsPracticePage({required this.studentId});

  @override
  _ProgrammingBasicsPracticePageState createState() =>
      _ProgrammingBasicsPracticePageState();
}

class _ProgrammingBasicsPracticePageState
    extends State<ProgrammingBasicsPracticePage> {
  final List<Map<String, dynamic>> _allQuestions = [
    // Topic 1: Variables
    {
      'question': 'What is a variable?',
      'answers': [
        'A storage location in memory',
        'A type of function',
        'A collection of elements',
        'A special type of loop'
      ],
      'correctAnswer': 'A storage location in memory',
      'topic': 'Variables'
    },
    {
      'question': 'Which keyword is used to declare a variable in Java?',
      'answers': ['var', 'let', 'int', 'double'],
      'correctAnswer': 'int',
      'topic': 'Variables'
    },
    {
      'question': 'What is the purpose of a variable in programming?',
      'answers': [
        'To store data values',
        'To create loops',
        'To define classes',
        'To call functions'
      ],
      'correctAnswer': 'To store data values',
      'topic': 'Variables'
    },
    {
      'question': 'What is the correct syntax to declare a variable in Python?',
      'answers': ['var x = 5', 'x = 5', 'int x = 5', 'let x = 5'],
      'correctAnswer': 'x = 5',
      'topic': 'Variables'
    },
    {
      'question': 'Which of the following is a valid variable name?',
      'answers': ['2var', 'my-var', 'var_1', 'var 1'],
      'correctAnswer': 'var_1',
      'topic': 'Variables'
    },
    {
      'question': 'What type of data can a variable hold?',
      'answers': ['Numbers', 'Strings', 'Booleans', 'All of the above'],
      'correctAnswer': 'All of the above',
      'topic': 'Variables'
    },
    {
      'question': 'How do you declare a constant variable in JavaScript?',
      'answers': ['var', 'let', 'const', 'constant'],
      'correctAnswer': 'const',
      'topic': 'Variables'
    },
    {
      'question': 'Which keyword is used to declare a variable in C++?',
      'answers': ['int', 'var', 'let', 'double'],
      'correctAnswer': 'int',
      'topic': 'Variables'
    },
    {
      'question':
          'What is the default value of a variable of type boolean in Java?',
      'answers': ['true', 'false', '0', 'null'],
      'correctAnswer': 'false',
      'topic': 'Variables'
    },
    {
      'question':
          'Which of the following is an invalid variable declaration in JavaScript?',
      'answers': [
        'var 1stVariable',
        'var firstVariable',
        'let firstVariable',
        'const firstVariable'
      ],
      'correctAnswer': 'var 1stVariable',
      'topic': 'Variables'
    },
    // Topic 2: Control Structures
    {
      'question': 'What is a control structure?',
      'answers': [
        'A block of code that determines the flow of the program',
        'A type of data structure',
        'A way to define functions',
        'A method to handle exceptions'
      ],
      'correctAnswer':
          'A block of code that determines the flow of the program',
      'topic': 'Control Structures'
    },
    {
      'question':
          'Which of the following is a conditional statement in Python?',
      'answers': ['if', 'for', 'while', 'def'],
      'correctAnswer': 'if',
      'topic': 'Control Structures'
    },
    {
      'question': 'What is the syntax of a for loop in Java?',
      'answers': [
        'for(int i = 0; i < 10; i++)',
        'for i in range(10)',
        'for i = 1 to 10',
        'for(i < 10; i++)'
      ],
      'correctAnswer': 'for(int i = 0; i < 10; i++)',
      'topic': 'Control Structures'
    },
    {
      'question': 'Which keyword is used to exit a loop prematurely?',
      'answers': ['break', 'exit', 'stop', 'terminate'],
      'correctAnswer': 'break',
      'topic': 'Control Structures'
    },
    {
      'question': 'How do you start a switch statement in JavaScript?',
      'answers': [
        'switch(expression)',
        'case(expression)',
        'if(expression)',
        'choose(expression)'
      ],
      'correctAnswer': 'switch(expression)',
      'topic': 'Control Structures'
    },
    {
      'question': 'Which loop is guaranteed to execute at least once?',
      'answers': [
        'for loop',
        'while loop',
        'do-while loop',
        'None of the above'
      ],
      'correctAnswer': 'do-while loop',
      'topic': 'Control Structures'
    },
    {
      'question': 'What does the continue statement do in a loop?',
      'answers': [
        'Skips the current iteration and moves to the next one',
        'Exits the loop',
        'Restarts the loop',
        'None of the above'
      ],
      'correctAnswer': 'Skips the current iteration and moves to the next one',
      'topic': 'Control Structures'
    },
    {
      'question': 'What is the purpose of an else statement?',
      'answers': [
        'To specify a block of code to be executed if a condition is false',
        'To start a loop',
        'To define a function',
        'To handle exceptions'
      ],
      'correctAnswer':
          'To specify a block of code to be executed if a condition is false',
      'topic': 'Control Structures'
    },
    {
      'question':
          'Which control structure is used to handle multiple conditions?',
      'answers': ['if-else', 'switch', 'for loop', 'while loop'],
      'correctAnswer': 'switch',
      'topic': 'Control Structures'
    },
    {
      'question': 'What is the purpose of a while loop?',
      'answers': [
        'To execute a block of code as long as a condition is true',
        'To execute a block of code a specific number of times',
        'To define a function',
        'To handle exceptions'
      ],
      'correctAnswer':
          'To execute a block of code as long as a condition is true',
      'topic': 'Control Structures'
    },
    // Topic 3: Functions
    {
      'question': 'What is a function?',
      'answers': [
        'A block of code that performs a specific task',
        'A type of variable',
        'A loop structure',
        'A conditional statement'
      ],
      'correctAnswer': 'A block of code that performs a specific task',
      'topic': 'Functions'
    },
    {
      'question': 'How do you declare a function in Python?',
      'answers': [
        'def myFunction():',
        'function myFunction()',
        'myFunction() =>',
        'function: myFunction()'
      ],
      'correctAnswer': 'def myFunction():',
      'topic': 'Functions'
    },
    {
      'question': 'What is a return statement?',
      'answers': [
        'A statement that ends the function and optionally returns a value',
        'A statement that starts a loop',
        'A statement that handles exceptions',
        'A statement that declares a variable'
      ],
      'correctAnswer':
          'A statement that ends the function and optionally returns a value',
      'topic': 'Functions'
    },
    {
      'question': 'Which keyword is used to define a function in JavaScript?',
      'answers': ['def', 'func', 'function', 'defun'],
      'correctAnswer': 'function',
      'topic': 'Functions'
    },
    {
      'question': 'How do you call a function in Java?',
      'answers': [
        'myFunction();',
        'call myFunction()',
        'myFunction[]',
        'myFunction{}'
      ],
      'correctAnswer': 'myFunction();',
      'topic': 'Functions'
    },
    {
      'question': 'What is a parameter in a function?',
      'answers': [
        'A variable used to pass information to the function',
        'A loop structure',
        'A conditional statement',
        'A type of exception'
      ],
      'correctAnswer': 'A variable used to pass information to the function',
      'topic': 'Functions'
    },
    {
      'question': 'How do you return a value from a function in JavaScript?',
      'answers': [
        'return value;',
        'output value;',
        'result value;',
        'send value;'
      ],
      'correctAnswer': 'return value;',
      'topic': 'Functions'
    },
    {
      'question': 'What is the purpose of a function prototype in C++?',
      'answers': [
        'To declare the function before defining it',
        'To start a loop',
        'To handle exceptions',
        'To define a variable'
      ],
      'correctAnswer': 'To declare the function before defining it',
      'topic': 'Functions'
    },
    {
      'question': 'Which keyword is used to define a function in Java?',
      'answers': ['def', 'func', 'function', 'void'],
      'correctAnswer': 'void',
      'topic': 'Functions'
    },
    {
      'question': 'How do you pass an argument to a function in Python?',
      'answers': [
        'myFunction(arg)',
        'myFunction[arg]',
        'myFunction{arg}',
        'myFunction arg'
      ],
      'correctAnswer': 'myFunction(arg)',
      'topic': 'Functions'
    },
    // Topic 4: Arrays
    {
      'question': 'What is an array?',
      'answers': [
        'A collection of elements of the same type',
        'A type of function',
        'A loop structure',
        'A conditional statement'
      ],
      'correctAnswer': 'A collection of elements of the same type',
      'topic': 'Arrays'
    },
    {
      'question': 'How do you declare an array in Java?',
      'answers': [
        'int[] arr;',
        'array int arr;',
        'arr = [1, 2, 3];',
        'arr int[];'
      ],
      'correctAnswer': 'int[] arr;',
      'topic': 'Arrays'
    },
    {
      'question': 'What is the index of the first element in an array?',
      'answers': ['0', '1', '2', '3'],
      'correctAnswer': '0',
      'topic': 'Arrays'
    },
    {
      'question': 'How do you access the third element in an array in Python?',
      'answers': ['arr[2]', 'arr[3]', 'arr(2)', 'arr(3)'],
      'correctAnswer': 'arr[2]',
      'topic': 'Arrays'
    },
    {
      'question':
          'Which of the following is a valid array declaration in JavaScript?',
      'answers': [
        'let arr = [1, 2, 3];',
        'array arr = [1, 2, 3];',
        'arr = array(1, 2, 3);',
        'arr = 1, 2, 3;'
      ],
      'correctAnswer': 'let arr = [1, 2, 3];',
      'topic': 'Arrays'
    },
    {
      'question': 'What is the length of the array [1, 2, 3, 4, 5]?',
      'answers': ['5', '4', '6', '10'],
      'correctAnswer': '5',
      'topic': 'Arrays'
    },
    {
      'question': 'How do you iterate over an array in C++?',
      'answers': [
        'for(int i = 0; i < arr.size(); i++)',
        'for i in arr',
        'foreach (int i in arr)',
        'while(i < arr.size())'
      ],
      'correctAnswer': 'for(int i = 0; i < arr.size(); i++)',
      'topic': 'Arrays'
    },
    {
      'question': 'How do you declare a multi-dimensional array in Java?',
      'answers': [
        'int[][] arr;',
        'array[][] arr;',
        'int arr[][];',
        'arr int[][];'
      ],
      'correctAnswer': 'int[][] arr;',
      'topic': 'Arrays'
    },
    {
      'question':
          'How do you add an element to the end of an array in JavaScript?',
      'answers': [
        'arr.push(element);',
        'arr.add(element);',
        'arr.append(element);',
        'arr.insert(element);'
      ],
      'correctAnswer': 'arr.push(element);',
      'topic': 'Arrays'
    },
    {
      'question':
          'What is the purpose of the length property of an array in Java?',
      'answers': [
        'To determine the number of elements in the array',
        'To define a loop',
        'To declare a variable',
        'To handle exceptions'
      ],
      'correctAnswer': 'To determine the number of elements in the array',
      'topic': 'Arrays'
    },
    // Topic 5: Strings
    {
      'question': 'What is a string?',
      'answers': [
        'A sequence of characters',
        'A type of variable',
        'A loop structure',
        'A conditional statement'
      ],
      'correctAnswer': 'A sequence of characters',
      'topic': 'Strings'
    },
    {
      'question': 'How do you declare a string in Java?',
      'answers': ['String str;', 'string str;', 'str = "text";', 'text str;'],
      'correctAnswer': 'String str;',
      'topic': 'Strings'
    },
    {
      'question': 'How do you concatenate strings in JavaScript?',
      'answers': ['str1 + str2', 'str1 . str2', 'str1 & str2', 'str1 % str2'],
      'correctAnswer': 'str1 + str2',
      'topic': 'Strings'
    },
    {
      'question':
          'Which of the following is a valid string declaration in Python?',
      'answers': [
        'str = "text"',
        'string str = "text"',
        'text str = "text"',
        'str = \'text\''
      ],
      'correctAnswer': 'str = "text"',
      'topic': 'Strings'
    },
    {
      'question': 'How do you find the length of a string in C++?',
      'answers': ['str.length()', 'str.size()', 'str.length', 'str.count()'],
      'correctAnswer': 'str.length()',
      'topic': 'Strings'
    },
    {
      'question': 'What is the purpose of the substring method in Java?',
      'answers': [
        'To extract a portion of a string',
        'To declare a variable',
        'To start a loop',
        'To handle exceptions'
      ],
      'correctAnswer': 'To extract a portion of a string',
      'topic': 'Strings'
    },
    {
      'question': 'How do you convert a string to uppercase in Python?',
      'answers': [
        'str.upper()',
        'str.toUpperCase()',
        'str.upper',
        'str.to_upper()'
      ],
      'correctAnswer': 'str.upper()',
      'topic': 'Strings'
    },
    {
      'question':
          'How do you check if a string contains a substring in JavaScript?',
      'answers': [
        'str.includes(substr)',
        'str.contains(substr)',
        'str.has(substr)',
        'str.find(substr)'
      ],
      'correctAnswer': 'str.includes(substr)',
      'topic': 'Strings'
    },
    {
      'question': 'How do you compare two strings in Java?',
      'answers': [
        'str1.equals(str2)',
        'str1 == str2',
        'str1.compareTo(str2)',
        'str1.compare(str2)'
      ],
      'correctAnswer': 'str1.equals(str2)',
      'topic': 'Strings'
    },
    {
      'question': 'What is the purpose of the split method in JavaScript?',
      'answers': [
        'To split a string into an array of substrings',
        'To declare a variable',
        'To start a loop',
        'To handle exceptions'
      ],
      'correctAnswer': 'To split a string into an array of substrings',
      'topic': 'Strings'
    },

    // Add more questions for each topic
  ];

  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  Map<String, int> scoresByTopic = {};
  Map<String, int> questionsPerTopic = {};

  @override
  void initState() {
    super.initState();
    _questions = _selectRandomQuestions(15);
    _initializeScoresByTopic();
    _initializeQuestionsPerTopic();
  }

  void _initializeScoresByTopic() {
    for (var question in _allQuestions) {
      scoresByTopic[question['topic']] = 0;
    }
  }

  void _initializeQuestionsPerTopic() {
    for (var question in _allQuestions) {
      questionsPerTopic[question['topic']] = 3;
    }
  }

  List<Map<String, dynamic>> _selectRandomQuestions(int count) {
    final random = Random();
    final selectedQuestions = <Map<String, dynamic>>[];
    final usedIndexes = <int>{};

    while (selectedQuestions.length < count) {
      final index = random.nextInt(_allQuestions.length);
      if (!usedIndexes.contains(index)) {
        usedIndexes.add(index);
        selectedQuestions.add(_allQuestions[index]);
      }
    }

    return selectedQuestions;
  }

  void _answerQuestion(String answer) {
    String topic = _questions[_currentQuestionIndex]['topic'];
    if (answer == _questions[_currentQuestionIndex]['correctAnswer']) {
      setState(() {
        _score++;
        scoresByTopic[topic] = scoresByTopic[topic]! + 1;
      });
    }

    setState(() {
      _currentQuestionIndex++;
    });

    if (_currentQuestionIndex < _questions.length) {
      _showNextQuestion();
    } else {
      _showScore();
    }
  }

  void _showNextQuestion() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Next Question'),
        content: Text(_questions[_currentQuestionIndex]['question']),
        actions: <Widget>[
          ..._questions[_currentQuestionIndex]['answers'].map((answer) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _answerQuestion(answer);
              },
              child: Text(answer),
            );
          }).toList()
        ],
      ),
    );
  }

  void _showScore() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Practice Completed'),
        content: Text('Your score is $_score/${_questions.length}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorDashboard(
                    studentId: widget.studentId,
                    score: _score,
                    scoresByTopic: scoresByTopic,
                    questionsPerTopic: questionsPerTopic,
                  ),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programming Basics Practice'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showNextQuestion,
          child: Text('Start Practice'),
        ),
      ),
    );
  }
}
