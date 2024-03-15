//quiz_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;
import 'Cards.dart';

class QuizPage extends StatefulWidget {
  final customDeck.Deck deck;
  final List<customDeck.Card> cards;

  QuizPage({required this.deck, required this.cards});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Cards(
              cards: currentCard,
              onTap: () {},
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                      _currentIndex = (_currentIndex + 1) % widget.cards.length;
                      currentCard.isFaceUp = true;
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
