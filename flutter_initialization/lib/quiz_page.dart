import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;
class QuizPage extends StatefulWidget {
  final customDeck.Deck deck;
  final List<customDeck.Card> cards;
  final bool shuffle;

  QuizPage({required this.deck, required this.cards, this.shuffle = false});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  bool _questionFirst = true;

  @override
  Widget build(BuildContext context) {
    List<customDeck.Card> displayList;
    if (widget.shuffle) {
      displayList = List.from(widget.cards)..shuffle();
    } else {
      displayList = widget.cards;
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
                displayList[_currentIndex].question,
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
                    _currentIndex = (_currentIndex + 1) % displayList.length;
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
