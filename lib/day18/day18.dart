import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day18 extends Day<Set<Cube>, int> {
  const Day18() : super(18);

  @override
  Set<Cube> preprocess(List<String> input) => input
      .map((line) => line.split(',').map(int.parse).toList())
      .map((dimensions) => Cube(dimensions[0], dimensions[1], dimensions[2]))
      .toSet();

  @override
  int processPart1(Set<Cube> input) => input
      .map(
        (cube) =>
            cube.adjacent.where((adjacent) => !input.contains(adjacent)).length,
      )
      .sum;
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
