import 'dart:math';

import 'package:advent_of_code_2022/day.dart';

class Day24 extends Day<Expedition, int> {
  const Day24() : super(24);

  @override
  Expedition preprocess(List<String> input) {
    final blizzards = <Blizzard>{};
    final start = Point(input.first.indexOf('.'), 0);
    final goal = Point(input.last.indexOf('.'), input.length - 1);
    final walls = <Point<int>>{start + Point(0, -1), goal + Point(0, 1)};

    for (var y = 0; y < input.length; y++) {
      for (var x = 0; x < input[y].length; x++) {
        final character = input[y][x];

        if (Direction.values
            .map((direction) => direction.character)
            .contains(character)) {
          blizzards.add(
            Blizzard(
              Point(x, y),
              Direction.parse(character),
              width: input[y].length,
              height: input.length,
            ),
          );
        } else if (character == '#') {
          walls.add(Point(x, y));
        }
      }
    }

    return Expedition(blizzards, walls, start: start, goal: goal);
  }

  @override
  int processPart1(Expedition input) => _getFewestMinutes(input);

  @override
  int processPart2(Expedition input) =>
      _getFewestMinutes(input) +
      _getFewestMinutes(input.reversed) +
      _getFewestMinutes(input);

  int _getFewestMinutes(Expedition expedition) {
    var current = <Point<int>>{expedition.start};
    var minutes = 0;

    while (!current.contains(expedition.goal)) {
      for (final blizzard in expedition.blizzards) {
        blizzard.move();
      }

      final blizzardPositions =
          expedition.blizzards.map((blizzard) => blizzard.position).toSet();
      final next = <Point<int>>{};

      for (final position in current) {
        next.addAll(
          [
            position,
            ...Direction.values.map((direction) => position + direction.offset),
          ].where(
            (position) =>
                !expedition.walls.contains(position) &&
                !blizzardPositions.contains(position),
          ),
        );
      }

      current = next;
      minutes++;
    }

    return minutes;
  }
}

class Expedition {
  const Expedition(
    this.blizzards,
    this.walls, {
    required this.start,
    required this.goal,
  });

  final Set<Blizzard> blizzards;
  final Set<Point<int>> walls;
  final Point<int> start;
  final Point<int> goal;

  Expedition get reversed =>
      Expedition(blizzards, walls, start: goal, goal: start);
}

class Blizzard {
  Blizzard(
    this.position,
    this.direction, {
    required this.width,
    required this.height,
  });

  Point<int> position;
  final Direction direction;
  final int width;
  final int height;

  void move() {
    position += direction.offset;

    switch (direction) {
      case Direction.right:
        if (position.x == width - 1) position = Point(1, position.y);
        break;
      case Direction.down:
        if (position.y == height - 1) position = Point(position.x, 1);
        break;
      case Direction.left:
        if (position.x == 0) position = Point(width - 2, position.y);
        break;
      case Direction.up:
        if (position.y == 0) position = Point(position.x, height - 2);
        break;
    }
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

  static Direction parse(String character) => Direction.values
      .singleWhere((direction) => direction.character == character);
}
