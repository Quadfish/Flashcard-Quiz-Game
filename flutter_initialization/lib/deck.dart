// deck.dart
class Card {
  String question;
  String answer;

  Card(this.question, this.answer);
}

class Deck {
  String name;
  List<Card> cards;

  Deck(this.name, this.cards);
}