import 'package:flutter/material.dart';
import 'package:flutter_canvas/game_controller.dart';
import 'package:flutter_canvas/objects/game_block/game_block_painter.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final _gameController = GameController.instance;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _gameController.init();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
          },
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _gameController.resizeGameField(
                  constraints.maxWidth, constraints.maxHeight);

              return AnimatedBuilder(
                animation: _animController,
                builder: (_, __) {
                  // return Transform.rotate(
                  //   angle: _animController.value * 2.0 * 3.14,
                  //   child: Container(
                  //     // key: UniqueKey(),
                  //     color: const Color.fromARGB(255, 59, 100, 60),
                  //     child: Stack(
                  //       children: [
                  //         // ..._gameController.blockCustomPaintWidgetList,
                  //         RepaintBoundary(
                  //           child: CustomPaint(
                  //             painter: GameBlockPainter(
                  //                 gameBlock: _gameController.gameBlocks[0]),
                  //           ),
                  //         ),
                  //         RepaintBoundary(
                  //           child: CustomPaint(
                  //             painter: GameBlockPainter(
                  //                 gameBlock: _gameController.gameBlocks[1]),
                  //           ),
                  //         ),
                  //         RepaintBoundary(
                  //           child: CustomPaint(
                  //             painter: GameBlockPainter(
                  //                 gameBlock: _gameController.gameBlocks[2]),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );

                  return Container(
                    color: const Color.fromARGB(255, 59, 100, 60),
                    child: Stack(
                      children: [
                        // ..._gameController.blockCustomPaintWidgetList,
                        RepaintBoundary(
                          child: CustomPaint(
                            painter: GameBlockPainter(
                                gameBlock: _gameController.gameBlocks[0]),
                          ),
                        ),
                        RepaintBoundary(
                          child: CustomPaint(
                            painter: GameBlockPainter(
                                gameBlock: _gameController.gameBlocks[1]),
                          ),
                        ),
                        RepaintBoundary(
                          child: CustomPaint(
                            painter: GameBlockPainter(
                                gameBlock: _gameController.gameBlocks[2]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              // return Container(
              //   // key: UniqueKey(),
              //   color: const Color.fromARGB(255, 59, 100, 60),
              //   child: Stack(
              //     children: [
              //       // ..._gameController.blockCustomPaintWidgetList,
              //       RepaintBoundary(
              //         child: CustomPaint(
              //           painter: GameBlockPainter(
              //               gameBlock: _gameController.gameBlocks[0]),
              //         ),
              //       ),
              //       RepaintBoundary(
              //         child: CustomPaint(
              //           painter: GameBlockPainter(
              //               gameBlock: _gameController.gameBlocks[1]),
              //         ),
              //       ),
              //       RepaintBoundary(
              //         child: CustomPaint(
              //           painter: GameBlockPainter(
              //               gameBlock: _gameController.gameBlocks[2]),
              //         ),
              //       ),
              //     ],
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
