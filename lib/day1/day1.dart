import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  await _calculatePart1();
}

Future<void> _calculatePart1() async {
  final Iterable<String> lines = File('lib/day1/input').readAsLinesSync();

  final caloriesPerElf = lines
      .split(on: (line) => line.isEmpty)
      .map((line) => line.map(int.parse));
  final caloriesSumPerElf = caloriesPerElf.map((calories) => calories.sum);
  final maxCalories = caloriesSumPerElf.reduce(max);
  print(maxCalories);
}

extension _Iterablextension<T> on Iterable<T> {
  Iterable<Iterable<T>> split({required bool Function(T) on}) sync* {
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
