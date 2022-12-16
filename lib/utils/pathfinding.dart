import 'package:collection/collection.dart';

// Based on https://github.com/darrenaustin/advent-of-code-dart/blob/main/lib/src/util/pathfinding.dart.
double? dijkstraLowestCost<L>({
  required L start,
  required L goal,
  required double Function(L, L) costTo,
  required Iterable<L> Function(L) neighborsOf,
}) {
  final dist = <L, double>{start: 0};
  final prev = <L, L>{};
  final queue = PriorityQueue<L>(
    (L a, L b) =>
        (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity),
  )..add(start);

  while (queue.isNotEmpty) {
    var current = queue.removeFirst();

    if (current == goal) {
      return dist[goal];
    }

    for (final neighbor in neighborsOf(current)) {
      if (!prev.containsKey(neighbor)) {
        final score = dist[current]! + costTo(current, neighbor);

        if (score < (dist[neighbor] ?? double.infinity)) {
          dist[neighbor] = score;
          prev[neighbor] = current;
          queue.add(neighbor);
        }
      }
    }
  }

  return null;
}
