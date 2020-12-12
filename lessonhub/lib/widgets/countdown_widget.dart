import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final double width;
  final int duration;
  final int currentIndex;
  final Function onFinishRound;
  CountdownWidget(
      {this.width, this.duration, this.onFinishRound, this.currentIndex});
  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _widthAnimationValue;
  Animation _reverseAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: this.widget.duration,
      ),
    );
    _reverseAnimation =
        Tween<double>(begin: this.widget.width, end: 0).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {
        _widthAnimationValue = _reverseAnimation.value;
      });
      if (_controller.isCompleted) {
        this.widget.onFinishRound();
      }
    });

    super.initState();
  }

  @override
  void didUpdateWidget(CountdownWidget oldWidget) {
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller
        ..reset()
        ..forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14.0,
      child: Container(
        width: _widthAnimationValue,
        color: Colors.red,
      ),
    );
  }
}
