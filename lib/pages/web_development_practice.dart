import 'dart:math';
import 'package:flutter/material.dart';
import 'tutor_dashboard.dart';

class WebDevPracticePage extends StatefulWidget {
  final String studentId;

  WebDevPracticePage({required this.studentId});

  @override
  _WebDevPracticePageState createState() => _WebDevPracticePageState();
}

class _WebDevPracticePageState extends State<WebDevPracticePage> {
  final List<Map<String, dynamic>> _allQuestions = [
    // Topic 1: HTML
    {
      'question': 'What does HTML stand for?',
      'answers': [
        'Hyper Text Markup Language',
        'Home Tool Markup Language',
        'Hyperlinks and Text Markup Language',
        'Hyperlinking Text Markup Language'
      ],
      'correctAnswer': 'Hyper Text Markup Language',
      'topic': 'HTML'
    },
    {
      'question':
          'Which HTML element is used to define the title of a document?',
      'answers': ['<meta>', '<title>', '<head>', '<header>'],
      'correctAnswer': '<title>',
      'topic': 'HTML'
    },
    {
      'question': 'Which HTML element is used to create a hyperlink?',
      'answers': ['<a>', '<link>', '<href>', '<hyperlink>'],
      'correctAnswer': '<a>',
      'topic': 'HTML'
    },
    {
      'question':
          'What is the correct HTML element for inserting a line break?',
      'answers': ['<br>', '<break>', '<lb>', '<line>'],
      'correctAnswer': '<br>',
      'topic': 'HTML'
    },
    {
      'question':
          'Which HTML element is used to specify a footer for a document or section?',
      'answers': ['<footer>', '<bottom>', '<section>', '<foot>'],
      'correctAnswer': '<footer>',
      'topic': 'HTML'
    },
    {
      'question': 'What is the correct HTML element for the largest heading?',
      'answers': ['<h1>', '<head>', '<h6>', '<heading>'],
      'correctAnswer': '<h1>',
      'topic': 'HTML'
    },
    {
      'question': 'Which HTML attribute is used to define inline styles?',
      'answers': ['class', 'style', 'font', 'styles'],
      'correctAnswer': 'style',
      'topic': 'HTML'
    },
    {
      'question': 'Which HTML element is used to define important text?',
      'answers': ['<strong>', '<important>', '<b>', '<em>'],
      'correctAnswer': '<strong>',
      'topic': 'HTML'
    },
    {
      'question': 'Which HTML attribute is used to define the inline CSS?',
      'answers': ['class', 'id', 'style', 'font'],
      'correctAnswer': 'style',
      'topic': 'HTML'
    },
    {
      'question':
          'Which HTML element is used to define the body of a document?',
      'answers': ['<body>', '<head>', '<section>', '<main>'],
      'correctAnswer': '<body>',
      'topic': 'HTML'
    },
    // Topic 2: CSS
    {
      'question': 'What does CSS stand for?',
      'answers': [
        'Cascading Style Sheets',
        'Colorful Style Sheets',
        'Computer Style Sheets',
        'Creative Style Sheets'
      ],
      'correctAnswer': 'Cascading Style Sheets',
      'topic': 'CSS'
    },
    {
      'question': 'Which CSS property is used to change the background color?',
      'answers': ['color', 'background-color', 'bgcolor', 'background'],
      'correctAnswer': 'background-color',
      'topic': 'CSS'
    },
    {
      'question':
          'Which CSS property is used to change the text color of an element?',
      'answers': ['color', 'text-color', 'font-color', 'font'],
      'correctAnswer': 'color',
      'topic': 'CSS'
    },
    {
      'question': 'Which CSS property controls the text size?',
      'answers': ['font-size', 'text-size', 'font-style', 'text-style'],
      'correctAnswer': 'font-size',
      'topic': 'CSS'
    },
    {
      'question':
          'Which CSS property is used to change the font of an element?',
      'answers': ['font-family', 'text-font', 'font-style', 'text-style'],
      'correctAnswer': 'font-family',
      'topic': 'CSS'
    },
    {
      'question':
          'Which CSS property is used to add space inside the border of an element?',
      'answers': ['padding', 'margin', 'spacing', 'border-spacing'],
      'correctAnswer': 'padding',
      'topic': 'CSS'
    },
    {
      'question':
          'Which CSS property is used to add space outside the border of an element?',
      'answers': ['padding', 'margin', 'spacing', 'border-spacing'],
      'correctAnswer': 'margin',
      'topic': 'CSS'
    },
    {
      'question':
          'Which CSS property is used to change the alignment of the text?',
      'answers': ['text-align', 'text-style', 'text-align', 'font-align'],
      'correctAnswer': 'text-align',
      'topic': 'CSS'
    },
    {
      'question': 'Which CSS property is used to create rounded corners?',
      'answers': ['border-radius', 'border', 'corner-radius', 'radius'],
      'correctAnswer': 'border-radius',
      'topic': 'CSS'
    },
    {
      'question': 'Which CSS property is used to set the width of an element?',
      'answers': ['width', 'height', 'size', 'element-width'],
      'correctAnswer': 'width',
      'topic': 'CSS'
    },
    // Topic 3: JavaScript
    {
      'question':
          'What is the correct syntax for referring to an external script called "app.js"?',
      'answers': [
        '<script src="app.js">',
        '<script href="app.js">',
        '<script ref="app.js">',
        '<script name="app.js">'
      ],
      'correctAnswer': '<script src="app.js">',
      'topic': 'JavaScript'
    },
    {
      'question': 'Which event occurs when the user clicks on an HTML element?',
      'answers': ['onchange', 'onclick', 'onmouseover', 'onmouseclick'],
      'correctAnswer': 'onclick',
      'topic': 'JavaScript'
    },
    {
      'question': 'How do you write "Hello World" in an alert box?',
      'answers': [
        'alertBox("Hello World");',
        'alert("Hello World");',
        'msg("Hello World");',
        'msgBox("Hello World");'
      ],
      'correctAnswer': 'alert("Hello World");',
      'topic': 'JavaScript'
    },
    {
      'question': 'How do you create a function in JavaScript?',
      'answers': [
        'function myFunction()',
        'function = myFunction()',
        'function:myFunction()',
        'function => myFunction()'
      ],
      'correctAnswer': 'function myFunction()',
      'topic': 'JavaScript'
    },
    {
      'question': 'How do you call a function named "myFunction"?',
      'answers': [
        'call myFunction()',
        'call function myFunction()',
        'myFunction()',
        'run myFunction()'
      ],
      'correctAnswer': 'myFunction()',
      'topic': 'JavaScript'
    },
    {
      'question': 'How do you write an IF statement in JavaScript?',
      'answers': ['if i == 5 then', 'if (i == 5)', 'if i = 5', 'if i = 5 then'],
      'correctAnswer': 'if (i == 5)',
      'topic': 'JavaScript'
    },
    {
      'question': 'How do you write a FOR loop in JavaScript?',
      'answers': [
        'for (i = 0; i <= 5; i++)',
        'for (i <= 5; i++)',
        'for (i = 0; i <= 5)',
        'for i = 1 to 5'
      ],
      'correctAnswer': 'for (i = 0; i <= 5; i++)',
      'topic': 'JavaScript'
    },
    {
      'question': 'How can you add a comment in JavaScript?',
      'answers': [
        '<!--This is a comment-->',
        '//This is a comment',
        '*This is a comment*',
        '#This is a comment'
      ],
      'correctAnswer': '//This is a comment',
      'topic': 'JavaScript'
    },
    {
      'question': 'What is the correct way to write a JavaScript array?',
      'answers': [
        'var colors = ["red", "green", "blue"]',
        'var colors = "red", "green", "blue"',
        'var colors = (1:"red", 2:"green", 3:"blue")',
        'var colors = {1:"red", 2:"green", 3:"blue"}'
      ],
      'correctAnswer': 'var colors = ["red", "green", "blue"]',
      'topic': 'JavaScript'
    },
    {
      'question': 'How do you round the number 7.25 to the nearest integer?',
      'answers': [
        'Math.rnd(7.25)',
        'Math.round(7.25)',
        'rnd(7.25)',
        'round(7.25)'
      ],
      'correctAnswer': 'Math.round(7.25)',
      'topic': 'JavaScript'
    },
    // Topic 4: React
    {
      'question': 'What is React?',
      'answers': [
        'A JavaScript library for building user interfaces',
        'A framework for server-side rendering',
        'A database management tool',
        'A CSS preprocessor'
      ],
      'correctAnswer': 'A JavaScript library for building user interfaces',
      'topic': 'React'
    },
    {
      'question': 'Who developed React?',
      'answers': ['Google', 'Facebook', 'Microsoft', 'Twitter'],
      'correctAnswer': 'Facebook',
      'topic': 'React'
    },
    {
      'question': 'What is JSX?',
      'answers': [
        'A syntax extension for JavaScript',
        'A template language for React',
        'A styling language for React',
        'A testing framework for React'
      ],
      'correctAnswer': 'A syntax extension for JavaScript',
      'topic': 'React'
    },
    {
      'question': 'What is a component in React?',
      'answers': [
        'A reusable piece of UI',
        'A styling element',
        'A state management tool',
        'A testing framework'
      ],
      'correctAnswer': 'A reusable piece of UI',
      'topic': 'React'
    },
    {
      'question': 'How do you create a class component in React?',
      'answers': [
        'class MyComponent extends React.Component {}',
        'function MyComponent() {}',
        'const MyComponent = () => {}',
        'var MyComponent = function() {}'
      ],
      'correctAnswer': 'class MyComponent extends React.Component {}',
      'topic': 'React'
    },
    {
      'question': 'What is the use of the render method in React?',
      'answers': [
        'To define the UI of the component',
        'To handle state changes',
        'To handle props',
        'To define styles'
      ],
      'correctAnswer': 'To define the UI of the component',
      'topic': 'React'
    },
    {
      'question': 'How do you pass data to a React component?',
      'answers': ['Using props', 'Using state', 'Using hooks', 'Using context'],
      'correctAnswer': 'Using props',
      'topic': 'React'
    },
    {
      'question': 'What is the use of the useState hook in React?',
      'answers': [
        'To add state to functional components',
        'To add styles to components',
        'To fetch data from an API',
        'To handle component lifecycle'
      ],
      'correctAnswer': 'To add state to functional components',
      'topic': 'React'
    },
    {
      'question': 'What is the virtual DOM in React?',
      'answers': [
        'A lightweight copy of the actual DOM',
        'A real-time database',
        'A CSS preprocessor',
        'A testing framework'
      ],
      'correctAnswer': 'A lightweight copy of the actual DOM',
      'topic': 'React'
    },
    {
      'question': 'How do you handle events in React?',
      'answers': [
        'Using event handlers',
        'Using props',
        'Using state',
        'Using lifecycle methods'
      ],
      'correctAnswer': 'Using event handlers',
      'topic': 'React'
    },
    // Topic 5: Node.js
    {
      'question': 'What is Node.js?',
      'answers': [
        'A JavaScript runtime built on Chrome\'s V8 JavaScript engine',
        'A CSS framework',
        'A database management tool',
        'A testing framework'
      ],
      'correctAnswer':
          'A JavaScript runtime built on Chrome\'s V8 JavaScript engine',
      'topic': 'Node.js'
    },
    {
      'question': 'Which module is used to work with file system in Node.js?',
      'answers': ['fs', 'path', 'http', 'url'],
      'correctAnswer': 'fs',
      'topic': 'Node.js'
    },
    {
      'question': 'Which of the following is a Node.js framework?',
      'answers': ['Express', 'Laravel', 'Django', 'Flask'],
      'correctAnswer': 'Express',
      'topic': 'Node.js'
    },
    {
      'question': 'How do you create a server in Node.js?',
      'answers': [
        'http.createServer()',
        'server.create()',
        'create.server()',
        'http.server()'
      ],
      'correctAnswer': 'http.createServer()',
      'topic': 'Node.js'
    },
    {
      'question': 'What is npm?',
      'answers': [
        'A package manager for Node.js',
        'A CSS framework',
        'A JavaScript compiler',
        'A testing framework'
      ],
      'correctAnswer': 'A package manager for Node.js',
      'topic': 'Node.js'
    },
    {
      'question': 'How do you install a package using npm?',
      'answers': [
        'npm install <package>',
        'npm get <package>',
        'npm add <package>',
        'npm include <package>'
      ],
      'correctAnswer': 'npm install <package>',
      'topic': 'Node.js'
    },
    {
      'question':
          'Which of the following is used to handle asynchronous operations in Node.js?',
      'answers': ['Callbacks', 'Promises', 'Async/Await', 'All of the above'],
      'correctAnswer': 'All of the above',
      'topic': 'Node.js'
    },
    {
      'question': 'What is the purpose of the package.json file in Node.js?',
      'answers': [
        'To store metadata about the project and manage dependencies',
        'To define styles for the project',
        'To manage database connections',
        'To handle routing'
      ],
      'correctAnswer':
          'To store metadata about the project and manage dependencies',
      'topic': 'Node.js'
    },
    {
      'question':
          'Which method is used to read a file asynchronously in Node.js?',
      'answers': ['fs.readFile', 'fs.read', 'fs.getFile', 'fs.get'],
      'correctAnswer': 'fs.readFile',
      'topic': 'Node.js'
    },
    {
      'question': 'How do you export a module in Node.js?',
      'answers': [
        'module.exports',
        'module.export',
        'exports.module',
        'export.module'
      ],
      'correctAnswer': 'module.exports',
      'topic': 'Node.js'
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
        title: Text('Web Development Practice'),
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
