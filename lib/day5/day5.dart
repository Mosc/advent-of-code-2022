import 'dart:collection';

import 'package:advent_of_code_2022/day.dart';

class Day5 extends Day<Procedure, Iterable<Queue<String>>> {
  const Day5() : super(5);

  @override
  Procedure preprocess(List<String> value) {
    final stackEndIndex = value.indexOf('');
    final stacks = <int, Queue<String>>{};
    final rearrangements = <Rearrangement>[];

    for (final line in value.sublist(0, stackEndIndex - 1)) {
      final stackCount = (line.length + 1) ~/ 4;

      for (var i = 1; i < stackCount + 1; i++) {
        if (stacks[i] == null) {
          stacks[i] = Queue<String>();
        }

        var crate = line[i * 4 - 3];

        if (crate != ' ') {
          stacks[i]!.addFirst(crate);
        }
      }
    }

    for (final line in value.sublist(stackEndIndex + 1)) {
      final words = line.split(' ');
      final amount = int.parse(words[1]);
      final from = int.parse(words[3]);
      final to = int.parse(words[5]);
      rearrangements.add(Rearrangement(amount: amount, from: from, to: to));
    }

    return Procedure(stacks, rearrangements);
  }

  @override
  Iterable<Queue<String>> processPart1(Procedure value) {
    for (final rearrangement in value.rearrangements) {
      for (int i = 0; i < rearrangement.amount; i++) {
        final crate = value.stacks[rearrangement.from]!.removeLast();
        value.stacks[rearrangement.to]!.addLast(crate);
      }
    }

    return value.stacks.values;
  }

  @override
  Iterable<Queue<String>> processPart2(Procedure value) {
    for (final rearrangement in value.rearrangements) {
      final crates = value.stacks[rearrangement.from]!.toList().sublist(
            value.stacks[rearrangement.from]!.length - rearrangement.amount,
          );

      for (final crate in crates) {
        value.stacks[rearrangement.from]!.removeLast();
        value.stacks[rearrangement.to]!.addLast(crate);
      }
    }

    return value.stacks.values;
  }

  @override
  String postprocess(Iterable<Queue<String>> value) =>
      value.map((stack) => stack.last).join();
}

class Procedure {
  const Procedure(this.stacks, this.rearrangements);

  final Map<int, Queue<String>> stacks;
  final Iterable<Rearrangement> rearrangements;
}

class Rearrangement {
  const Rearrangement({
    required this.amount,
    required this.from,
    required this.to,
  });

  final int amount;
  final int from;
  final int to;
}
