import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:p2048/logic/game_callbacks.dart';
import 'package:p2048/logic/game_grid.dart';
import 'package:p2048/logic/game_logic.dart';
import 'package:p2048/logic/grid_point.dart';
import 'package:p2048/utils/utils.dart';
import 'package:p2048/widgets/game_tile.dart';
import 'package:p2048/widgets/game_field_background.dart';
import 'package:p2048/widgets/animated_tile.dart';

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

class Tile {
  GridPoint position = GridPoint.zero();
  bool isHidden = true;
  int power = 1;
  int index = 0;
}

extension RandomItem<T> on Set<T> {
  T get randomItem => this.elementAt(Random().nextInt(this.length));
}

class _GameField2State 
extends State<GameField2>
with SingleTickerProviderStateMixin 
implements GameDelegate {
  late Animation<double> animation;
  late AnimationController controller;
  final logic = GameLogic();
  
  var justCreatedTiles = <Tile>{};
  var tiles = List<Tile>.generate(16, (index) => Tile()..index = index);
  Set<GridPoint> get freePositions => 
    Set<GridPoint>
      .of(List<GridPoint>.generate(16, (n) => GridPoint.number(n)))
      .difference(<GridPoint>{
        for (var tile in tiles)
          if (!tile.isHidden) tile.position
      });
    

  Tile _freeTile() => tiles.firstWhere((tile) => tile.isHidden == true);

  double _toGridPosition(int logicalPosition) =>
    logicalPosition * 
    (GameFieldBackground.tileSize + GameFieldBackground.innerSpace) 
    + GameFieldBackground.sideEdge;

  List<Widget> _tileWidgets() => 
    tiles
    .map((tile) => AnimatedPositioned(
      key: ValueKey(tile.index),
      duration: justCreatedTiles.contains(tile) ? Duration(milliseconds: 0) : Duration(milliseconds: 500),
      left: _toGridPosition(tile.position.x),
      top: _toGridPosition(tile.position.y),
      child: AnimatedTile(power: tile.power, opacity: tile.isHidden ? 0.0 : 1.0),
    ))
    .toList();

  @override
  void initState() {
    super.initState();
    logic.startNewGame();
  }

  _newTile([int count = 1]) {
    justCreatedTiles = {};
    count.forEach((x) {
      var tile = _freeTile();
      justCreatedTiles.add(tile);
      setState(() {
        tile.isHidden = false;
        tile.position = freePositions.randomItem;
        tile.power = Random().nextInt(10) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
    GestureDetector(
      onTap: () {
        _newTile(2);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          GameFieldBackground(),
          ..._tileWidgets()
        ],
      ),
    );

  @override
  void runGameActions(List<TileAction> actions) {

  }
}