// deck_selection.dart
import 'package:flutter/material.dart';
import 'deck.dart';
import 'quiz_page.dart';

class DeckSelection extends StatefulWidget {
  final List<Deck> decks;

  DeckSelection({required this.decks});

  @override
  _DeckSelectionState createState() => _DeckSelectionState();
}

class _DeckSelectionState extends State<DeckSelection> {
  late Deck _selectedDeck;

  @override
  void initState() {
    super.initState();
    _selectedDeck = widget.decks.isNotEmpty ? widget.decks.first : Deck('', []);
  }

  void _selectDeck(Deck deck) {
    setState(() {
      _selectedDeck = deck;
    });
  }

  void _startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizPage(questions: [], answers: [])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deck Selection')),
      body: ListView.builder(
        itemCount: widget.decks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.decks[index].name),
            onTap: () {
              _selectDeck(widget.decks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedDeck == null ? null : _startQuiz,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}