import 'dart:collection';
import 'dart:io';

Future<void> calculate() async {
  final lines = File('lib/day5/input').readAsLinesSync();

  var part1 = await _calculatePart1(lines);
  var part2 = await _calculatePart2(lines);

  print('Day 5');
  print('Part 1: $part1');
  print('Part 2: $part2');
  print('');
}

Future<String> _calculatePart1(List<String> lines) async {
  final stackEndIndex = lines.indexOf('');
  final stacks = <int, Queue<String>>{};

  for (final line in lines.sublist(0, stackEndIndex - 1)) {
    final stackCount = (line.length + 1) ~/ 4;

    for (var i = 1; i < stackCount + 1; i++) {
      if (stacks[i] == null) {
        stacks[i] = Queue<String>();
      }

      var crate = line[i * 4 - 3];

      if (crate != ' ') {
        stacks[i]!.addFirst(crate);
      }
    }
  }

  for (final line in lines.sublist(stackEndIndex + 1)) {
    final words = line.split(' ');
    final amount = int.parse(words[1]);
    final from = int.parse(words[3]);
    final to = int.parse(words[5]);

    for (int i = 0; i < amount; i++) {
      final crate = stacks[from]!.removeLast();
      stacks[to]!.addLast(crate);
    }
  }

  return stacks.values.map((stack) => stack.last).join();
}

Future<String> _calculatePart2(List<String> lines) async {
  final stackEndIndex = lines.indexOf('');
  final stacks = <int, Queue<String>>{};

  for (final line in lines.sublist(0, stackEndIndex - 1)) {
    final stackCount = (line.length + 1) ~/ 4;

    for (var i = 1; i < stackCount + 1; i++) {
      if (stacks[i] == null) {
        stacks[i] = Queue<String>();
      }

      var crate = line[i * 4 - 3];

      if (crate != ' ') {
        stacks[i]!.addFirst(crate);
      }
    }
  }

  for (final line in lines.sublist(stackEndIndex + 1)) {
    final words = line.split(' ');
    final amount = int.parse(words[1]);
    final from = int.parse(words[3]);
    final to = int.parse(words[5]);
    final crates =
        stacks[from]!.toList().sublist(stacks[from]!.length - amount);

    for (final crate in crates) {
      stacks[from]!.removeLast();
      stacks[to]!.addLast(crate);
    }
  }

  return stacks.values.map((stack) => stack.last).join();
}
