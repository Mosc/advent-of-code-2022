import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day8 extends Day<List<List<Tree>>, int> {
  const Day8() : super(8);

  @override
  List<List<Tree>> preprocess(List<String> input) => input
      .map(
        (line) => line
            .split('')
            .map((height) => Tree(int.parse(height)))
            .toList(growable: false),
      )
      .toList(growable: false);

  @override
  int processPart1(List<List<Tree>> input) {
    for (int i = 0; i < input.length; i++) {
      final currentRow = input[i];

      for (int j = 0; j < currentRow.length; j++) {
        final currentColumn =
            input.map((row) => row[j]).toList(growable: false);
        final currentTree = currentRow[j];

        if (currentRow
                .getRange(0, j)
                .any((tree) => tree.height >= currentTree.height) &&
            currentRow
                .getRange(j + 1, currentRow.length)
                .any((tree) => tree.height >= currentTree.height) &&
            currentColumn
                .getRange(0, i)
                .any((tree) => tree.height >= currentTree.height) &&
            currentColumn
                .getRange(i + 1, currentColumn.length)
                .any((tree) => tree.height >= currentTree.height)) {
          currentTree.setInvisible();
        }
      }
    }

    return input.map((row) => row.where((tree) => tree.visible).length).sum;
  }

  @override
  int processPart2(List<List<Tree>> input) {
    for (int i = 0; i < input.length; i++) {
      final currentRow = input[i];

      for (int j = 0; j < currentRow.length; j++) {
        final currentColumn =
            input.map((row) => row[j]).toList(growable: false);
        final currentTree = currentRow[j];

        final left = currentTree.calculateViewingDistance(
          currentRow.sublist(0, j).reversed.toList(),
          orElse: () => j,
        );
        final right = currentTree.calculateViewingDistance(
          currentRow.sublist(j + 1),
          orElse: () => currentRow.length - j - 1,
        );
        final up = currentTree.calculateViewingDistance(
          currentColumn.sublist(0, i).reversed.toList(),
          orElse: () => i,
        );
        final down = currentTree.calculateViewingDistance(
          currentColumn.sublist(i + 1),
          orElse: () => currentColumn.length - i - 1,
        );

        currentTree.score = left * right * up * down;
      }
    }

    return input.map((row) => row.map((tree) => tree.score).max).max;
  }
}

class Tree {
  Tree(this.height) : _visible = true;

  final int height;
  bool _visible;
  late int score;

  get visible => _visible;

  setInvisible() => _visible = false;

  int calculateViewingDistance(
    List<Tree> trees, {
    required int Function() orElse,
  }) {
    final value = trees.indexWhere((tree) => tree.height >= height);
    return value != -1 ? value + 1 : orElse();
  }
}
