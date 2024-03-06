import 'package:flutter/material.dart';
import 'deck.dart' as customDeck; // Alias 'deck' to avoid conflicts
import 'databaseHelper.dart' as db;

class DeckEditor extends StatefulWidget {
  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  late List<customDeck.Deck> _decks = [];
  List<customDeck.Card> _cards = [];
  customDeck.Deck? _selectedDeck;
  TextEditingController _deckNameController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    List<Map<String, dynamic>> deckMaps = await db.DatabaseHelper.instance.getAllDecks();
    setState(() {
      _decks = deckMaps.map((deckMap) => customDeck.Deck.fromJson(deckMap)).toList();
    });
  }

  void _selectDeck(customDeck.Deck deck) async {
    _selectedDeck = deck;
    _deckNameController.text = deck.name;
    List<Map<String, dynamic>> cardMaps = await db.DatabaseHelper.instance.getCardsForDeck(deck.id!);
    setState(() {
      _cards = cardMaps.map((cardMap) => customDeck.Card.fromJson(cardMap)).toList();
    });
  }

  void _updateDeckName(int deckId, String newName) async {
    await db.DatabaseHelper.instance.updateDeckName(deckId, newName);
    _loadDecks(); // Reload decks to reflect changes
  }

  void _editCard(customDeck.Card card) {
    _questionController.text = card.question;
    _answerController.text = card.answer;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Card'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Question'),
                controller: _questionController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Answer'),
                controller: _answerController,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update card information in the database
                card.question = _questionController.text.trim();
                card.answer = _answerController.text.trim();
                await db.DatabaseHelper.instance.updateCard(card);
                _loadDecks(); // Reload decks to reflect changes
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Deck', style: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blue[700])),
        backgroundColor: Colors.tealAccent),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: _decks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_decks[index].name, style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                  onTap: () {
                    _selectDeck(_decks[index]);
                  },
                );
              },
            ),
          ),
          if (_selectedDeck != null) ...[
            TextField(
              controller: _deckNameController,
              decoration: InputDecoration(labelText: 'Deck Name'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateDeckName(_selectedDeck!.id!, _deckNameController.text);
              },
              child: Text('Save Deck Name'),
            ),
          ],
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Card ${index + 1}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Question: ${_cards[index].question}\nAnswer: ${_cards[index].answer}'),
                  onTap: () {
                    _editCard(_cards[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
