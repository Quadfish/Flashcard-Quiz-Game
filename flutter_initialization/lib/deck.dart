//deck.dart
import 'package:flutter/material.dart';

class Card {
  int? id;
  int? deckId;
  String question;
  String answer;
  bool isFaceUp;

  Card({this.id, this.deckId, required this.question, required this.answer, this.isFaceUp = true});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      deckId: json['deck_id'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      isFaceUp: json['is_face_up'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deck_id': deckId,
      'question': question,
      'answer': answer,
      'is_face_up': isFaceUp,
    };
  }
}

class Deck extends ChangeNotifier {
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
}
