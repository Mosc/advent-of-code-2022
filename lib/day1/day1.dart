import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day1 extends Day<Iterable<int>, int> {
  const Day1() : super(1);

  @override
  Iterable<int> preprocess(List<String> value) => value
      .split((line) => line.isEmpty)
      .map((line) => line.map(int.parse).sum);

  @override
  int processPart1(Iterable<int> value) => value.max;

  @override
  int processPart2(Iterable<int> value) =>
      value.sorted((a, b) => b.compareTo(a)).take(3).sum;
}

extension _Iterablextension<T> on Iterable<T> {
  Iterable<Iterable<T>> split(bool Function(T) on) sync* {
    final List<T> innerList = [];

    for (final row in this) {
      if (!on(row)) {
        innerList.add(row);
      } else if (innerList.isNotEmpty) {
        yield innerList;
        innerList.clear();
      }
    }

    if (innerList.isNotEmpty) {
      yield innerList;
    }
  }
}
