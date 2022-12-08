import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day8 extends Day<List<String>, int> {
  const Day8() : super(8);

  @override
  int processPart1(List<String> value) {
    final matrix = <List<Tree>>[];

    for (final line in value) {
      matrix.add(
        line
            .split('')
            .map((height) => Tree(int.parse(height)))
            .toList(growable: false),
      );
    }

    for (int i = 0; i < matrix.length; i++) {
      final currentRow = matrix[i];

      for (int j = 0; j < currentRow.length; j++) {
        final currentColumn =
            matrix.map((row) => row[j]).toList(growable: false);
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

    return matrix.map((row) => row.where((tree) => tree.visible).length).sum;
  }
}

class Tree {
  Tree(this.height) : _visible = true;

  final int height;
  bool _visible;

  get visible => _visible;

  setInvisible() => _visible = false;

  @override
  String toString() => '$height: $visible';
}
