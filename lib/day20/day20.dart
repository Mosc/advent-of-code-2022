import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day20 extends Day<List<MapEntry<int, int>>, List<MapEntry<int, int>>> {
  const Day20() : super(20);

  @override
  List<MapEntry<int, int>> preprocess(List<String> input) => input
      .map(int.parse)
      .mapIndexed((index, value) => MapEntry(index, value))
      .toList();

  @override
  List<MapEntry<int, int>> processPart1(List<MapEntry<int, int>> input) =>
      _mix(input);

  @override
  List<MapEntry<int, int>> processPart2(List<MapEntry<int, int>> input) {
    const decryptionKey = 811589153;
    final decrypted = input
        .map((indexed) => MapEntry(indexed.key, indexed.value * decryptionKey))
        .toList();

    for (var i = 0; i < 10; i++) {
      _mix(decrypted);
    }

    return decrypted;
  }

  List<MapEntry<int, int>> _mix(List<MapEntry<int, int>> input) {
    for (var i = 0; i < input.length; i++) {
      final from = input.indexWhere((indexed) => indexed.key == i);
      final to = (from + input[from].value) % (input.length - 1);
      input.move(from, to);
    }

    return input;
  }

  @override
  int postprocess(List<MapEntry<int, int>> input) {
    final zeroIndex = input.indexWhere((indexed) => indexed.value == 0);
    return [1000, 2000, 3000]
        .map((index) => (zeroIndex + index) % input.length)
        .map((index) => input[index].value)
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
