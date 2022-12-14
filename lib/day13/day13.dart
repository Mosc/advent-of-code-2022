import 'dart:convert';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day13 extends Day<Iterable<dynamic>, int> {
  const Day13() : super(13);

  @override
  Iterable<dynamic> preprocess(List<String> input) sync* {
    for (int i = 0; i < input.length; i += 3) {
      yield jsonDecode(input[i]) as List<dynamic>;
      yield jsonDecode(input[i + 1]) as List<dynamic>;
    }
  }

  @override
  int processPart1(Iterable<dynamic> input) {
    final inOrders = _getInOrders([...input]);
    return inOrders.mapIndexed((index, inOrder) => inOrder ? index + 1 : 0).sum;
  }

  @override
  int processPart2(Iterable<dynamic> input) {
    const dividers = [
      [
        [2]
      ],
      [
        [6]
      ],
    ];
    final lines = [...input, ...dividers].sorted((a, b) => _isInOrder(a, b));
    return dividers
        .map((divider) => lines.indexOf(divider) + 1)
        .reduce((total, index) => total * index);
  }

  Iterable<bool> _getInOrders(List<dynamic> lines) sync* {
    for (int i = 0; i < lines.length; i += 2) {
      yield _isInOrder(lines[i], lines[i + 1]) < 0;
    }
  }

  int _isInOrder(List<dynamic> left, List<dynamic> right) {
    for (int i = 0; i < left.length; i++) {
      final int result;

      if (i >= right.length) {
        result = 1;
      } else if (left[i] is List<dynamic> && right[i] is List<dynamic>) {
        result = _isInOrder(left[i], right[i]);
      } else if (left[i] is int && right[i] is List<dynamic>) {
        result = _isInOrder([left[i]], right[i]);
      } else if (left[i] is List<dynamic> && right[i] is int) {
        result = _isInOrder(left[i], [right[i]]);
      } else if (left[i] < right[i]) {
        result = -1;
      } else if (left[i] > right[i]) {
        result = 1;
      } else {
        result = 0;
      }

      if (result != 0) {
        return result;
      }
    }

    if (left.length < right.length) {
      return -1;
    }

    return 0;
  }
}
