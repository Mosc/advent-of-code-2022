import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final lines = File('lib/day2/input').readAsLinesSync();

  var part1 = await _calculatePart1(lines);

  print('Day 2');
  print('Part 1: $part1');
  print('');
}

Future<int> _calculatePart1(Iterable<String> lines) async {
  final pairs = lines
      .map((line) => line.split(' ').map((symbol) => Shape.fromSymbol(symbol)));
  final score = pairs
      .map((pair) => (pair.last.shapeScore + pair.last.roundScore(pair.first)))
      .sum;
  return score;
}

enum Shape {
  rock(1),
  paper(2),
  scissors(3);

  const Shape(this.shapeScore);

  final int shapeScore;

  int roundScore(Shape other) =>
      (((index - other.index) + 1) % Shape.values.length) * Shape.values.length;

  static Shape fromSymbol(String symbol) {
    switch (symbol) {
      case 'A':
      case 'X':
        return rock;
      case 'B':
      case 'Y':
        return paper;
      case 'C':
      case 'Z':
        return scissors;
    }

    throw Exception();
  }
}
