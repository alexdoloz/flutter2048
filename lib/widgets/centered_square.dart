import 'package:flutter/material.dart';

class CenteredSquare extends StatelessWidget {
  final List<Widget> children;

  const CenteredSquare({ 
    Key? key, 
    required List<Widget> children 
  }) : 
    this.children = children,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}