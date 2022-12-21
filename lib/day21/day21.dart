import 'package:advent_of_code_2022/day.dart';

class Day21 extends Day<Map<String, Monkey>, int> {
  const Day21() : super(21);

  static const rootName = 'root';
  static const humanName = 'humn';

  @override
  Map<String, Monkey> preprocess(List<String> input) {
    final monkeys = <String, Monkey>{};

    for (final line in input) {
      final tokens = line.split(': ');
      monkeys[tokens[0]] = Monkey.parse(name: tokens[0], job: tokens[1]);
    }

    return monkeys;
  }

  @override
  int processPart1(Map<String, Monkey> input) {
    final monkeys = input;

    while (monkeys[rootName] is! NumberMonkey) {
      for (final mathMonkey in monkeys.values.whereType<MathMonkey>()) {
        if (mathMonkey.canSolve(monkeys)) {
          monkeys[mathMonkey.name] = NumberMonkey(
            name: mathMonkey.name,
            number: mathMonkey.solve(monkeys),
          );
        }
      }
    }

    return (monkeys[rootName] as NumberMonkey).number;
  }

  @override
  int processPart2(Map<String, Monkey> input) {
    final rootMonkey = input[rootName] as MathMonkey;
    input[rootName] = MathMonkey(
      name: rootName,
      left: rootMonkey.left,
      operator: Operator.equals,
      right: rootMonkey.right,
    );

    var minHumanNumber = 0;
    var maxHumanNumber = 1 << 48;
    var humanNumber = minHumanNumber;

    while (true) {
      final monkeys = Map<String, Monkey>.from(input);
      monkeys[humanName] = NumberMonkey(name: humanName, number: humanNumber);

      while (monkeys[rootName] is! NumberMonkey) {
        for (final mathMonkey in monkeys.values.whereType<MathMonkey>()) {
          if (mathMonkey.canSolve(monkeys)) {
            final numberMonkey = NumberMonkey(
              name: mathMonkey.name,
              number: mathMonkey.solve(monkeys),
            );
            monkeys[mathMonkey.name] = numberMonkey;

            if (mathMonkey.name == rootName) {
              // Note: We're making an assumption here that "humn" is part of the right side of the
              // tree. That works on our input, but breaks on the example and possibly other inputs.
              if (numberMonkey.number > 0) {
                minHumanNumber = humanNumber;
              } else if (numberMonkey.number < 0) {
                maxHumanNumber = humanNumber;
              } else {
                return humanNumber;
              }

              humanNumber = (maxHumanNumber + minHumanNumber) ~/ 2;
            }
          }
        }
      }
    }
  }
}

abstract class Monkey {
  const Monkey({required this.name});

  factory Monkey.parse({required String name, required String job}) {
    final tokens = job.split(' ');

    if (tokens.length == 1) {
      return NumberMonkey(
        name: name,
        number: int.parse(tokens.single),
      );
    } else {
      return MathMonkey(
        name: name,
        left: tokens[0],
        operator: Operator.parse(tokens[1]),
        right: tokens[2],
      );
    }
  }

  final String name;
}

class NumberMonkey extends Monkey {
  const NumberMonkey({
    required super.name,
    required this.number,
  });

  final int number;
}

class MathMonkey extends Monkey {
  const MathMonkey({
    required super.name,
    required this.left,
    required this.operator,
    required this.right,
  });

  final String left;
  final Operator operator;
  final String right;

  bool canSolve(Map<String, Monkey> monkeys) =>
      monkeys[left] is NumberMonkey && monkeys[right] is NumberMonkey;

  int solve(Map<String, Monkey> monkeys) => operator.run(
        (monkeys[left] as NumberMonkey).number,
        (monkeys[right] as NumberMonkey).number,
      );
}

enum Operator {
  add,
  subtract,
  multiply,
  divide,
  equals;

  const Operator();

  static Operator parse(String token) {
    switch (token) {
      case '+':
        return Operator.add;
      case '-':
        return Operator.subtract;
      case '*':
        return Operator.multiply;
      case '/':
        return Operator.divide;
    }

    throw Exception();
  }

  int run(int left, int right) {
    switch (this) {
      case Operator.add:
        return left + right;
      case Operator.multiply:
        return left * right;
      case Operator.subtract:
        return left - right;
      case Operator.divide:
        return left ~/ right;
      case Operator.equals:
        return left.compareTo(right);
    }
  }
}
