import 'dart:async';
import 'dart:io';

abstract class Day<IN, OUT> {
  const Day(this.number, {this.example = false});

  final int number;
  final bool example;

  FutureOr<void> calculate() async {
    final lines = File('lib/day$number/${example ? 'example' : 'input'}')
        .readAsLinesSync();
    final part1 = await processPart1(await preprocess(lines));
    final part2 = await processPart2(await preprocess(lines));

    print('Day $number');
    if (part1 != null) print('Part 1: ${await postprocess(part1)}');
    if (part2 != null) print('Part 2: ${await postprocess(part2)}');
    print('');
  }

  FutureOr<IN> preprocess(List<String> value) => value as IN;

  FutureOr<OUT?> processPart1(IN value) => null;

  FutureOr<OUT?> processPart2(IN value) => null;

  FutureOr<Object> postprocess(OUT value) => value.toString();
}
