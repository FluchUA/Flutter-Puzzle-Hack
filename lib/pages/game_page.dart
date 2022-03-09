import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_canvas/objects/game_block/game_block_painter.dart';
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
    _streamUpdate = Stream.periodic(
        Duration(milliseconds: commonValuesModel.updateTimerMS), (x) => x);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => _gameController.shuffleTiles(),
            icon: const Icon(
              Icons.restart_alt_rounded,
              size: 30,
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Listener(
          onPointerDown: (details) {
            if (_gameController.selectedBlockIndex == -1) {
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
                  return Container(
                    color: Colors.black,
                    child: Stack(
                      children: _gameController.gameBlocks
                          .map(
                            (gameBlock) => BlockCustomPaintWidget(
                              gameBlockPainter:
                                  GameBlockPainter(gameBlock: gameBlock),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              );
            },
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
            title: const Text('Congratulations You Win!!!'),
            content: Text('Tiles: $nTiles\nMoves: $nMoves'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _gameController.shuffleTiles();
                  Navigator.pop(context);
                },
                child: const Text('New Game'),
              ),
              TextButton(
                onPressed: () {
                  backToMainMenu = true;
                  Navigator.pop(context);
                },
                child: const Text('Back to Main Menu'),
              )
            ],
          );
        },
      );

      if (backToMainMenu) {
        Navigator.pop(context);
      }
    });
  }
}
