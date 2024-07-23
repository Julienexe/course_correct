import 'dart:math';
import 'package:flutter/material.dart';
import 'tutor_dashboard.dart';

class AlgorithmPracticePage extends StatefulWidget {
  final String studentId;

  AlgorithmPracticePage({required this.studentId});

  @override
  _AlgorithmPracticePageState createState() => _AlgorithmPracticePageState();
}

class _AlgorithmPracticePageState extends State<AlgorithmPracticePage> {
  final List<Map<String, dynamic>> _allQuestions = [
    // Searching Algorithms
    {
      'question': 'What is the time complexity of binary search?',
      'answers': ['O(n)', 'O(log n)', 'O(n log n)', 'O(n^2)'],
      'correctAnswer': 'O(log n)',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'What is the time complexity of linear search?',
      'answers': ['O(1)', 'O(n)', 'O(n log n)', 'O(n^2)'],
      'correctAnswer': 'O(n)',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'Which searching algorithm is best for a sorted array?',
      'answers': [
        'Binary Search',
        'Linear Search',
        'Jump Search',
        'Interpolation Search'
      ],
      'correctAnswer': 'Binary Search',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'What is the average case time complexity of binary search?',
      'answers': ['O(n)', 'O(log n)', 'O(n log n)', 'O(1)'],
      'correctAnswer': 'O(log n)',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'Which algorithm can be used for searching in a linked list?',
      'answers': [
        'Binary Search',
        'Linear Search',
        'Jump Search',
        'Exponential Search'
      ],
      'correctAnswer': 'Linear Search',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'What is the best case time complexity of linear search?',
      'answers': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
      'correctAnswer': 'O(1)',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'What is the worst case time complexity of binary search?',
      'answers': ['O(n)', 'O(log n)', 'O(n log n)', 'O(n^2)'],
      'correctAnswer': 'O(log n)',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'Which algorithm is not suitable for unstructured data?',
      'answers': [
        'Linear Search',
        'Binary Search',
        'Jump Search',
        'Exponential Search'
      ],
      'correctAnswer': 'Binary Search',
      'topic': 'Searching Algorithms'
    },
    {
      'question': 'What is the time complexity of jump search?',
      'answers': ['O(n)', 'O(log n)', 'O(sqrt(n))', 'O(n^2)'],
      'correctAnswer': 'O(sqrt(n))',
      'topic': 'Searching Algorithms'
    },
    {
      'question':
          'Which search algorithm works by dividing the search interval in half?',
      'answers': [
        'Linear Search',
        'Binary Search',
        'Jump Search',
        'Exponential Search'
      ],
      'correctAnswer': 'Binary Search',
      'topic': 'Searching Algorithms'
    },

    // Sorting Algorithms
    {
      'question':
          'What is the time complexity of quicksort in the average case?',
      'answers': ['O(n)', 'O(n^2)', 'O(n log n)', 'O(log n)'],
      'correctAnswer': 'O(n log n)',
      'topic': 'Sorting Algorithms'
    },
    {
      'question': 'Which sorting algorithm is not comparison-based?',
      'answers': ['Bubble Sort', 'Merge Sort', 'Heap Sort', 'Radix Sort'],
      'correctAnswer': 'Radix Sort',
      'topic': 'Sorting Algorithms'
    },
    {
      'question':
          'What is the time complexity of bubble sort in the worst case?',
      'answers': ['O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)'],
      'correctAnswer': 'O(n^2)',
      'topic': 'Sorting Algorithms'
    },
    {
      'question':
          'Which sorting algorithm has the best average case time complexity?',
      'answers': [
        'Bubble Sort',
        'Quick Sort',
        'Insertion Sort',
        'Selection Sort'
      ],
      'correctAnswer': 'Quick Sort',
      'topic': 'Sorting Algorithms'
    },
    {
      'question':
          'Which sorting algorithm uses the divide-and-conquer approach?',
      'answers': [
        'Merge Sort',
        'Selection Sort',
        'Bubble Sort',
        'Insertion Sort'
      ],
      'correctAnswer': 'Merge Sort',
      'topic': 'Sorting Algorithms'
    },
    {
      'question': 'What is the space complexity of merge sort?',
      'answers': ['O(1)', 'O(log n)', 'O(n)', 'O(n^2)'],
      'correctAnswer': 'O(n)',
      'topic': 'Sorting Algorithms'
    },
    {
      'question':
          'Which sorting algorithm is stable and has a time complexity of O(n^2)?',
      'answers': ['Bubble Sort', 'Quick Sort', 'Heap Sort', 'Merge Sort'],
      'correctAnswer': 'Bubble Sort',
      'topic': 'Sorting Algorithms'
    },
    {
      'question':
          'What is the time complexity of insertion sort in the best case?',
      'answers': ['O(n)', 'O(n log n)', 'O(n^2)', 'O(1)'],
      'correctAnswer': 'O(n)',
      'topic': 'Sorting Algorithms'
    },
    {
      'question': 'Which sorting algorithm is efficient for small data sets?',
      'answers': ['Merge Sort', 'Quick Sort', 'Heap Sort', 'Insertion Sort'],
      'correctAnswer': 'Insertion Sort',
      'topic': 'Sorting Algorithms'
    },
    {
      'question':
          'What is the time complexity of selection sort in the average case?',
      'answers': ['O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)'],
      'correctAnswer': 'O(n^2)',
      'topic': 'Sorting Algorithms'
    },

    // Graph Algorithms
    {
      'question':
          'Which algorithm is used to find the shortest path in a weighted graph?',
      'answers': ['DFS', 'BFS', 'Dijkstra\'s Algorithm', 'Prim\'s Algorithm'],
      'correctAnswer': 'Dijkstra\'s Algorithm',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'What is the time complexity of depth-first search (DFS)?',
      'answers': ['O(V+E)', 'O(V)', 'O(E)', 'O(log V)'],
      'correctAnswer': 'O(V+E)',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'Which algorithm is used to find the minimum spanning tree?',
      'answers': [
        'Kruskal\'s Algorithm',
        'Dijkstra\'s Algorithm',
        'Floyd-Warshall Algorithm',
        'Bellman-Ford Algorithm'
      ],
      'correctAnswer': 'Kruskal\'s Algorithm',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'Which algorithm is used for cycle detection in a graph?',
      'answers': ['DFS', 'BFS', 'Dijkstra\'s Algorithm', 'Prim\'s Algorithm'],
      'correctAnswer': 'DFS',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'What is the space complexity of breadth-first search (BFS)?',
      'answers': ['O(V)', 'O(E)', 'O(V+E)', 'O(log V)'],
      'correctAnswer': 'O(V)',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'Which algorithm is used to find all pairs shortest paths?',
      'answers': [
        'Dijkstra\'s Algorithm',
        'Bellman-Ford Algorithm',
        'Floyd-Warshall Algorithm',
        'Prim\'s Algorithm'
      ],
      'correctAnswer': 'Floyd-Warshall Algorithm',
      'topic': 'Graph Algorithms'
    },
    {
      'question':
          'Which algorithm is used to find the strongly connected components of a graph?',
      'answers': [
        'Kruskal\'s Algorithm',
        'Tarjan\'s Algorithm',
        'Dijkstra\'s Algorithm',
        'Bellman-Ford Algorithm'
      ],
      'correctAnswer': 'Tarjan\'s Algorithm',
      'topic': 'Graph Algorithms'
    },
    {
      'question':
          'What is the time complexity of Prim\'s Algorithm using a priority queue?',
      'answers': ['O(V^2)', 'O(E log V)', 'O(V log V)', 'O(E log E)'],
      'correctAnswer': 'O(E log V)',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'Which algorithm can detect negative weight cycles?',
      'answers': [
        'Bellman-Ford Algorithm',
        'Dijkstra\'s Algorithm',
        'Floyd-Warshall Algorithm',
        'Prim\'s Algorithm'
      ],
      'correctAnswer': 'Bellman-Ford Algorithm',
      'topic': 'Graph Algorithms'
    },
    {
      'question': 'What is the time complexity of Kruskal\'s Algorithm?',
      'answers': ['O(E log V)', 'O(V^2)', 'O(V log V)', 'O(E)'],
      'correctAnswer': 'O(E log V)',
      'topic': 'Graph Algorithms'
    },

    // Dynamic Programming
    {
      'question': 'Which problem can be solved using dynamic programming?',
      'answers': [
        'Shortest Path',
        'Knapsack Problem',
        'Minimum Spanning Tree',
        'Graph Coloring'
      ],
      'correctAnswer': 'Knapsack Problem',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'What is the time complexity of the Fibonacci sequence using dynamic programming?',
      'answers': ['O(n)', 'O(log n)', 'O(n^2)', 'O(n log n)'],
      'correctAnswer': 'O(n)',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'Which technique is used in dynamic programming to store subproblem solutions?',
      'answers': ['Memoization', 'Recursion', 'Iteration', 'Greedy'],
      'correctAnswer': 'Memoization',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'Which dynamic programming problem involves finding the longest subsequence in two sequences?',
      'answers': [
        'Longest Common Subsequence',
        'Knapsack Problem',
        'Fibonacci Sequence',
        'Matrix Chain Multiplication'
      ],
      'correctAnswer': 'Longest Common Subsequence',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'What is the time complexity of the longest common subsequence problem using dynamic programming?',
      'answers': ['O(n)', 'O(n^2)', 'O(n log n)', 'O(n^3)'],
      'correctAnswer': 'O(n^2)',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'Which problem is not typically solved using dynamic programming?',
      'answers': [
        'Knapsack Problem',
        'Fibonacci Sequence',
        'Minimum Spanning Tree',
        'Longest Common Subsequence'
      ],
      'correctAnswer': 'Minimum Spanning Tree',
      'topic': 'Dynamic Programming'
    },
    {
      'question': 'What is the key idea behind dynamic programming?',
      'answers': [
        'Divide and Conquer',
        'Greedy Approach',
        'Overlapping Subproblems',
        'Sorting and Searching'
      ],
      'correctAnswer': 'Overlapping Subproblems',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'Which dynamic programming problem involves making change for a given amount using the fewest coins?',
      'answers': [
        'Coin Change Problem',
        'Knapsack Problem',
        'Longest Common Subsequence',
        'Matrix Chain Multiplication'
      ],
      'correctAnswer': 'Coin Change Problem',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'What is the space complexity of the knapsack problem using dynamic programming?',
      'answers': ['O(n)', 'O(n^2)', 'O(log n)', 'O(n log n)'],
      'correctAnswer': 'O(n)',
      'topic': 'Dynamic Programming'
    },
    {
      'question':
          'Which technique is often used in combination with dynamic programming?',
      'answers': [
        'Greedy Approach',
        'Backtracking',
        'Divide and Conquer',
        'Brute Force'
      ],
      'correctAnswer': 'Divide and Conquer',
      'topic': 'Dynamic Programming'
    },

    // Greedy Algorithms
    {
      'question': 'Which problem can be solved using a greedy algorithm?',
      'answers': [
        'Minimum Spanning Tree',
        'Longest Common Subsequence',
        'Knapsack Problem',
        'Fibonacci Sequence'
      ],
      'correctAnswer': 'Minimum Spanning Tree',
      'topic': 'Greedy Algorithms'
    },
    {
      'question': 'What is the time complexity of Prim\'s Algorithm?',
      'answers': ['O(V^2)', 'O(E log V)', 'O(V log V)', 'O(E)'],
      'correctAnswer': 'O(E log V)',
      'topic': 'Greedy Algorithms'
    },
    {
      'question':
          'Which greedy algorithm is used to find the shortest path in a weighted graph?',
      'answers': [
        'Dijkstra\'s Algorithm',
        'Prim\'s Algorithm',
        'Kruskal\'s Algorithm',
        'Bellman-Ford Algorithm'
      ],
      'correctAnswer': 'Dijkstra\'s Algorithm',
      'topic': 'Greedy Algorithms'
    },
    {
      'question':
          'Which algorithm is used for job scheduling with deadlines and profits?',
      'answers': [
        'Job Scheduling Algorithm',
        'Knapsack Algorithm',
        'Floyd-Warshall Algorithm',
        'Bellman-Ford Algorithm'
      ],
      'correctAnswer': 'Job Scheduling Algorithm',
      'topic': 'Greedy Algorithms'
    },
    {
      'question': 'What is the key idea behind greedy algorithms?',
      'answers': [
        'Optimal Substructure',
        'Overlapping Subproblems',
        'Divide and Conquer',
        'Local Optima'
      ],
      'correctAnswer': 'Local Optima',
      'topic': 'Greedy Algorithms'
    },
    {
      'question':
          'Which algorithm is used to find the optimal solution for the activity selection problem?',
      'answers': [
        'Greedy Algorithm',
        'Dynamic Programming',
        'Backtracking',
        'Divide and Conquer'
      ],
      'correctAnswer': 'Greedy Algorithm',
      'topic': 'Greedy Algorithms'
    },
    {
      'question':
          'Which greedy algorithm is used to find the minimum number of coins for a given amount?',
      'answers': [
        'Coin Change Problem',
        'Knapsack Algorithm',
        'Floyd-Warshall Algorithm',
        'Job Scheduling Algorithm'
      ],
      'correctAnswer': 'Coin Change Problem',
      'topic': 'Greedy Algorithms'
    },
    {
      'question': 'What is the space complexity of Kruskal\'s Algorithm?',
      'answers': ['O(V)', 'O(E)', 'O(V^2)', 'O(E log V)'],
      'correctAnswer': 'O(E)',
      'topic': 'Greedy Algorithms'
    },
    {
      'question':
          'Which greedy algorithm is used for constructing a Huffman tree?',
      'answers': [
        'Huffman Coding Algorithm',
        'Dijkstra\'s Algorithm',
        'Prim\'s Algorithm',
        'Kruskal\'s Algorithm'
      ],
      'correctAnswer': 'Huffman Coding Algorithm',
      'topic': 'Greedy Algorithms'
    },
    {
      'question': 'Which algorithm is not a greedy algorithm?',
      'answers': [
        'Dijkstra\'s Algorithm',
        'Prim\'s Algorithm',
        'Kruskal\'s Algorithm',
        'Bellman-Ford Algorithm'
      ],
      'correctAnswer': 'Bellman-Ford Algorithm',
      'topic': 'Greedy Algorithms'
    },
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
        title: Text('Algorithm Practice'),
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
