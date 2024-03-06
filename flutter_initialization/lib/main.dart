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
      title: 'FlashNPass',
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
        title: Text('FlashNPass', style: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blue[700])),
        backgroundColor: Colors.tealAccent[100],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('                          Enter the game! \n - Use the Create Deck tool to create your very own flash card quiz!\n - Edit your decks and make sure your facts are on point.\n - Finally, take the deck into play and test your knowledge!', 
            style: TextStyle(fontSize: 18, color: Colors.tealAccent[100]),),
            SizedBox(
              height: 20
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeckCreation()),
                  );
                },
                child: Text(
                  'Create Deck',
                  style: TextStyle(fontSize: 18, color: Colors.green[400]),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeckEditor()),
                  );
                },
                child: Text(
                  'Edit Deck',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeckSelection()),
                  );
                },
                child: Text(
                  'Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}