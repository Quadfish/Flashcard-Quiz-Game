// Card.dart
import 'package:flutter/material.dart';
import 'deck.dart' as customDeck;
import 'dart:math';


class Cards extends StatefulWidget {
  final customDeck.Card cards;
  final Function onTap;

  Cards({required this.cards, required this.onTap});

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Cards> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          widget.cards.isFaceUp = !widget.cards.isFaceUp;
        });
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!_controller.isAnimating) {
      _controller.forward();
      widget.onTap(widget.cards);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double angle = _animation.value * pi;
          if(angle > pi/2){
            angle = pi - angle;
          }
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(angle), 
            child: Center(
              child: Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: _animation.value < 0.5 ? Text(
                    widget.cards.isFaceUp ? widget.cards.question : widget.cards.answer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ) : Container(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}