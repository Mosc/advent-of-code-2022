import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day10 extends Day<List<String>, String> {
  const Day10() : super(10);

  @override
  String processPart1(List<String> value) {
    final interestingCycles =
        List<int>.generate(6, (index) => index * 40 + 20, growable: false);
    final signalStrengths = <int, int>{};
    var cycle = 1;
    var x = 1;

    for (final line in value) {
      final tokens = line.split(' ');
      late final Op op;

      if (tokens[0] == 'addx') {
        op = Op(cycleLength: 2, execute: () => x += int.parse(tokens[1]));
      } else if (tokens[0] == 'noop') {
        op = Op(cycleLength: 1);
      }

      for (var i = 0; i < op.cycleLength; i++) {
        signalStrengths[cycle] = cycle * x;
        cycle++;
      }

      op.execute?.call();
    }

    return signalStrengths.entries
        .where(
          (signalStrength) => interestingCycles.contains(signalStrength.key),
        )
        .map((signalStrength) => signalStrength.value)
        .sum
        .toString();
  }

  @override
  String processPart2(List<String> value) {
    const rowLength = 40;
    final crt = <List<bool>>[];
    var cycle = 1;
    var x = 1;

    for (final line in value) {
      final tokens = line.split(' ');
      late final Op op;

      if (tokens[0] == 'addx') {
        op = Op(cycleLength: 2, execute: () => x += int.parse(tokens[1]));
      } else if (tokens[0] == 'noop') {
        op = Op(cycleLength: 1);
      }

      for (var i = 0; i < op.cycleLength; i++) {
        final row = (cycle - 1) ~/ rowLength;

        if (row > crt.length - 1) {
          crt.add(<bool>[]);
        }

        crt[row].add((cycle % rowLength - x - 1).abs() <= 1);

        cycle++;
      }

      op.execute?.call();
    }

    return [
      '',
      crt.map((row) => row.map((pixel) => pixel ? '#' : '.').join()).join('\n')
    ].join('\n');
  }
}

class Op {
  const Op({required this.cycleLength, this.execute});

  final int cycleLength;
  final void Function()? execute;
}
