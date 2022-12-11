import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day2 extends Day<Iterable<Iterable<String>>, Iterable<Iterable<Shape>>> {
  const Day2() : super(2);

  @override
  Iterable<Iterable<String>> preprocess(List<String> input) =>
      input.map((line) => line.split(' '));

  @override
  Iterable<Iterable<Shape>> processPart1(Iterable<Iterable<String>> input) =>
      input.map(
        (symbolPair) => symbolPair.map((symbol) => Shape.fromSymbol(symbol)),
      );

  @override
  Iterable<Iterable<Shape>> processPart2(Iterable<Iterable<String>> input) =>
      input.map((symbolPair) {
        final shape = Shape.fromSymbol(symbolPair.first);
        final result = Result.fromSymbol(symbolPair.last);
        return [
          shape,
          Shape.values.singleWhere(
            (ourShape) => ourShape.roundScore(shape) == result.score,
          ),
        ];
      });

  @override
  int postprocess(Iterable<Iterable<Shape>> input) => input
      .map(
        (round) => round.last.shapeScore + round.last.roundScore(round.first),
      )
      .sum;
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
