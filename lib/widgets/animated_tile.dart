import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:p2048/widgets/game_tile.dart';
import 'package:p2048/utils/durations.dart';

class AnimatedTile extends StatefulWidget {
  final int power;
  final double opacity;

  const AnimatedTile({ Key? key, required int power, double opacity = 1.0 }) : 
    this.power = power,
    this.opacity = opacity,
    super(key: key);

  @override
  _AnimatedTileState createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void didUpdateWidget(covariant AnimatedTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.power != widget.power) {
      controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Durations.tileScaleAnimationDuration
    );
    var tween1 = Tween<double>(begin: 1.0, end: 1.3);
    animation = TweenSequence([
      TweenSequenceItem(tween: tween1, weight: 1),
      TweenSequenceItem(tween: ReverseTween(tween1), weight: 1),
    ]).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Durations.tileOpacityAnimationDuration,
      opacity: widget.opacity,
      child: ScaleTransition(
        scale: animation,
        child: GameTile(widget.power),
      )
    );
  }
}