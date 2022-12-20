import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day20 extends Day<List<String>, int> {
  const Day20() : super(20);

  @override
  int processPart1(List<String> input) {
    final mixed = input
        .map(int.parse)
        .mapIndexed((index, value) => MapEntry(index, value))
        .toList();

    for (var i = 0; i < mixed.length; i++) {
      final from = mixed.indexWhere((indexed) => indexed.key == i);
      final to = (from + mixed[from].value) % (mixed.length - 1);
      mixed.move(from, to);
    }

    final zeroIndex = mixed.indexWhere((indexed) => indexed.value == 0);
    return [1000, 2000, 3000]
        .map((index) => (zeroIndex + index) % mixed.length)
        .map((index) => mixed[index].value)
        .sum;
  }
}

extension ListExtension<T> on List<T> {
  void move(int from, int to) {
    var element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }
}
