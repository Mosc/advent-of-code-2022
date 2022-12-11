import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day6 extends Day<List<int>, int> {
  const Day6() : super(6);

  @override
  List<int> preprocess(List<String> input) => input.single.codeUnits;

  @override
  int processPart1(List<int> input) => _findMarker(input, markerLength: 4);

  @override
  int processPart2(List<int> input) => _findMarker(input, markerLength: 14);

  int _findMarker(List<int> input, {required int markerLength}) =>
      input
          .sublist(0, input.length - markerLength + 1)
          .mapIndexed(
            (index, _) => MapEntry(
              index,
              input.sublist(index, index + markerLength).toSet().length,
            ),
          )
          .firstWhere((indexedLength) => indexedLength.value == markerLength)
          .key +
      markerLength;
}
