// Card.dart
import 'package:flutter/material.dart';
import 'package:flutter_initialization/deck.dart';
import 'deck.dart';

class Card extends StatefulWidget {
  final Deck card;
  final Function onTap;

  Card({required this.card, required this.onTap});

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward();
        widget.onTap(widget.card);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_animation.value * 3.141), 
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.all(5),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: widget.card.isFaceUp ? Colors.white : Colors.grey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.card.isFaceUp ? widget.card.front : widget.card.back,
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
