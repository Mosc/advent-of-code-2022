import 'dart:collection';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day18 extends Day<Set<Cube>, int> {
  const Day18() : super(18);

  @override
  Set<Cube> preprocess(List<String> input) => input
      .map((line) => line.split(',').map(int.parse).toList(growable: false))
      .map((dimensions) => Cube(dimensions[0], dimensions[1], dimensions[2]))
      .toSet();

  @override
  int processPart1(Set<Cube> input) => input
      .map(
        (cube) =>
            cube.adjacent.where((adjacent) => !input.contains(adjacent)).length,
      )
      .sum;

  @override
  int processPart2(Set<Cube> input) {
    final minX = input.map((cube) => cube.x).min - 1;
    final maxX = input.map((cube) => cube.x).max + 1;
    final minY = input.map((cube) => cube.y).min - 1;
    final maxY = input.map((cube) => cube.y).max + 1;
    final minZ = input.map((cube) => cube.z).min - 1;
    final maxZ = input.map((cube) => cube.z).max + 1;

    bool isWithinBounds(Cube cube) =>
        cube.x >= minX &&
        cube.x <= maxX &&
        cube.y >= minY &&
        cube.y <= maxY &&
        cube.z >= minZ &&
        cube.z <= maxZ;

    final queue = Queue<Cube>()..add(Cube(minX, minY, minZ));
    final water = <Cube>{};
    var surfaceArea = 0;

    while (queue.isNotEmpty) {
      final cube = queue.removeFirst();

      for (final adjacent in cube.adjacent) {
        if (input.contains(adjacent)) {
          surfaceArea++;
        } else if (!water.contains(adjacent) && isWithinBounds(adjacent)) {
          queue.add(adjacent);
          water.add(adjacent);
        }
      }
    }

    return surfaceArea;
  }
}

class Cube {
  const Cube(this.x, this.y, this.z);

  final int x;
  final int y;
  final int z;

  List<Cube> get adjacent => [
        Cube(x - 1, y, z),
        Cube(x + 1, y, z),
        Cube(x, y - 1, z),
        Cube(x, y + 1, z),
        Cube(x, y, z - 1),
        Cube(x, y, z + 1),
      ];

  @override
  bool operator ==(Object other) =>
      other is Cube && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'Cube($x, $y, $z)';
}
