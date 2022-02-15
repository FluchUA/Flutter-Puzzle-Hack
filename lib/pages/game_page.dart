import 'package:flutter/material.dart';
import 'package:flutter_canvas/game_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _gameController = GameController.instance;

  @override
  void initState() {
    super.initState();
    _gameController.init();
  }

// AnimatedBuilder с vsync
  //  _controller = AnimationController(
  //     vsync: this,
  //     duration: Duration(seconds: 1),
  //   )..repeat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Listener(
          onPointerDown: (details) {
            _gameController.onDown(
                details.localPosition.dx, details.localPosition.dy);
          },
          onPointerUp: (details) {
            _gameController.onUp(
                details.localPosition.dx, details.localPosition.dy);
          },
          onPointerMove: (details) {
            _gameController.onMove(
                details.localPosition.dx, details.localPosition.dy);
            setState(() {});
          },
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _gameController.resizeGameField(
                  constraints.maxWidth, constraints.maxHeight);

              return Container(
                key: UniqueKey(),
                color: Colors.blueGrey,
                child: Stack(
                  children: [
                    ..._gameController.blockCustomPaintWidgetList,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
