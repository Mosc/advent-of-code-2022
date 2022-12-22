import 'dart:io';
import 'dart:math';

import 'package:ansi_escapes/ansi_escapes.dart';

void renderGrid<T extends Object>(List<List<T>> grid) {
  stdout.write(ansiEscapes.clearScreen);
  stdout.write(ansiEscapes.curserTo(0, 0));

  for (var y = 0; y < grid.length; y++) {
    stdout.writeln(grid[y].join());
  }
}

void renderObject(Object object, Point<int> position) {
  stdout.write(ansiEscapes.curserTo(position.x, position.y));
  stdout.write(object);
}
