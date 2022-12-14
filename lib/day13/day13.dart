import 'dart:convert';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day13 extends Day<Iterable<bool>, int> {
  const Day13() : super(13);

  @override
  Iterable<bool> preprocess(List<String> input) sync* {
    for (int i = 0; i < input.length; i += 3) {
      final left = jsonDecode(input[i]) as List<dynamic>;
      final right = jsonDecode(input[i + 1]) as List<dynamic>;
      yield _isInOrder(left, right)!;
    }
  }

  @override
  int processPart1(Iterable<bool> input) =>
      input.mapIndexed((index, inOrder) => inOrder ? index + 1 : 0).sum;

  bool? _isInOrder(List<dynamic> left, List<dynamic> right) {
    for (int i = 0; i < left.length; i++) {
      final bool? inOrder;

      if (i >= right.length) {
        inOrder = false;
      } else if (left[i] is List<dynamic> && right[i] is List<dynamic>) {
        inOrder = _isInOrder(left[i], right[i]);
      } else if (left[i] is int && right[i] is List<dynamic>) {
        inOrder = _isInOrder([left[i]], right[i]);
      } else if (left[i] is List<dynamic> && right[i] is int) {
        inOrder = _isInOrder(left[i], [right[i]]);
      } else if (left[i] < right[i]) {
        inOrder = true;
      } else if (left[i] > right[i]) {
        inOrder = false;
      } else {
        inOrder = null;
      }

      if (inOrder != null) {
        return inOrder;
      }
    }

    if (left.length < right.length) {
      return true;
    }

    return null;
  }
}
