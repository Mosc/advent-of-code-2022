import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

typedef Elf = Point<int>;

class Day23 extends Day<Set<Elf>, int> {
  const Day23() : super(23);

  @override
  Set<Elf> preprocess(List<String> input) {
    final elves = <Elf>{};

    for (var y = 0; y < input.length; y++) {
      for (var x = 0; x < input[y].length; x++) {
        if (input[y].split('')[x] == '#') {
          elves.add(Point(x, y));
        }
      }
    }

    return elves;
  }

  @override
  int processPart1(Set<Elf> input) {
    for (var i = 0; i < 10; i++) {
      _runRound(input, round: i);
    }

    final positionsX = input.map((position) => position.x).toSet();
    final positionsY = input.map((position) => position.y).toSet();
    final lengthX = positionsX.max - positionsX.min + 1;
    final lengthY = positionsY.max - positionsY.min + 1;
    return lengthX * lengthY - input.length;
  }

  @override
  int processPart2(Set<Elf> input) {
    int i;
    var done = false;

    for (i = 0; !done; i++) {
      done = _runRound(input, round: i);
    }

    return i;
  }

  bool _runRound(Set<Elf> elves, {required int round}) {
    final proposedMoves = <Elf, Elf>{};

    for (final elf in elves) {
      final direction = _getDirection(elf, elves, round: round);

      if (direction != null) {
        var position = elf + direction.offsets[1];

        if (!proposedMoves.containsKey(position)) {
          proposedMoves[position] = elf;
        } else {
          proposedMoves.remove(position);
        }
      }
    }

    for (final proposedMove in proposedMoves.entries) {
      elves
        ..remove(proposedMove.value)
        ..add(proposedMove.key);
    }

    return proposedMoves.isEmpty;
  }

  Direction? _getDirection(Elf elf, Set<Elf> elves, {required int round}) {
    if (!canMove(elf, elves, allOffsets)) {
      for (int i = 0; i < Direction.values.length; i++) {
        final direction =
            Direction.values[(round + i) % Direction.values.length];

        if (canMove(elf, elves, direction.offsets)) {
          return direction;
        }
      }
    }

    return null;
  }

  bool canMove(Elf elf, Set<Elf> elves, Iterable<Point<int>> offsets) => offsets
      .map((offset) => elf + offset)
      .every((adjacent) => !elves.contains(adjacent));
}

enum Direction {
  north([Point(-1, -1), Point(0, -1), Point(1, -1)]),
  south([Point(-1, 1), Point(0, 1), Point(1, 1)]),
  west([Point(-1, -1), Point(-1, 0), Point(-1, 1)]),
  east([Point(1, -1), Point(1, 0), Point(1, 1)]);

  const Direction(this.offsets);

  final List<Point<int>> offsets;
}

final Set<Point<int>> allOffsets =
    Direction.values.map((direction) => direction.offsets).flattened.toSet();
