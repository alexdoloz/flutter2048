import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:p2048/widgets/game_field.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: GameHeader()),
                Center(child: SizedBox(
                  width: 400,
                  height: 400,
                  child: GameFieldWidget()),
                ),
                Spacer(flex: 1,)
              ],
            ),
          ),
        ),
    );
  }
}

class GameHeader extends StatelessWidget {
  const GameHeader({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '2048', 
        style: GoogleFonts.raleway(
          textStyle: TextStyle(
            color: Color(0xff776e65), 
            fontWeight: FontWeight.w700, 
            fontSize: 80
          )
        ),
      ),
    );
  }
}