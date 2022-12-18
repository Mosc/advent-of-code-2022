import 'package:advent_of_code_2022/day.dart';

class Day4
    extends Day<Iterable<Iterable<Set<int>>>, Iterable<Iterable<Set<int>>>> {
  const Day4() : super(4);

  @override
  Iterable<Iterable<Set<int>>> preprocess(Iterable<String> input) => input.map(
        (line) => line.split(',').map((sections) {
          final split = sections.split('-').map(int.parse);
          final from = split.first;
          final to = split.last;
          return Iterable.generate(to - from + 1, (index) => from + index)
              .toSet();
        }),
      );

  @override
  Iterable<Iterable<Set<int>>> processPart1(
    Iterable<Iterable<Set<int>>> input,
  ) =>
      input.where(
        (sectionPair) =>
            (sectionPair.first..removeAll(sectionPair.last)).isEmpty ||
            (sectionPair.last..removeAll(sectionPair.first)).isEmpty,
      );

  @override
  Iterable<Iterable<Set<int>>> processPart2(
    Iterable<Iterable<Set<int>>> input,
  ) =>
      input.where(
        (sectionPair) =>
            sectionPair.first.intersection(sectionPair.last).isNotEmpty,
      );

  @override
  int postprocess(Iterable<Iterable<Set<int>>> input) => input.length;
}
