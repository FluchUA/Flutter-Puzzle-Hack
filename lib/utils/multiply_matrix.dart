/// Matrix multiplication
/// 
/// Returns the resulting matrix
List<List<double>> _multiplyMatrix(
    List<List<double>> matr1, List<List<double>> matr2) {
  var rows1 = matr1.length;
  var rows2 = matr2.length;

  var cols1 = matr1[0].length;
  var cols2 = matr2[0].length;

  var matr3 = <List<double>>[];

  if (cols1 != rows2) return [];
  for (var i = 0; i < rows1; i++) {
    matr3.add(<double>[]);
  }

  for (var i = 0; i < cols2; i++) {
    for (var j = 0; j < rows1; j++) {
      var rez = 0.0;
      for (var k = 0; k < rows2; k++) {
        rez += matr1[j][k] * matr2[k][i];
      }
      matr3[j].add(rez);
    }
  }
  return matr3;
}

/// Scaling matrix
/// 
/// The matrix is relative to coordinates 0, 
/// need to shift it to the origin, 
/// scale it and return it to its previous position
List<List<double>> scaleDrawing(
  List<List<double>> points,
  double scale,
  double posX,
  double posY,
) {
  final stepOne = moveDrawing(points, -posX, -posY);
  final stepTwo = _multiplyMatrix(stepOne, [
    [scale, 0, 0],
    [0, scale, 0],
    [0, 0, 1]
  ]);

  return moveDrawing(stepTwo, posX, posY);
}

/// Offset matrix per delta distance
List<List<double>> moveDrawing(
  List<List<double>> points,
  double shiftX,
  double shiftY, 
) {
  return _multiplyMatrix(points, [
    [1, 0, 0],
    [0, 1, 0],
    [shiftX, shiftY, 1]
  ]);
}

/// Rotation matrix
/// 
/// The matrix is relative to coordinates 0, 
/// need to shift it to the origin, 
/// rotation it and return it to its previous position
List<List<double>> rotateDrawing(
    List<List<double>> points, double sinA, double cosA) {
  return _multiplyMatrix(points, [
    [cosA, sinA, 0],
    [-sinA, cosA, 0],
    [0, 0, 1]
  ]);
}
