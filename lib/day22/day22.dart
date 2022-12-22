import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day22 extends Day<List<String>, int> {
  const Day22() : super(22);

  @override
  int processPart1(List<String> input) {
    final gridHeight = input.indexOf('');
    final gridWidth = input.take(gridHeight).map((e) => e.length).max;
    final grid = input
        .take(gridHeight)
        .map(
          (line) => line
              .padRight(gridWidth)
              .split('')
              .map((character) => Tile.parse(character))
              .toList(),
        )
        .toList();
    final directionsLine = input.skip(gridHeight + 1).first;
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
  none(' '),
  open('.'),
  solid('#');

  const Tile(this.character);

  final String character;

  static Tile parse(String character) =>
      Tile.values.singleWhere((tile) => tile.character == character);

  @override
  String toString() => character;
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
  right('>', Point(1, 0)),
  down('v', Point(0, 1)),
  left('<', Point(-1, 0)),
  top('^', Point(0, -1));

  const Orientation(this.character, this.step);

  final String character;
  final Point<int> step;

  Orientation get turnLeft =>
      Orientation.values[(index - 1) % Orientation.values.length];

  Orientation get turnRight =>
      Orientation.values[(index + 1) % Orientation.values.length];

  @override
  String toString() => character;
}

class HitWallException implements Exception {}
