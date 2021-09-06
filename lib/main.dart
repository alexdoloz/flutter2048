import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:p2048/game_grid.dart';
import 'package:p2048/game_logic.dart';

void main() {
  runApp(MyApp());
  game.startNewGame();
  print(game.grid);
}

var game = GameLogic();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Center(
          child: GameField2(),
        )
      ), 
    );
  }
}

class GameFieldWidget extends StatefulWidget {
  const GameFieldWidget({ Key? key }) : super(key: key);

  @override
  _GameFieldWidgetState createState() => _GameFieldWidgetState();
}

class _GameFieldWidgetState extends State<GameFieldWidget> {
  var logic = GameLogic();
  static const cellSide = 80.0;
  static const spacing = 8.0;

  @override
  void initState() {
    super.initState();
    logic.startNewGame();
  } 

  Widget _row(int index) {
    final row = logic.grid.row(index);
    return Row(
      children: 4.map((x) => GameTile(row[x])),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
    );
  }

  List<Widget> _rows() => 4.map((y) => _row(y));

  @override
  Widget build(BuildContext context) {
    final side = 4 * cellSide + 5 * spacing;
    final gameColor = Color(0xffbbada0);
    final borderSide = BorderSide(
      color: gameColor, 
      style: BorderStyle.solid,
      width: spacing,
    );
    final border = Border.fromBorderSide(borderSide);
    return GestureDetector(
      onHorizontalDragEnd: (info) {
        if (info.primaryVelocity == null) return;
        var velocity = info.primaryVelocity ?? 0;
        var direction = velocity > 0 ? MoveDirection.right : MoveDirection.left;
        setState(() {
          logic.move(direction);
        });
      },
      onVerticalDragEnd: (info) {
      if (info.primaryVelocity == null) return;
        var velocity = info.primaryVelocity ?? 0;
        var direction = velocity > 0 ? MoveDirection.down : MoveDirection.up;
        setState(() {
          logic.move(direction);
        });
      },
      
      child: SizedBox(
        width: side,
        height: side,
        child: Container(
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(5.0),
            color: gameColor,
          ),
          child: Column(
            children: _rows(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
          ),
        ),
      ),
    );
  }
}

class GameTile extends StatelessWidget {
  static const tileSize = 80.0;
  final int power;

  static List<Color> colors = [
    Color.fromARGB(89, 238, 228, 218), 
    Color(0xffeee4da), 
    Color(0xffede0c8),
    Colors.orange, // TODO: Заменить на настоящие цвета
    Colors.purple, Colors.red, Colors.deepOrange, Colors.blue,
    Colors.teal, Colors.cyan, Colors.black, Colors.lime
  ];

  GameTile(this.power);
  GameTile.empty() : power = 0;

  @override
  Widget build(BuildContext context) {
    final text = '${pow(2, power)}';
    var textWidget = Text(
      text,
      style: TextStyle(fontSize: 25.0 - text.length, color: Colors.white),
    );
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.transparent,
            style: BorderStyle.solid,
            width: 0.0,
          )
        ),
        borderRadius: BorderRadius.circular(5.0),
        color: GameTile.colors[power],
      ),
      width: tileSize,
      height: tileSize,
      alignment: Alignment.center, 
      child: power == 0 ? null : textWidget,
    );
  }
}
/*
Column(
          children: [
            ElevatedButton(
              onPressed: () { 
                game.move(MoveDirection.up);
                print(game.grid);  
              },
              child: Text('up'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () { 
                game.move(MoveDirection.down);
                print(game.grid);  
              },
              child: Text('down'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () { 
                game.move(MoveDirection.left);
                print(game.grid);  
              },
              child: Text('left'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () { 
                game.move(MoveDirection.right);
                print(game.grid);  
              },
              child: Text('right'),
            ),
          ],
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),*/

class GameField2 extends StatefulWidget {
  const GameField2({ Key? key }) : super(key: key);

  @override
  _GameField2State createState() => _GameField2State();
}

class _GameField2State 
extends State<GameField2>
with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<double>(begin: 80+16, end: 240+32).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        GameFieldBackground(),
        Positioned(
          top: 8.0,
          left: animation.value,
          child: GameTile(2),
        )
      ],
    );
  }
}

class GameFieldBackground extends StatelessWidget {
  static const sideEdge = 8.0;
  static const innerSpace = 8.0;

  const GameFieldBackground({ Key? key }) : super(key: key);

  Widget _row(int index) => Row(
    children: 4.map((x) => GameTile.empty()),
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  );

  List<Widget> _rows() => 4.map((y) => _row(y));

  @override
  Widget build(BuildContext context) {
    const side = 2*sideEdge + 3*innerSpace + 4*GameTile.tileSize;
    const gameColor = const Color(0xffbbada0);
    final borderSide = BorderSide(
      color: gameColor, 
      style: BorderStyle.solid,
      width: sideEdge,
    );
    return Container(
      child: SizedBox(
        width: side,
        height: side,
        child: Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(borderSide),
            borderRadius: BorderRadius.circular(5.0),
            color: gameColor,
          ),
          child: Column(
            children: _rows(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}