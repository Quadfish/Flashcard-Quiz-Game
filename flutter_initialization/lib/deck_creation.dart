// deck_creation.dart
import 'package:flutter/material.dart';
import 'deck.dart' as customDeck; // Alias 'deck' to avoid conflicts
import 'deck_selection.dart';

class DeckCreation extends StatefulWidget {
  @override
  _DeckCreationState createState() => _DeckCreationState();
}

class _DeckCreationState extends State<DeckCreation> {
  final _formKey = GlobalKey<FormState>();
  String _deckName = '';
  List<customDeck.Card> _cards = []; // Use the alias here

  void _addCard() {
    setState(() {
      _cards.add(customDeck.Card('', ''));
    });
  }

  void _saveDeck() {
    if (_formKey.currentState!.validate()) {
      customDeck.Deck deck = customDeck.Deck(_deckName, _cards);
      Navigator.push(context, MaterialPageRoute(builder: (context) => DeckSelection(decks: [deck])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Deck')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Deck Name'),
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
            Expanded(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Card ${index + 1}'),
                    subtitle: Text('Question: ${_cards[index].question}\nAnswer: ${_cards[index].answer}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addCard,
              child: Text('Add Card'),
            ),
            ElevatedButton(
              onPressed: _saveDeck,
              child: Text('Save Deck'),
            ),
          ],
        ),
      ),
    );
  }
}