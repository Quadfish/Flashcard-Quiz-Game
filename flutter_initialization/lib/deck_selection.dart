// deck_selection.dart
import 'package:flutter/material.dart';
import 'databaseHelper.dart' as db;
import 'deck.dart' as customDeck;
import 'deck_editor.dart';
import 'quiz_page.dart';


class DeckSelection extends StatefulWidget {
  @override
  _DeckSelectionState createState() => _DeckSelectionState();
}


class _DeckSelectionState extends State<DeckSelection> {
  List<customDeck.Deck> _decks = [];


  @override
  void initState() {
    super.initState();
    _fetchDecks();
  }


  Future<void> _fetchDecks() async {
    List<Map<String, dynamic>> deckMaps = await db.DatabaseHelper.instance.getAllDecks();
    List<customDeck.Deck> decks = [];
   
    for (var deckMap in deckMaps) {
      customDeck.Deck deck = customDeck.Deck.fromJson(deckMap);
      List<Map<String, dynamic>> cardMaps = await db.DatabaseHelper.instance.getCardsForDeck(deck.id!);
      deck.cards = cardMaps.map((cardMap) => customDeck.Card.fromJson(cardMap)).toList();
      decks.add(deck);
    }


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
      appBar: AppBar(
        title: Text('Deck Selection', style: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.purple[600])),
        backgroundColor: Colors.tealAccent[100],
        ),
        backgroundColor: Colors.amber[50],
      body: ListView.builder(
        itemCount: _decks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${_decks[index].name} (${_decks[index].cards.length} cards)'),
            onTap: () {
              _selectDeck(_decks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeckEditor()),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
