import 'package:flutter/material.dart';
import 'databaseHelper.dart' as db;
import 'deck.dart' as customDeck;
import 'quiz_page.dart';

class DeckSelection extends StatefulWidget {
  @override
  _DeckSelectionState createState() => _DeckSelectionState();
}

class _DeckSelectionState extends State<DeckSelection> {
  List<customDeck.Deck> _decks = []; // Store the retrieved decks here
  @override
  void initState() {
    super.initState();
    _fetchDecks(); // Fetch decks from the database when the widget initializes
  }

  Future<void> _fetchDecks() async {
    List<Map<String, dynamic>> deckMaps = await db.DatabaseHelper.instance.getAllDecks();
    List<customDeck.Deck> decks = deckMaps.map((deckMap) => customDeck.Deck.fromJson(deckMap)).toList();
    setState(() {
      _decks = decks;
    });
  }

  Future<List<customDeck.Card>> _fetchCardsForDeck(customDeck.Deck deck) async {
    List<Map<String, dynamic>> cardMaps = await db.DatabaseHelper.instance.getCardsForDeck(deck.id!);
    return cardMaps.map((cardMap) => customDeck.Card.fromJson(cardMap)).toList();
  }

  void _selectDeck(customDeck.Deck deck) async {
    List<customDeck.Card> cards = await _fetchCardsForDeck(deck);
    if (cards.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizPage(deck: deck, cards: cards)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Selected deck has no cards.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
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
