import 'dart:async';
import 'dart:io';

abstract class Day<IN, OUT> {
  const Day(this.number, {this.example = false});

  final int number;
  final bool example;

  FutureOr<void> calculate() async {
    final lines = File('lib/day$number/${example ? 'example' : 'input'}')
        .readAsLinesSync();

    print('Day $number');
    await calculatePart(1, processPart1, lines: lines);
    await calculatePart(2, processPart2, lines: lines);
    print('');
  }

  Future<void> calculatePart(
    int i,
    FutureOr<OUT?> Function(IN value) process, {
    required List<String> lines,
  }) async {
    final stopwatch = Stopwatch()..start();
    final part = await process(await preprocess(lines));

    if (part != null) {
      final postPart = await postprocess(part);
      stopwatch.stop();
      print('Part $i: $postPart (${stopwatch.elapsedMilliseconds}ms)');
    }
  }

  FutureOr<IN> preprocess(List<String> value) => value as IN;

  FutureOr<OUT?> processPart1(IN value) => null;

  FutureOr<OUT?> processPart2(IN value) => null;

  FutureOr<Object> postprocess(OUT value) => value.toString();
}
