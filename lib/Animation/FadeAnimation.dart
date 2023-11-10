import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween('opacity', Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn)
          .thenTween('translateY', Tween(begin: -30.0, end: 0.0),
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);

return PlayAnimationBuilder<Movie?>(
  tween: tween,
  duration: Duration(milliseconds: (500 * delay).round()),
  delay: const Duration(seconds: 2), // add delay
  builder: (context, value, _) {
    return child;
  },
);
  }
}