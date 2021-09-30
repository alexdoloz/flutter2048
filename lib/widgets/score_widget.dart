import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/utils/colors.dart';
import 'package:p2048/utils/durations.dart';

class ScoreWidget extends StatefulWidget {
  final String scoreLabel;
  final int score;

  const ScoreWidget({ 
    required String scoreLabel, 
    required int score, 
    Key? key
  }) :
    this.scoreLabel = scoreLabel,
    this.score = score,
    super(key: key);

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> with TickerProviderStateMixin {
  var _delta = 0;
  var _isAnimating = false;

  @override
  void didUpdateWidget(covariant ScoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _delta = widget.score - oldWidget.score;
    });
    Future.delayed(Duration(milliseconds: 50), () {
      if (_delta > 0) {
        _startAnimation();
      }
    });
  }

  _startAnimation() {
    setState(() {
      _isAnimating = true;
    });
  }

  final _textStyle = GoogleFonts.roboto(
    textStyle: TextStyle(
      color: Color(0xffffffff),
      fontSize: 25,
      fontWeight: FontWeight.w700,
    ),
  );

  final _animatedTextStyle = GoogleFonts.roboto(
    textStyle: TextStyle(
      color: GameColors.darkForeground,
      fontSize: 25,
      fontWeight: FontWeight.w700,
    ),
  );

  static const decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Color(0xffad9d8f),
    );
  static const duration = Durations.tileMovementDuration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: decoration,
        constraints: BoxConstraints(maxWidth: 120),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(flex: 3,),
              Text(
                widget.scoreLabel.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Color(0xffeee4da),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(flex: 1,),
              Stack(
                alignment: Alignment.center, 
                children: [
                  Text(
                    '${widget.score}',
                    textAlign: TextAlign.center,
                    style: _textStyle,
                  ),
                  AnimatedPositioned(
                    child: AnimatedOpacity(
                      opacity: _isAnimating ? 0 : 1, 
                      duration: duration,
                      child: Text(
                        _delta <= 0 ? "" : "+$_delta",
                        textAlign: TextAlign.center,
                        style: _animatedTextStyle,
                      ),
                    ),
                    duration: duration,
                    top: _isAnimating ? -50 : 0,
                    onEnd: () {
                      setState(() {
                        _isAnimating = false;
                        _delta = 0;
                      });
                    },
                  )
                ],
              ),
              Spacer(flex: 2,),
            ],
          ),
        ),
      ),
    );
  }
}