// deck_editor.dart
import 'package:flutter/material.dart';
import 'deck.dart' as customDeck; // Alias 'deck' to avoid conflicts

class DeckEditor extends StatefulWidget {
  final customDeck.Deck deck;

  DeckEditor({required this.deck});

  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  int _selectedCardIndex = 0;

  void _selectCard(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  void _editCard(customDeck.Card newCard) {
    setState(() {
      widget.deck.cards[_selectedCardIndex] = newCard;
    });
  }

  void _deleteCard() {
    setState(() {
      widget.deck.cards.removeAt(_selectedCardIndex);
      if (_selectedCardIndex >= widget.deck.cards.length) {
        _selectedCardIndex = widget.deck.cards.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Deck')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.deck.cards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Card ${index + 1}'),
                  subtitle: Text('Question: ${widget.deck.cards[index].question}\nAnswer: ${widget.deck.cards[index].answer}'),
                  onTap: () {
                    _selectCard(index);
                  },
                  selected: _selectedCardIndex == index,
                  selectedTileColor: Colors.blueGrey[100],
                );
              },
            ),
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _deleteCard,
                child: Text('Delete'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String newQuestion = '';
                      String newAnswer = '';
                      return AlertDialog(
                        title: Text('Edit Card'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(labelText: 'Question'),
                              onChanged: (value) {
                                newQuestion = value;
                              },
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: 'Answer'),
                              onChanged: (value) {
                                newAnswer = value;
                              },
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
                            onPressed: () {
                              customDeck.Card newCard = customDeck.Card(newQuestion, newAnswer);
                              _editCard(newCard);
                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}