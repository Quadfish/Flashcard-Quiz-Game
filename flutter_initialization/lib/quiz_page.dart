//quiz_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;

class QuizPage extends StatefulWidget {
  final customDeck.Deck deck;
  final List<customDeck.Card> cards;

  QuizPage({required this.deck, required this.cards});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _questionFirst = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  // Changed the text to dynamically switch between 'Answer' and 'Question'
                  child: Text(_questionFirst ? 'Answer' : 'Question'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // Using AnimatedBuilder to handle the flip animation
                  return Transform(
                    transform: Matrix4.identity()
                      ..rotateY(pi * _controller.value),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if (!_controller.isAnimating) {
                          _controller.forward(from: 0.0);
                        }
                      },
                      child: Container(
                        // Adjusting color based on the question/answer state
                        color: _questionFirst ? Colors.blue : Colors.green,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          // Switched between question and answer based on the state
                          _questionFirst
                              ? widget.cards[_currentIndex].question
                              : widget.cards[_currentIndex].answer,
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Switch between question and answer based on the state
                    if (_questionFirst) {
                      _questionFirst = false;
                    } else {
                      // Increment index only when switching from answer to question
                      _currentIndex = (_currentIndex + 1) % widget.cards.length;
                      _questionFirst = true;
                    }
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
