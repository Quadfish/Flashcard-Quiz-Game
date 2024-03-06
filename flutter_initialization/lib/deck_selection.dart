import 'package:flutter/material.dart';
import 'databaseHelper.dart' as db;
import 'deck.dart';
import 'quiz_page.dart';

class DeckSelection extends StatefulWidget {
  @override
  _DeckSelectionState createState() => _DeckSelectionState();
}

class _DeckSelectionState extends State<DeckSelection> {
  List<Deck> _decks = []; // Store the retrieved decks here

  @override
  void initState() {
    super.initState();
    _fetchDecks(); // Fetch decks from the database when the widget initializes
  }

  Future<void> _fetchDecks() async {
    List<Map<String, dynamic>> deckMaps = await db.DatabaseHelper.instance.getAllDecks();
    List<Deck> decks = deckMaps.map((deckMap) => Deck.fromJson(deckMap)).toList();
    setState(() {
      _decks = decks;
    });
  }

  void _selectDeck(Deck deck) {
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
        itemCount: _decks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_decks[index].name),
            onTap: () {
              _selectDeck(_decks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add a new deck
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
