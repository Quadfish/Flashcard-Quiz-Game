import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;
import 'databaseHelper.dart' as db;
import 'package:google_fonts/google_fonts.dart';

class DeckCreation extends StatefulWidget {
  @override
  _DeckCreationState createState() => _DeckCreationState();
}

class _DeckCreationState extends State<DeckCreation> {
  final _formKey = GlobalKey<FormState>();
  String _deckName = '';
  String _deckDescription = '';
  List<customDeck.Card> _cards = [];
  TextEditingController _deckNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
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
    String deckDescription = _descriptionController.text.trim(); 
    if (deckName.isNotEmpty) {
      customDeck.Deck deck = customDeck.Deck(deckName, deckDescription, _cards); 
      int deckId = await db.DatabaseHelper.instance.insertDeckAndCards(deck);
      setState(() {
        _deckNameController.clear();
        _descriptionController.clear();
        _cards.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a deck name.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Deck',
          style: GoogleFonts.getFont(
            'Roboto',
            fontSize: 26,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.green[400],
          ),
        ),
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
                style: GoogleFonts.getFont(
                'Roboto',
                fontSize: 18,
                color: Colors.green[400]
              ),
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
                style: GoogleFonts.getFont(
                'Roboto',
                fontSize: 18,
                color: Colors.green[400]
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
