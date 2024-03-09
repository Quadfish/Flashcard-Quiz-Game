// deck.dart
class Card {
  int? id;
  int? deckId;
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
      'deck_id': deckId,
      'question': question,
      'answer': answer,
    };
  }
}

class Deck {
  int? id;
  String name;
  String description;
  List<Card> cards;

  Deck(this.name, this.description, this.cards, {this.id});

  factory Deck.fromJson(Map<String, dynamic> json) {
    List<dynamic> cardList = json['cards'] ?? [];
    List<Card> parsedCards = cardList.map((cardJson) => Card.fromJson(cardJson)).toList();

    return Deck(
      json['name'] ?? '',
      json['description'] ?? '',
      parsedCards,
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }
}