import 'package:flutter_canvas/objects/game_block/game_block.dart';

class PositionsModel {
  PositionsModel(
    this.startX,
    this.startY,
    this.endX,
    this.endY,
    this.gameBlock,
  );

  double startX;
  double startY;
  double endX;
  double endY;
  GameBlock gameBlock;
}
