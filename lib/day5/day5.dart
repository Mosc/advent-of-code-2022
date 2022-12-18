import 'dart:collection';

import 'package:advent_of_code_2022/day.dart';

class Day5 extends Day<Procedure, Iterable<Queue<String>>> {
  const Day5() : super(5);

  @override
  Procedure preprocess(List<String> input) {
    final stackEndIndex = input.indexOf('');
    final stacks = <int, Queue<String>>{};
    final rearrangements = <Rearrangement>[];

    for (final line in input.sublist(0, stackEndIndex - 1)) {
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

    for (final line in input.sublist(stackEndIndex + 1)) {
      final words = line.split(' ');
      final amount = int.parse(words[1]);
      final from = int.parse(words[3]);
      final to = int.parse(words[5]);
      rearrangements.add(Rearrangement(amount: amount, from: from, to: to));
    }

    return Procedure(stacks, rearrangements);
  }

  @override
  Iterable<Queue<String>> processPart1(Procedure input) {
    for (final rearrangement in input.rearrangements) {
      for (int i = 0; i < rearrangement.amount; i++) {
        final crate = input.stacks[rearrangement.from]!.removeLast();
        input.stacks[rearrangement.to]!.addLast(crate);
      }
    }

    return input.stacks.values;
  }

  @override
  Iterable<Queue<String>> processPart2(Procedure input) {
    for (final rearrangement in input.rearrangements) {
      final crates =
          input.stacks[rearrangement.from]!.toList(growable: false).sublist(
                input.stacks[rearrangement.from]!.length - rearrangement.amount,
              );

      for (final crate in crates) {
        input.stacks[rearrangement.from]!.removeLast();
        input.stacks[rearrangement.to]!.addLast(crate);
      }
    }

    return input.stacks.values;
  }

  @override
  String postprocess(Iterable<Queue<String>> input) =>
      input.map((stack) => stack.last).join();
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
