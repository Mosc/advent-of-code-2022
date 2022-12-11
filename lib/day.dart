import 'dart:async';
import 'dart:io';

abstract class Day<T, U> {
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
    FutureOr<U?> Function(T value) process, {
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

  FutureOr<T> preprocess(List<String> input) => input as T;

  FutureOr<U?> processPart1(T input) => null;

  FutureOr<U?> processPart2(T input) => null;

  FutureOr<Object> postprocess(U input) => input.toString();
}
