import 'package:advent_of_code_2022/day.dart';

class Day21 extends Day<List<String>, int> {
  const Day21() : super(21);

  @override
  int processPart1(List<String> input) {
    const rootName = 'root';
    final monkeys = <String, Monkey>{};

    for (final line in input) {
      final tokens = line.split(': ');
      monkeys[tokens[0]] = Monkey.parse(name: tokens[0], job: tokens[1]);
    }

    while (monkeys[rootName] is! NumberMonkey) {
      for (final monkey in monkeys.values.whereType<MathMonkey>()) {
        if (monkey.canSolve(monkeys)) {
          monkeys[monkey.name] = NumberMonkey(
            name: monkey.name,
            number: monkey.solve(monkeys),
          );
        }
      }
    }

    return (monkeys[rootName] as NumberMonkey).number;
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
  divide;

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
    }
  }
}
