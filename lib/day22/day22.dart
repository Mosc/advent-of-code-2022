import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day22 extends Day<List<String>, int> {
  const Day22() : super(22);

  @override
  int processPart1(List<String> input) {
    final mapEndIndex = input.indexOf('');
    final maxWidth = input.take(mapEndIndex).map((e) => e.length).max;
    final grid = input
        .take(mapEndIndex)
        .map(
          (line) => line
              .padRight(maxWidth)
              .split('')
              .map((character) => Tile.parse(character))
              .toList(),
        )
        .toList();
    final directionsLine = input.skip(mapEndIndex + 1).first;
    final directions = RegExp(r'\d+|L|R')
        .allMatches(directionsLine)
        .map((match) => match.group(0)!);

    var state = State(_findStart(grid), Orientation.right);

    for (final direction in directions) {
      switch (direction) {
        case 'L':
        case 'R':
          state = state.turn(direction);
          break;
        default:
          final steps = int.parse(direction);

          try {
            for (var i = 0; i < steps; i++) {
              state = state.step(grid);
            }
          } on HitWallException {
            // Do nothing
          }

          break;
      }
    }

    return 1000 * (state.position.y + 1) +
        4 * (state.position.x + 1) +
        state.orientation.index;
  }

  Point<int> _findStart(List<List<Tile>> grid) {
    for (var y = 0; y < grid.length; y++) {
      for (var x = 0; x < grid[y].length; x++) {
        if (grid[y][x] == Tile.open) {
          return Point(x, y);
        }
      }
    }

    throw Exception();
  }
}

enum Tile {
  none,
  open,
  solid;

  static Tile parse(String character) {
    switch (character) {
      case '.':
        return Tile.open;
      case '#':
        return Tile.solid;
      case ' ':
        return Tile.none;
    }

    throw Exception();
  }
}

class State {
  const State(this.position, this.orientation);

  final Point<int> position;
  final Orientation orientation;

  State turn(String direction) {
    switch (direction) {
      case 'L':
        return State(position, orientation.turnLeft);
      case 'R':
        return State(position, orientation.turnRight);
    }

    throw Exception();
  }

  State step(List<List<Tile>> grid) {
    final step = orientation.step;
    final y = (position.y + step.y) % grid.length;
    final x = (position.x + step.x) % grid[y].length;
    final nextPosition = Point(x, y);

    switch (grid[nextPosition.y][nextPosition.x]) {
      case Tile.none:
        return State(nextPosition, orientation).step(grid);
      case Tile.open:
        return State(nextPosition, orientation);
      case Tile.solid:
        throw HitWallException();
    }
  }
}

enum Orientation {
  right,
  down,
  left,
  top;

  Point<int> get step {
    switch (this) {
      case Orientation.right:
        return Point(1, 0);
      case Orientation.down:
        return Point(0, 1);
      case Orientation.left:
        return Point(-1, 0);
      case Orientation.top:
        return Point(0, -1);
    }
  }

  Orientation get turnLeft =>
      Orientation.values[(index - 1) % Orientation.values.length];

  Orientation get turnRight =>
      Orientation.values[(index + 1) % Orientation.values.length];
}

class HitWallException implements Exception {}
