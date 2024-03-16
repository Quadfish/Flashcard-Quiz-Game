// deck_creation.dart
import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;
import 'databaseHelper.dart' as db;

class DeckCreation extends StatefulWidget {
  @override
  _DeckCreationState createState() => _DeckCreationState();
}

class _DeckCreationState extends State<DeckCreation> {
  final _formKey = GlobalKey<FormState>();
  String _deckName = '';
  String _deckDescription = ''; // New variable for deck description
  List<customDeck.Card> _cards = [];
  TextEditingController _deckNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController(); // New TextEditingController for deck description
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _deckNameController.dispose();
    _descriptionController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _addCard() {
    setState(() {
      _cards.add(customDeck.Card(
        question: _questionController.text,
        answer: _answerController.text,
      ));
      _questionController.clear();
      _answerController.clear();
    });
  }

  void _saveDeck() async {
    String deckName = _deckNameController.text.trim();
    String deckDescription = _descriptionController.text.trim(); // Get the deck description
    if (deckName.isNotEmpty) {
      customDeck.Deck deck = customDeck.Deck(deckName, deckDescription, _cards); // Pass deck description to Deck constructor
      int deckId = await db.DatabaseHelper.instance.insertDeckAndCards(deck);
      setState(() {
        _deckNameController.clear();
        _descriptionController.clear();
        _cards.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a deck name.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Deck', style: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.green[400])),
        backgroundColor: Colors.tealAccent[100],
      ),
      backgroundColor: Colors.amber[50],
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Deck Name'),
              controller: _deckNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a deck name';
                }
                return null;
              },
              onSaved: (value) {
                _deckName = value!;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deck Description'),
            ),
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an answer';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _addCard,
              child: Text(
                'Add Card',
                style: TextStyle(fontSize: 18, color: Colors.green[400]),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Question: ${_cards[index].question}'),
                    subtitle: Text('Answer: ${_cards[index].answer}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveDeck,
              child: Text(
                'Save Deck',
                style: TextStyle(fontSize: 18, color: Colors.green[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}