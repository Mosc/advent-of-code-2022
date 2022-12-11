import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day11 extends Day<List<String>, int> {
  const Day11() : super(11);

  @override
  int processPart1(List<String> value) {
    final monkeys = <Monkey>[];

    for (int i = 0; i < value.length; i += 7) {
      final monkeyLines = value
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

    for (int round = 0; round < 20; round++) {
      for (final monkey in monkeys) {
        monkey.play(monkeys);
      }
    }

    return monkeys
        .map((monkey) => monkey.inspections)
        .sorted((a, b) => b.compareTo(a))
        .take(2)
        .reduce((total, inspections) => total * inspections);
  }
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

  void play(List<Monkey> monkeys) {
    for (var item in items) {
      var worryLevel = item;

      final left = operation[0] == 'old' ? item : int.parse(operation[0]);
      final right = operation[2] == 'old' ? item : int.parse(operation[2]);

      if (operation[1] == '+') {
        worryLevel = left + right;
      } else if (operation[1] == '*') {
        worryLevel = left * right;
      }

      worryLevel ~/= 3;

      final throwTo = worryLevel % testDivisibleBy == 0
          ? ifTestTrueThrowTo
          : ifTestFalseThrowTo;
      monkeys[throwTo].addItem(worryLevel);

      inspections++;
    }

    items.clear();
  }

  void addItem(int item) {
    items.add(item);
  }
}
