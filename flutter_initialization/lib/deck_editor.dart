import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;
import 'databaseHelper.dart' as db;
import 'package:google_fonts/google_fonts.dart';

class DeckEditor extends StatefulWidget {
  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  late List<customDeck.Deck> _decks = [];
  List<customDeck.Card> _cards = [];
  customDeck.Deck? _selectedDeck;
  TextEditingController _deckNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
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

  Future<void> _loadCards() async {
    List<Map<String, dynamic>> cardMaps = await db.DatabaseHelper.instance.getCardsForDeck(_selectedDeck!.id!);
    setState(() {
      _cards = cardMaps.map((cardMap) => customDeck.Card.fromJson(cardMap)).toList();
    });
  }

  void _selectDeck(customDeck.Deck deck) async {
    _selectedDeck = deck;
    _deckNameController.text = deck.name;
    _descriptionController.text = deck.description;
    List<Map<String, dynamic>> cardMaps = await db.DatabaseHelper.instance.getCardsForDeck(deck.id!);
    setState(() {
      _cards = cardMaps.map((cardMap) => customDeck.Card.fromJson(cardMap)).toList();
    });
  }

  void _updateDeckDetails(int deckId, String newName, String newDescription) async {
    await db.DatabaseHelper.instance.updateDeckDetails(deckId, newName, newDescription);
    _loadDecks();
  }

  void _editCard(customDeck.Card card) {
    _questionController.text = card.question;
    _answerController.text = card.answer;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Card'),
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
                _questionController.clear();
                _answerController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                card.question = _questionController.text.trim();
                card.answer = _answerController.text.trim();
                await db.DatabaseHelper.instance.updateCard(card);
                _loadCards();
                _questionController.clear();
                _answerController.clear();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addCardToDeck() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Card'),
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
              onPressed: () async {
                if (_selectedDeck != null) {
                  await db.DatabaseHelper.instance.insertCard(
                    _selectedDeck!.id!,
                    _questionController.text.trim(),
                    _answerController.text.trim(),
                  );
                  _loadCards();
                  _questionController.clear();
                  _answerController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCard(customDeck.Card card) async {
    await db.DatabaseHelper.instance.deleteCard(card.id!);
    _loadCards();
  }

  void _deleteDeck(customDeck.Deck deck) async {
    await db.DatabaseHelper.instance.deleteDeck(deck.id!);
    _deckNameController.clear();
    _descriptionController.clear();
    _loadDecks();
    setState(() {
      _cards = [];
      _selectedDeck = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Deck',
          style: GoogleFonts.getFont(
            'Roboto',
            fontSize: 26,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        backgroundColor: Colors.tealAccent[100],
      ),
      backgroundColor: Colors.amber[50],
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _decks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _decks[index].name,
                            style: GoogleFonts.getFont(
                              'Roboto',
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey[400]),
                          onPressed: () {
                            _deleteDeck(_decks[index]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _selectDeck(_decks[index]);
                    },
                  );
                },
              ),
            ),
          ),
          if (_selectedDeck != null) ...[
            TextField(
              controller: _deckNameController,
              decoration: const InputDecoration(labelText: 'Deck Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deck Description'),
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    _updateDeckDetails(_selectedDeck!.id!, _deckNameController.text, _descriptionController.text);
                  },
                  child: const Text(
                    'Save Deck Details',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: _addCardToDeck,
                  child: const Text(
                    'Add Card',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
          Expanded(
            flex: 3,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Card ${index + 1}',
                            style: GoogleFonts.getFont(
                              'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey[400]),
                          onPressed: () {
                            _deleteCard(_cards[index]);
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Question: ${_cards[index].question}\nAnswer: ${_cards[index].answer}',
                    ),
                    onTap: () {
                      _editCard(_cards[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
