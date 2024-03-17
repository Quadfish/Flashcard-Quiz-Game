// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'deck_creation.dart';
import 'deck_editor.dart';
import 'deck_selection.dart';


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
        title: Text(
          'FlashNPass',
          style: GoogleFonts.getFont(
            'Lobster',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.tealAccent[100],
      ),
      backgroundColor: Colors.amber[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Introducing a intuitive way to learn using FlashNPass! \n\n - Use the Create Deck tool to create your very own flash card quiz!\n\n - Edit your decks and make sure your facts are on point.\n\n - Finally, take the deck into play and test your knowledge!',
              style: GoogleFonts.getFont(
                'Source Code Pro',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
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
                  style: GoogleFonts.getFont(
                    'Lobster',
                    fontSize: 18,
                    color: Colors.green[400],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                  style: GoogleFonts.getFont(
                    'Lobster',
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                  style: GoogleFonts.getFont(
                    'Lobster',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}