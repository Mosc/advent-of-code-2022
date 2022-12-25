import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day22 extends Day<Notes, int> {
  const Day22() : super(22);

  @override
  Notes preprocess(List<String> input) {
    final gridHeight = input.indexOf('');
    final gridWidth = input.take(gridHeight).map((line) => line.length).max;
    final grid = input
        .take(gridHeight)
        .map(
          (line) => line
              .padRight(gridWidth)
              .split('')
              .map((character) => Tile.parse(character))
              .toList(growable: false),
        )
        .toList(growable: false);
    final directionsLine = input.skip(gridHeight + 1).first;
    final directions = RegExp(r'\d+|L|R')
        .allMatches(directionsLine)
        .map((match) => match.group(0)!);

    return Notes(grid, directions);
  }

  @override
  int processPart1(Notes input) => _calculatePassword(input);

  @override
  int processPart2(Notes input) => _calculatePassword(input, isCube: true);

  int _calculatePassword(Notes input, {bool isCube = false}) {
    var state = State(_findStart(input.grid), Direction.right);

    for (final direction in input.directions) {
      switch (direction) {
        case 'L':
        case 'R':
          state = state.turn(direction);
          break;
        default:
          final steps = int.parse(direction);

          try {
            for (var i = 0; i < steps; i++) {
              state = state.step(input.grid, isCube: isCube);
            }
          } on HitWallException {
            // Do nothing
          }

          break;
      }
    }

    return 1000 * (state.position.y + 1) +
        4 * (state.position.x + 1) +
        state.direction.index;
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

class Notes {
  const Notes(this.grid, this.directions);

  final List<List<Tile>> grid;
  final Iterable<String> directions;
}

class State {
  const State(this.position, this.direction);

  final Point<int> position;
  final Direction direction;

  State turn(String to) {
    switch (to) {
      case 'L':
        return State(position, direction.turnLeft);
      case 'R':
        return State(position, direction.turnRight);
    }

    throw Exception();
  }

  State step(List<List<Tile>> grid, {bool isCube = false}) {
    final offset = direction.offset;
    final y = (position.y + offset.y) % grid.length;
    final x = (position.x + offset.x) % grid[y].length;
    final nextPosition = Point(x, y);
    return checkStep(grid, position: nextPosition, isCube: isCube);
  }

  State checkStep(List<List<Tile>> grid,
      {Point<int>? position, bool isCube = false}) {
    final checkPosition = position ?? this.position;

    switch (grid[checkPosition.y][checkPosition.x]) {
      case Tile.none:
        return isCube
            ? _wrappedEdge.checkStep(grid, isCube: true)
            : State(checkPosition, direction).step(grid);
      case Tile.open:
        return State(checkPosition, direction);
      case Tile.solid:
        throw HitWallException();
    }
  }

  //    [1][2]
  //    [3]
  // [4][5]
  // [6]
  State get _wrappedEdge {
    const faceSize = 50;

    if (position.y < 0 ||
        position.y >= 4 * faceSize ||
        position.x < 0 ||
        position.x >= 3 * faceSize) {
      throw Exception();
    }

    final yRegion = position.y ~/ faceSize;
    final xRegion = position.x ~/ faceSize;

    switch (direction) {
      case Direction.right:
        // 2 -> 5
        if (yRegion == 0 && xRegion == 2) {
          return State(
            Point(position.x - faceSize, (3 * faceSize - 1) - position.y),
            direction.flip,
          );
        }
        // 3 -> 2
        if (yRegion == 1 && xRegion == 1) {
          return State(
            Point(position.y + faceSize, position.x - faceSize),
            direction.turnLeft,
          );
        }
        // 5 -> 2
        if (yRegion == 2 && xRegion == 1) {
          return State(
            Point(position.x + faceSize, (3 * faceSize - 1) - position.y),
            direction.flip,
          );
        }
        // 6 -> 5
        if (yRegion == 3 && xRegion == 0) {
          return State(
            Point(position.y - 2 * faceSize, position.x + 2 * faceSize),
            direction.turnLeft,
          );
        }
        break;
      case Direction.down:
        // 2 -> 3
        if (yRegion == 0 && xRegion == 2) {
          return State(
            Point(position.y + faceSize, position.x - faceSize),
            direction.turnRight,
          );
        }
        // 5 -> 6
        if (yRegion == 2 && xRegion == 1) {
          return State(
            Point(position.y - 2 * faceSize, position.x + 2 * faceSize),
            direction.turnRight,
          );
        }
        // 6 -> 2
        if (yRegion == 3 && xRegion == 0) {
          return State(
            Point(position.x + 2 * faceSize, position.y - (4 * faceSize - 1)),
            direction,
          );
        }
        break;
      case Direction.left:
        // 1 -> 4
        if (yRegion == 0 && xRegion == 1) {
          return State(
            Point(position.x - faceSize, (3 * faceSize - 1) - position.y),
            direction.flip,
          );
        }
        // 3 -> 4
        if (yRegion == 1 && xRegion == 1) {
          return State(
            Point(position.y - faceSize, position.x + faceSize),
            direction.turnLeft,
          );
        }
        // 4 -> 1
        if (yRegion == 2 && xRegion == 0) {
          return State(
            Point(position.x + faceSize, (3 * faceSize - 1) - position.y),
            direction.flip,
          );
        }
        // 6 -> 1
        if (yRegion == 3 && xRegion == 0) {
          return State(
            Point(position.y - 2 * faceSize, position.x),
            direction.turnLeft,
          );
        }
        break;
      case Direction.up:
        // 1 -> 6
        if (yRegion == 0 && xRegion == 1) {
          return State(
            Point(position.y, position.x + 2 * faceSize),
            direction.turnRight,
          );
        }
        // 2 -> 6
        if (yRegion == 0 && xRegion == 2) {
          return State(
            Point(position.x - 2 * faceSize, position.y + (4 * faceSize - 1)),
            direction,
          );
        }
        // 4 -> 3
        if (yRegion == 2 && xRegion == 0) {
          return State(
            Point(position.y - faceSize, position.x + faceSize),
            direction.turnRight,
          );
        }
        break;
    }

    throw Exception();
  }
}

enum Direction {
  right('>', Point(1, 0)),
  down('v', Point(0, 1)),
  left('<', Point(-1, 0)),
  up('^', Point(0, -1));

  const Direction(this.character, this.offset);

  final String character;
  final Point<int> offset;

  Direction get turnLeft =>
      Direction.values[(index - 1) % Direction.values.length];

  Direction get turnRight =>
      Direction.values[(index + 1) % Direction.values.length];

  Direction get flip => Direction.values[(index + 2) % Direction.values.length];

  @override
  String toString() => character;
}

class HitWallException implements Exception {}
