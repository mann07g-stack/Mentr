import 'package:flutter/material.dart';
import 'home_page.dart'; 


class QuizPage extends StatefulWidget {
  final List<RoadmapMCQ> mcqs;
  final String topicTitle;

  const QuizPage({
    super.key,
    required this.mcqs,
    required this.topicTitle,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;

  void _answerQuestion(int selectedIndex) {
    if (_selectedOptionIndex != null) return; // Already answered

    setState(() {
      _selectedOptionIndex = selectedIndex;
      if (selectedIndex == widget.mcqs[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });

  
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_currentQuestionIndex < widget.mcqs.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOptionIndex = null; 
        });
      } else {
        _showResultsDialog();
      }
    });
  }

  void _showResultsDialog() {
    final double percentage = (_score / widget.mcqs.length) * 100;
    final bool passed = percentage >= 80;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (ctx) => AlertDialog(
        title: Text(passed ? 'Congratulations!' : 'Almost there!'),
        content: Text(
          'You scored $_score out of ${widget.mcqs.length} (${percentage.toStringAsFixed(0)}%).\n\n'
          '${passed ? 'You have passed the quiz and completed this topic!' : 'You need 80% to pass. Please try again!'}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); 
              Navigator.pop(context, passed); 
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index) {
    if (_selectedOptionIndex == null) {
      return Colors.grey.shade200;
    }
    if (index == widget.mcqs[_currentQuestionIndex].correctAnswerIndex) {
      return Colors.green.shade100;
    }
    if (index == _selectedOptionIndex) {
      return Colors.red.shade100; 
    }
    return Colors.grey.shade200; 
  }

  Icon _getOptionIcon(int index) {
    if (_selectedOptionIndex == null) {
      return const Icon(Icons.radio_button_unchecked, color: Colors.grey);
    }
    if (index == widget.mcqs[_currentQuestionIndex].correctAnswerIndex) {
      return const Icon(Icons.check_circle, color: Colors.green);
    }
    if (index == _selectedOptionIndex) {
      return const Icon(Icons.cancel, color: Colors.red);
    }
    return const Icon(Icons.radio_button_unchecked, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final currentMCQ = widget.mcqs[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        // --- USES THE NEW LOGO WIDGET ---
  
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.mcqs.length,
            backgroundColor: Colors.grey[300],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Text(
              'Question ${_currentQuestionIndex + 1}/${widget.mcqs.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
      
            Text(
              currentMCQ.question,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            
    
            ...List.generate(currentMCQ.options.length, (index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: _getOptionColor(index),
                child: ListTile(
                  leading: _getOptionIcon(index),
                  title: Text(currentMCQ.options[index]),
                  onTap: () => _answerQuestion(index),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}