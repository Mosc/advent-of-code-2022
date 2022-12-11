import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day11 extends Day<List<Monkey>, List<Monkey>> {
  const Day11() : super(11);

  @override
  List<Monkey> preprocess(List<String> input) {
    final monkeys = <Monkey>[];

    for (int i = 0; i < input.length; i += 7) {
      final monkeyLines = input
          .skip(i)
          .take(6)
          .map((line) => line.split(':').last.trim())
          .toList();
      final startingItems = monkeyLines[1].split(', ').map(int.parse).toList();
      final operation = monkeyLines[2].split('=')[1].trim().split(' ').toList();
      final testDivisibleBy = int.parse(monkeyLines[3].split(' ').last);
      final ifTestTrueThrowTo = int.parse(monkeyLines[4].split(' ').last);
      final ifTestFalseThrowTo = int.parse(monkeyLines[5].split(' ').last);

      monkeys.add(
        Monkey(
          items: startingItems,
          operation: operation,
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
    const rounds = 20;

    for (int round = 0; round < rounds; round++) {
      for (final monkey in input) {
        monkey.play(
          input,
          manageWorryLevel: (worryLevel) => worryLevel ~/ 3,
        );
      }
    }

    return input;
  }

  @override
  List<Monkey> processPart2(List<Monkey> input) {
    const rounds = 10000;
    final commonMultiplier = input
        .map((monkey) => monkey.testDivisibleBy)
        .fold(1, (total, divisibleBy) => total * divisibleBy);

    for (int round = 0; round < rounds; round++) {
      for (final monkey in input) {
        monkey.play(
          input,
          manageWorryLevel: (worryLevel) => worryLevel %= commonMultiplier,
        );
      }
    }

    return input;
  }

  @override
  int postprocess(List<Monkey> input) => input
      .map((monkey) => monkey.inspections)
      .sorted((a, b) => b.compareTo(a))
      .take(2)
      .reduce((total, inspections) => total * inspections);
}

class Monkey {
  Monkey({
    required this.items,
    required this.operation,
    required this.testDivisibleBy,
    required this.ifTestTrueThrowTo,
    required this.ifTestFalseThrowTo,
  }) : inspections = 0;

  final List<int> items;
  final List<String> operation;
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

      final left = operation[0] == 'old' ? item : int.parse(operation[0]);
      final right = operation[2] == 'old' ? item : int.parse(operation[2]);

      if (operation[1] == '+') {
        worryLevel = left + right;
      } else if (operation[1] == '*') {
        worryLevel = left * right;
      }

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
