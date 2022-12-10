import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day10 extends Day<List<String>, int> {
  const Day10() : super(10);

  @override
  int processPart1(List<String> value) {
    var cycle = 1;
    var x = 1;
    final interestingCycles =
        List<int>.generate(6, (index) => index * 40 + 20, growable: false);
    final signalStrengths = <int, int>{};

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
        .sum;
  }
}

class Op {
  const Op({required this.cycleLength, this.execute});

  final int cycleLength;
  final void Function()? execute;
}
