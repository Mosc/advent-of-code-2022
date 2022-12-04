import 'dart:io';

Future<void> calculate() async {
  final lines = File('lib/day4/input').readAsLinesSync();
  final sections = lines.map(
    (line) => line.split(',').map((sections) {
      final split = sections.split('-').map(int.parse);
      final from = split.first;
      final to = split.last;
      return List.generate(to - from + 1, (index) => from + index).toSet();
    }),
  );

  var part1 = await _calculatePart1(sections);
  var part2 = await _calculatePart2(sections);

  print('Day 3');
  print('Part 1: $part1');
  print('Part 2: $part2');
  print('');
}

Future<int> _calculatePart1(Iterable<Iterable<Set<int>>> sections) async {
  return sections
      .where(
        (sectionPair) =>
            (sectionPair.first..removeAll(sectionPair.last)).isEmpty ||
            (sectionPair.last..removeAll(sectionPair.first)).isEmpty,
      )
      .length;
}

Future<int> _calculatePart2(Iterable<Iterable<Set<int>>> sections) async {
  return sections
      .where(
        (sectionPair) =>
            sectionPair.first.intersection(sectionPair.last).isNotEmpty,
      )
      .length;
}
