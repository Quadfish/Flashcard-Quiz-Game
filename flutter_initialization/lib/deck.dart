// deck.dart
class Card {
  int? id;
  int? deckId; // Define deckId property

  String question;
  String answer;

  Card({this.id, this.deckId, required this.question, required this.answer});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      deckId: json['deck_id'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deck_id': deckId, // Use deckId property
      'question': question,
      'answer': answer,
    };
  }
}
class Deck {
  int? id;
  String name;
  List<Card> cards;

  Deck(this.name, this.cards, {this.id});

  factory Deck.fromJson(Map<String, dynamic> json) {
    List<dynamic> cardList = json['cards'] ?? [];
    List<Card> parsedCards = cardList.map((cardJson) => Card.fromJson(cardJson)).toList();

    return Deck(
      json['name'] ?? '',
      parsedCards,
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }
}
