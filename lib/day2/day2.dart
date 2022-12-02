import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final lines = File('lib/day2/input').readAsLinesSync();
  final symbols = lines.map((line) => line.split(' '));

  var part1 = await _calculatePart1(symbols);
  var part2 = await _calculatePart2(symbols);

  print('Day 2');
  print('Part 1: $part1');
  print('Part 2: $part2');
  print('');
}

Future<int> _calculatePart1(Iterable<Iterable<String>> symbols) async {
  final rounds = symbols.map(
    (symbolPair) => symbolPair.map((symbol) => Shape.fromSymbol(symbol)),
  );
  return _sumTotalScore(rounds);
}

Future<int> _calculatePart2(Iterable<Iterable<String>> symbols) async {
  final rounds = symbols
      .map(
        (symbolPair) => Pair<Shape, Result>(
          Shape.fromSymbol(symbolPair.first),
          Result.fromSymbol(symbolPair.last),
        ),
      )
      .map(
        (round) => [
          round.first,
          Shape.values.singleWhere(
            (shape) => shape.roundScore(round.first) == round.second.score,
          ),
        ],
      );
  return _sumTotalScore(rounds);
}

int _sumTotalScore(Iterable<Iterable<Shape>> rounds) => rounds
    .map((round) => round.last.shapeScore + round.last.roundScore(round.first))
    .sum;

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  const Pair(this.first, this.second);
}

enum Shape {
  rock(1),
  paper(2),
  scissors(3);

  const Shape(this.shapeScore);

  final int shapeScore;

  int roundScore(Shape other) =>
      (((index - other.index) + 1) % Shape.values.length) * 3;

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

enum Result {
  lose,
  draw,
  win;

  int get score => index * 3;

  static Result fromSymbol(String symbol) {
    switch (symbol) {
      case 'X':
        return lose;
      case 'Y':
        return draw;
      case 'Z':
        return win;
    }

    throw Exception();
  }
}
