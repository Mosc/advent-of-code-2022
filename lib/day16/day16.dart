import 'package:advent_of_code_2022/day.dart';
import 'package:advent_of_code_2022/utils/pathfinding.dart';
import 'package:collection/collection.dart';

class Day16 extends Day<List<String>, int> {
  const Day16() : super(16);

  @override
  int processPart1(List<String> input) {
    final valveMap = <String, Valve>{};

    for (final line in input) {
      final valve = Valve.parse(line);
      valveMap[valve.name] = valve;
    }

    final start = valveMap['AA']!;
    final relevantValves = valveMap.values
        .where((valve) => valve == start || valve.rate > 0)
        .toList(growable: false);

    for (final valve1 in relevantValves) {
      valve1.neighbors = Map<Valve, int>.fromEntries(
        relevantValves
            .where((valve2) => valve1 != valve2)
            .map(
              (valve2) => MapEntry(
                valve2,
                dijkstraLowestCost(
                  start: valve1,
                  goal: valve2,
                  costTo: (a, b) => 1,
                  neighborsOf: (current) =>
                      current.leadsTo.map((name) => valveMap[name]!),
                )?.toInt(),
              ),
            )
            .where((entry) => entry.value != null)
            .map((entry) => MapEntry(entry.key, entry.value!)),
      );
    }

    return start
        .getPressureCandidates(timeRemaining: 30)
        .map((pressures) => pressures.sum)
        .max;
  }
}

class Valve {
  Valve(this.name, this.rate, this.leadsTo);

  factory Valve.parse(String line) {
    final split = line.split(' ');
    final name = split[1];
    final rate = int.parse(split[4].split(';').first.split('=').last);
    final leadsToNames = split.skip(9).map((e) => e.split(',').first).toSet();
    return Valve(name, rate, leadsToNames);
  }

  final String name;
  final int rate;
  final Set<String> leadsTo;
  late Map<Valve, int> neighbors;

  Iterable<List<int>> getPressureCandidates({
    List<MapEntry<Valve, int>> opened = const [],
    required int timeRemaining,
  }) sync* {
    final relevantValves = neighbors.keys.where(
      (neighbor) => !opened.map((valve) => valve.key).contains(neighbor),
    );
    final pressure = rate * timeRemaining;

    if (timeRemaining > 0 && relevantValves.isNotEmpty) {
      for (var valve in relevantValves) {
        yield* valve.getPressureCandidates(
          opened: [...opened, MapEntry(this, pressure)],
          timeRemaining: timeRemaining - neighbors[valve]! - 1,
        );
      }
    } else {
      yield [...opened.map((valve) => valve.value), pressure];
    }
  }

  @override
  String toString() => 'Valve $name';
}
