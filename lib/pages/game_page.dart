import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_canvas/painters/dial_layer_painter.dart';
import 'package:flutter_canvas/painters/game_block_painter.dart';
import 'package:flutter_canvas/painters/game_field_interface_painter.dart';
import 'package:flutter_canvas/painters/particles_layer_painter.dart';
import 'package:flutter_canvas/painters/valve_laver_painter.dart';
import 'package:flutter_canvas/utils/common_values_game_field_interface.dart';
import 'package:flutter_canvas/utils/common_values_model.dart';
import 'package:flutter_canvas/utils/game_controller.dart';
import 'package:flutter_canvas/widgets/block_custom_paint_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({required this.nTiles, Key? key}) : super(key: key);

  final int nTiles;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  final _gameController = GameController();
  late final Stream _streamUpdate;

  @override
  void initState() {
    super.initState();
    final commonValuesModel = CommonValuesModel.instance;
    commonValuesModel.gearCircumference = 2 * pi * commonValuesModel.gearRadius;

    _gameController.init(nTiles: widget.nTiles);
    _gameController.winCallback = _showDialog;
    _gameController.exitCallback =
        (() => SchedulerBinding.instance?.addPostFrameCallback((_) {
              Navigator.pop(context);
            }));

    _streamUpdate = Stream.periodic(
        Duration(milliseconds: commonValuesModel.updateTimerMS), (x) => x);

    _showDialog(2, 2);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CommonValuesGameFieldInterface.instance.resetValues();
        return true;
      },
      child: Scaffold(
        body: SizedBox.expand(
          child: Listener(
            onPointerDown: (details) {
              if (_gameController.selectedBlockIndex == -1 ||
                  _gameController.moving) {
                _gameController.onDown(
                    details.localPosition.dx, details.localPosition.dy);
              }
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

                return StreamBuilder(
                  stream: _streamUpdate,
                  builder: (_, __) {
                    _gameController.update();

                    return Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          /// Game filed interface
                          RepaintBoundary(
                            child: CustomPaint(
                              painter: GameFieldInterfacePainter(
                                  gameFieldInterface:
                                      _gameController.gameFieldInterface),
                            ),
                          ),

                          /// Valves layer
                          RepaintBoundary(
                            child: CustomPaint(
                              painter: ValveLayerPainter(
                                  valvesLayer: _gameController.valvesLayer),
                            ),
                          ),

                          /// Dial layer
                          RepaintBoundary(
                            child: CustomPaint(
                              painter: DialLayerPainter(
                                  dialLayer: _gameController.dialLayer),
                            ),
                          ),

                          /// Blocks
                          ..._gameController.gameBlocks
                              .map(
                                (gameBlock) => BlockCustomPaintWidget(
                                  gameBlockPainter:
                                      GameBlockPainter(gameBlock: gameBlock),
                                ),
                              )
                              .toList(),

                          /// Particles layer
                          RepaintBoundary(
                            child: CustomPaint(
                              painter: ParticlesLayerPainter(
                                  particlesLayer:
                                      _gameController.particlesLayer),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///
  void _showDialog(int nTiles, int nMoves) {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      bool backToMainMenu = false;
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(239, 51, 5, 5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            title: const Text(
              'Congratulations You Win!!!',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 165, 62),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10, 10),
                    blurRadius: 8.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            content: Text(
              'Tiles: $nTiles\nMoves: $nMoves',
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 165, 62),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10, 10),
                    blurRadius: 8.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _gameController.startShuffle();
                  Navigator.pop(context);
                },
                child: const Text(
                  'New Game',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 202, 14, 14),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  backToMainMenu = true;
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Main Menu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 202, 14, 14),
                  ),
                ),
              )
            ],
          );
        },
      );

      if (backToMainMenu) {
        CommonValuesGameFieldInterface.instance.resetValues();
        Navigator.pop(context);
      }
    });
  }
}
