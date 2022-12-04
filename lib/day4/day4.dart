import 'dart:io';

Future<void> calculate() async {
  final lines = File('lib/day4/input').readAsLinesSync();

  var part1 = await _calculatePart1(lines);

  print('Day 3');
  print('Part 1: $part1');
  print('');
}

Future<int> _calculatePart1(Iterable<String> lines) async {
  final sections = lines.map(
    (line) => line.split(',').map((sections) {
      final split = sections.split('-').map(int.parse);
      final from = split.first;
      final to = split.last;
      return List.generate(to - from + 1, (index) => from + index).toSet();
    }),
  );
  return sections
      .where(
        (sectionPair) =>
            (sectionPair.first..removeAll(sectionPair.last)).isEmpty ||
            (sectionPair.last..removeAll(sectionPair.first)).isEmpty,
      )
      .length;
}
