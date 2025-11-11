import 'package:flutter/material.dart';
import 'login_page.dart'; 
import 'quiz_page.dart';
import 'user_profile.dart'; 
import 'package:url_launcher/url_launcher.dart'; 
import 'package:fl_chart/fl_chart.dart'; 



class RoadmapTopic {
  final String title;
  final String description;
  final List<RoadmapResource> resources;
  final List<RoadmapMCQ> mcqs;

  RoadmapTopic({
    required this.title,
    required this.description,
    required this.resources,
    required this.mcqs,
  });
}

class RoadmapResource {
  final String title;
  final String url;
  RoadmapResource({required this.title, required this.url});
}

class RoadmapMCQ {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  RoadmapMCQ(
      {required this.question,
      required this.options,
      required this.correctAnswerIndex});
}


final webDevRoadmap = [
  RoadmapTopic(
    title: "1. HTML Basics",
    description: "Learn the structure of all web pages.",
    resources: [
      RoadmapResource(
          title: "HTML Tutorial",
          url: "https://www.geeksforgeeks.org/html/"),
      RoadmapResource(
          title: "HTML Elements",
          url: "https://www.geeksforgeeks.org/html-elements/"),
    ],
    mcqs: [
      RoadmapMCQ(
        question: "What does HTML stand for?",
        options: [
          "HyperText Markup Language",
          "Home Tool Markup Language",
          "Hyperlinks and Text Markup Language"
        ],
        correctAnswerIndex: 0,
      ),
      RoadmapMCQ(
        question: "What is the correct tag for the largest heading?",
        options: ["<heading>", "<h6>", "<h1>"],
        correctAnswerIndex: 2,
      ),
      RoadmapMCQ(
        question: "Which tag is used to create a link?",
        options: ["<link>", "<a>", "<href>"],
        correctAnswerIndex: 1,
      ),
      RoadmapMCQ(
        question: "What does the <br> tag do?",
        options: ["Bold text", "Line break", "Bullet point"],
        correctAnswerIndex: 1,
      ),
      RoadmapMCQ(
        question: "Which tag defines the body of the document?",
        options: ["<body>", "<main>", "<content>"],
        correctAnswerIndex: 0,
      ),
    ],
  ),
  RoadmapTopic(
    title: "2. CSS Fundamentals",
    description: "Style your web pages to make them look great.",
    resources: [
      RoadmapResource(
          title: "CSS Tutorial",
          url: "https://www.geeksforgeeks.org/css/"),
      RoadmapResource(
          title: "CSS Selectors",
          url: "https://www.geeksforgeeks.org/css-selectors/"),
    ],
    mcqs: [
      RoadmapMCQ(
        question: "What does CSS stand for?",
        options: [
          "Creative Style Sheets",
          "Cascading Style Sheets",
          "Computer Style Sheets"
        ],
        correctAnswerIndex: 1,
      ),
      RoadmapMCQ(
        question: "How do you select an element with id 'header'?",
        options: [".header", "#header", "header"],
        correctAnswerIndex: 1,
      ),
      RoadmapMCQ(
        question: "How do you select elements with class name 'item'?",
        options: [".item", "#item", "item"],
        correctAnswerIndex: 0,
      ),
      RoadmapMCQ(
        question: "Which property changes the text color?",
        options: ["font-color", "text-color", "color"],
        correctAnswerIndex: 2,
      ),
      RoadmapMCQ(
        question: "Which property changes the background color?",
        options: ["background-color", "color", "bg-color"],
        correctAnswerIndex: 0,
      ),
    ],
  ),
  RoadmapTopic(
    title: "3. JavaScript Essentials",
    description: "Add interactivity and logic to your websites.",
    resources: [
      RoadmapResource(
          title: "JavaScript Tutorial",
          url: "https://www.geeksforgeeks.org/javascript/"),
      RoadmapResource(
          title: "JavaScript DOM",
          url: "https://www.geeksforgeeks.org/dom-document-object-model/"),
    ],
    mcqs: [
      RoadmapMCQ(
        question: "Which keyword is used to declare a variable?",
        options: ["var", "let", "const", "All of the above"],
        correctAnswerIndex: 3,
      ),
      RoadmapMCQ(
        question: "How do you write 'Hello' in an alert box?",
        options: ["msg('Hello');", "alert('Hello');", "prompt('Hello');"],
        correctAnswerIndex: 1,
      ),
      RoadmapMCQ(
        question: "How do you create a function in JavaScript?",
        options: ["function myFunction()", "def myFunction()", "create myFunction()"],
        correctAnswerIndex: 0,
      ),
      RoadmapMCQ(
        question: "How do you call a function named 'myFunction'?",
        options: ["call myFunction()", "myFunction()", "run myFunction"],
        correctAnswerIndex: 1,
      ),
      RoadmapMCQ(
        question: "What operator is used for strict equality (value and type)?",
        options: ["==", "===", "="],
        correctAnswerIndex: 1,
      ),
    ],
  ),
];


class HomePage extends StatefulWidget {
  final UserProfile profile;

  const HomePage({
    super.key,
    required this.profile,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Set<String> _completedTopics = {};

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showQuiz(RoadmapTopic topic) async {
    final bool? passedQuiz = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          mcqs: topic.mcqs,
          topicTitle: topic.title,
        ),
      ),
    );

    if (passedQuiz == true) {
      setState(() {
        _completedTopics.add(topic.title);
      });
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
 
    final int completedCount = _completedTopics.length;
    final int totalCount = webDevRoadmap.length;
    final double progress = totalCount > 0 ? (completedCount / totalCount) : 0;

    return Scaffold(
      appBar: AppBar(
       
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.profile.courseTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome, ${widget.profile.name}!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                            sections: [
                              PieChartSectionData(
                                value: completedCount.toDouble(),
                                title: '$completedCount',
                                color: Colors.deepPurple,
                                radius: 25,
                                titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: (totalCount - completedCount).toDouble(),
                                title: '${totalCount - completedCount}',
                                color: Colors.grey.shade300,
                                radius: 20,
                                titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress: $completedCount / $totalCount topics',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(width: 12, height: 12, color: Colors.deepPurple),
                                const SizedBox(width: 8),
                                const Text('Completed'),
                                const SizedBox(width: 16),
                                Container(width: 12, height: 12, color: Colors.grey.shade300),
                                const SizedBox(width: 8),
                                const Text('Pending'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Your Learning Topics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          ...webDevRoadmap.map((topic) {
            final bool isCompleted = _completedTopics.contains(topic.title);
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                leading: Icon(
                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: isCompleted ? Colors.green : Colors.grey,
                ),
                title: Text(topic.title,
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text(topic.description),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resources:',
                            style: Theme.of(context).textTheme.titleMedium),
                        ...topic.resources.map((res) {
                          return ListTile(
                            leading: const Icon(Icons.link, color: Colors.blue),
                            title: Text(res.title,
                                style: const TextStyle(color: Colors.blue)),
                            onTap: () => _launchURL(res.url),
                          );
                        }),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _showQuiz(topic),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCompleted ? Colors.green : null,
                          ),
                          child: Text(
                            isCompleted ? 'Quiz Passed!' : 'Start Quiz',
                            style: TextStyle(
                              color: isCompleted ? Colors.white : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}