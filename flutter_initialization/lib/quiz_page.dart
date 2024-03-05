// quiz_page.dart
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<String> questions;
  final List<String> answers;
  final bool shuffle;

  QuizPage({required this.questions, required this.answers, this.shuffle = false});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  bool _questionFirst = true;

  @override
  Widget build(BuildContext context) {
    List<String> displayList;
    if (widget.shuffle) {
      displayList = List.from(widget.questions)..shuffle();
    } else {
      displayList = widget.questions;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _questionFirst ? 'Question' : 'Answer',
                  style: TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _questionFirst = !_questionFirst;
                    });
                  },
                  child: Text(_questionFirst ? 'Answer' : 'Question'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                _questionFirst ? displayList[_currentIndex] : widget.answers[_currentIndex],
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = (_currentIndex + 1) % widget.questions.length;
                  });
                },
                child: Text('Next'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Quit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
