import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day3 extends Day<List<String>, Iterable<Iterable<Set<String>>>> {
  const Day3() : super(3);

  @override
  Iterable<Iterable<Set<String>>> processPart1(List<String> input) =>
      input.map((line) {
        final halfWay = line.length ~/ 2;
        return [
          line.substring(0, halfWay),
          line.substring(halfWay),
        ].map((splitLine) => splitLine.split('').toSet());
      });

  @override
  Iterable<Iterable<Set<String>>> processPart2(List<String> input) => input
      .asMap()
      .entries
      .groupListsBy((indexedLine) => indexedLine.key ~/ 3)
      .values
      .map(
        (indexedGroup) => indexedGroup.map(
          (indexedLine) => indexedLine.value.split('').toSet(),
        ),
      );

  @override
  int postprocess(Iterable<Iterable<Set<String>>> input) => input.map(
        (group) {
          final duplicate = group
              .fold(
                group.first,
                (previous, current) => previous.intersection(current),
              )
              .single;
          final isUpper = duplicate == duplicate.toUpperCase();
          return duplicate.codeUnits.single -
              (isUpper ? 'A' : 'a').codeUnits.single +
              (isUpper ? 26 : 0) +
              1;
        },
      ).sum;
}
