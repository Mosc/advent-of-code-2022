import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day11 extends Day<List<Monkey>, List<Monkey>> {
  const Day11() : super(11);

  @override
  List<Monkey> preprocess(List<String> input) {
    Operator parseOperator(String operator) {
      switch (operator) {
        case '+':
          return Operator.add;
        case '*':
          return Operator.multiply;
      }

      throw Exception();
    }

    int? parseOperationPart(String part) =>
        part == 'old' ? null : int.parse(part);

    final monkeys = <Monkey>[];

    for (int i = 0; i < input.length; i += 7) {
      final monkeyLines = input
          .skip(i)
          .take(6)
          .map((line) => line.split(':').last.trim())
          .toList(growable: false);
      final startingItems = monkeyLines[1].split(', ').map(int.parse).toList();
      final operationParts = monkeyLines[2]
          .split('=')[1]
          .trim()
          .split(' ')
          .toList(growable: false);
      final operator = parseOperator(operationParts[1]);
      final operationLeft = parseOperationPart(operationParts[0]);
      final operationRight = parseOperationPart(operationParts[2]);
      final testDivisibleBy = int.parse(monkeyLines[3].split(' ').last);
      final ifTestTrueThrowTo = int.parse(monkeyLines[4].split(' ').last);
      final ifTestFalseThrowTo = int.parse(monkeyLines[5].split(' ').last);

      monkeys.add(
        Monkey(
          items: startingItems,
          operator: operator,
          operationLeft: operationLeft,
          operationRight: operationRight,
          testDivisibleBy: testDivisibleBy,
          ifTestTrueThrowTo: ifTestTrueThrowTo,
          ifTestFalseThrowTo: ifTestFalseThrowTo,
        ),
      );
    }

    return monkeys;
  }

  @override
  List<Monkey> processPart1(List<Monkey> input) {
    return _playRounds(
      input,
      rounds: 20,
      manageWorryLevel: (worryLevel) => worryLevel ~/ 3,
    );
  }

  @override
  List<Monkey> processPart2(List<Monkey> input) {
    final commonMultiple = input
        .map((monkey) => monkey.testDivisibleBy)
        .fold(1, (total, divisibleBy) => total * divisibleBy);

    return _playRounds(
      input,
      rounds: 10000,
      manageWorryLevel: (worryLevel) => worryLevel %= commonMultiple,
    );
  }

  @override
  int postprocess(List<Monkey> input) => input
      .map((monkey) => monkey.inspections)
      .sorted((a, b) => b.compareTo(a))
      .take(2)
      .reduce((total, inspections) => total * inspections);

  List<Monkey> _playRounds(
    List<Monkey> monkeys, {
    required int rounds,
    required int Function(int worryLevel) manageWorryLevel,
  }) {
    for (int round = 0; round < rounds; round++) {
      for (final monkey in monkeys) {
        monkey.play(
          monkeys,
          manageWorryLevel: manageWorryLevel,
        );
      }
    }

    return monkeys;
  }
}

class Monkey {
  Monkey({
    required this.items,
    required this.operator,
    required this.operationLeft,
    required this.operationRight,
    required this.testDivisibleBy,
    required this.ifTestTrueThrowTo,
    required this.ifTestFalseThrowTo,
  }) : inspections = 0;

  final List<int> items;
  final Operator operator;
  final int? operationLeft;
  final int? operationRight;
  final int testDivisibleBy;
  final int ifTestTrueThrowTo;
  final int ifTestFalseThrowTo;

  int inspections;

  void play(
    List<Monkey> monkeys, {
    required int Function(int worryLevel) manageWorryLevel,
  }) {
    for (var item in items) {
      var worryLevel = item;

      worryLevel = operator.run(
        operationLeft ?? worryLevel,
        operationRight ?? worryLevel,
      );
      worryLevel = manageWorryLevel(worryLevel);

      final throwTo = worryLevel % testDivisibleBy == 0
          ? ifTestTrueThrowTo
          : ifTestFalseThrowTo;
      monkeys[throwTo].addItem(worryLevel);

      inspections++;
    }

    items.clear();
  }

  void addItem(int item) => items.add(item);
}

enum Operator {
  add,
  multiply;

  const Operator();

  int run(int left, int right) {
    switch (this) {
      case add:
        return left + right;
      case multiply:
        return left * right;
    }
  }
}
