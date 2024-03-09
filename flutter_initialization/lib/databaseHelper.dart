// databaseHelper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'deck.dart' as customDeck;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'flashcard_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
            CREATE TABLE decks(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                description TEXT
            )
        ''');

    await db.execute('''
            CREATE TABLE cards(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                deck_id INTEGER,
                question TEXT,
                answer TEXT,
                FOREIGN KEY(deck_id) REFERENCES decks(id) ON DELETE CASCADE
            )
        ''');
  }

  Future<int> insertDeck(String name, String description) async {
    final Database db = await database;
    return await db.insert('decks', {'name': name, 'description': description});
  }

  Future<List<Map<String, dynamic>>> getAllDecks() async {
    final Database db = await database;
    return await db.query('decks');
  }

  Future<int> insertCard(int deckId, String question, String answer) async {
    final Database db = await database;
    int id = await db.insert('cards', {'deck_id': deckId, 'question': question, 'answer': answer});
    return id;
  }

  Future<List<Map<String, dynamic>>> getCardsForDeck(int deckId) async {
    final Database db = await database;
    return await db.query('cards', where: 'deck_id = ?', whereArgs: [deckId]);
  }

  Future<int> insertDeckAndCards(customDeck.Deck deck) async {
    final db = await database;
    int deckId = await db.insert('decks', {'name': deck.name, 'description': deck.description});

    for (var card in deck.cards) {
      await db.insert('cards', {
        'deck_id': deckId,
        'question': card.question,
        'answer': card.answer,
      });
    }
    return deckId;
  }

  Future<int> updateCard(customDeck.Card card) async {
    final Database db = await database;
    return await db.update(
      'cards',
      {
        'id': card.id,
        'deck_id': card.deckId,
        'question': card.question,
        'answer': card.answer,
      },
      where: 'id = ?',
      whereArgs: [card.id!],
    );
  }

  Future<void> deleteDeck(int deckId) async {
    final db = await database;
    await db.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [deckId],
    );
  }

  Future<void> deleteCard(int cardId) async {
    final db = await database;
    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }

    Future<void> updateDeckDetails(int deckId, String newName, String newDescription) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(
        'decks',
        {'name': newName, 'description': newDescription},
        where: 'id = ?',
        whereArgs: [deckId],
      );
    });
  }
}
