// main.dart
import 'package:flutter/material.dart';
import 'deck_creation.dart';
import 'deck_editor.dart';
import 'deck_selection.dart';
import 'quiz_page.dart';
import 'deck.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashCard Quiz Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlashCard Quiz Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeckCreation()),
                );
              },
              child: Text('Create Deck'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeckEditor(deck: Deck('', []))),
                );
              },
              child: Text('Edit Deck'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeckSelection(decks: [])),
                );
              },
              child: Text('Use Deck'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage(questions: [], answers: [])),
                );
              },
              child: Text('Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
