import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day23 extends Day<List<Elf>, int> {
  const Day23() : super(23);

  @override
  List<Elf> preprocess(List<String> input) {
    final elves = <Elf>[];

    for (var y = 0; y < input.length; y++) {
      for (var x = 0; x < input[y].length; x++) {
        if (input[y].split('')[x] == '#') {
          elves.add(Elf(Point(x, y)));
        }
      }
    }

    return elves;
  }

  @override
  int processPart1(List<Elf> input) {
    for (var i = 0; i < 10; i++) {
      _runRound(input, i);
    }

    final positions = input.map((elf) => elf.position).toSet();
    final positionsX = positions.map((position) => position.x).toSet();
    final positionsY = positions.map((position) => position.y).toSet();
    final lengthX = positionsX.max - positionsX.min + 1;
    final lengthY = positionsY.max - positionsY.min + 1;
    return lengthX * lengthY - input.length;
  }

  @override
  int processPart2(List<Elf> input) {
    int i;
    var done = false;

    for (i = 0; !done; i++) {
      done = _runRound(input, i);
    }

    return i;
  }

  bool _runRound(List<Elf> elves, int i) {
    for (final elf in elves) {
      final direction = elf.findMoveDirection(i, elves);

      if (direction != null) {
        elf.proposeMove(direction);
      } else {
        elf.clearProposedMove();
      }
    }

    for (final elf in elves) {
      if (elf.shouldMove(elves)) {
        elf.move();
      }
    }

    return elves.every((elf) => elf.proposedPosition == null);
  }
}

class Elf {
  Elf(this.position);

  Point<int> position;
  Point<int>? proposedPosition;

  Direction? findMoveDirection(int round, List<Elf> elves) {
    bool canMove(Iterable<Point<int>> offsets) =>
        !offsets.map((offset) => position + offset).any(
              (adjacent) => elves.map((elf) => elf.position).contains(adjacent),
            );

    for (int i = 0; i < Direction.values.length; i++) {
      final direction = Direction.values[(round + i) % Direction.values.length];

      if (canMove(direction.offsets) &&
          !canMove(
            allOffsets.whereNot((offset) => direction.offsets.contains(offset)),
          )) {
        return direction;
      }
    }

    return null;
  }

  void proposeMove(Direction direction) =>
      proposedPosition = position + direction.offsets[1];

  bool shouldMove(List<Elf> elves) =>
      proposedPosition != null &&
      !elves
          .whereNot((elf) => elf.position == position)
          .map((elf) => elf.proposedPosition)
          .whereNotNull()
          .contains(proposedPosition);

  void move() => position = proposedPosition!;

  void clearProposedMove() => proposedPosition = null;
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
