import 'dart:collection';
import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day19 extends Day<List<String>, int> {
  const Day19() : super(19);

  @override
  int processPart1(List<String> input) {
    final blueprints = <Blueprint>[];

    for (final line in input) {
      final id =
          int.parse(RegExp(r'Blueprint (\d+)').firstMatch(line)!.group(1)!);
      final matches =
          RegExp(r'Each (\w+) robot costs (\d+) (\w+)(?: and (\d+) (\w+))*.')
              .allMatches(line);

      final costs = <Resource, Map<Resource, int>>{};

      for (final match in matches) {
        final resource = Resource.parse(match[1]!);
        final cost = {
          for (int i = 2; i < match.groupCount; i += 2)
            if (match[i] != null && match[i + 1] != null)
              Resource.parse(match[i + 1]!): int.parse(match[i]!),
        };
        costs[resource] = cost;
      }

      blueprints.add(Blueprint(id: id, costs: costs));
    }

    return blueprints
        .map(
          (blueprint) =>
              blueprint.id * _getHighestGeodes(blueprint, timeRemaining: 24),
        )
        .sum;
  }

  int _getHighestGeodes(Blueprint blueprint, {required int timeRemaining}) {
    final queue = Queue<State>.from([State(timeRemaining: timeRemaining)]);
    int highestGeodes = 0;

    final resourceCosts = blueprint.costs.entries.toList().reversed;
    final spendableResources =
        resourceCosts.map((resourceCost) => resourceCost.value.keys).flattened;
    final maxRobots = {
      for (final resource in spendableResources)
        resource: resourceCosts
            .map((resourceCost) => resourceCost.value[resource])
            .whereNotNull()
            .max,
    };

    while (queue.isNotEmpty) {
      final state = queue.removeFirst();

      if (state.timeRemaining > 0) {
        final buildableRobots = <Resource>{};

        for (final costEntry in resourceCosts) {
          if (state.skipRobots.contains(costEntry.key)) {
            continue;
          }

          final canBuildRobot = state.canBuildRobot(cost: costEntry.value);

          if (!canBuildRobot) {
            continue;
          }

          buildableRobots.add(costEntry.key);

          if (state.timeRemaining <
              Resource.values.length - costEntry.key.index) {
            continue;
          }

          if (maxRobots.containsKey(costEntry.key) &&
              state.robots[costEntry.key]! >= maxRobots[costEntry.key]!) {
            continue;
          }

          queue.add(state.buildRobot(costEntry.key, cost: costEntry.value));

          if (costEntry.key == Resource.geode) {
            break;
          }
        }

        queue.add(state.idle(skipRobots: buildableRobots));
      } else {
        final geodes = state.resources[Resource.geode]!;

        if (geodes > highestGeodes) {
          highestGeodes = max(highestGeodes, geodes);
        }
      }
    }

    return highestGeodes;
  }
}

class Blueprint {
  const Blueprint({
    required this.id,
    required this.costs,
  });

  final int id;
  final Map<Resource, Map<Resource, int>> costs;
}

class State {
  const State._({
    required this.robots,
    required this.resources,
    this.skipRobots = const {},
    required this.timeRemaining,
  });

  State({
    required this.timeRemaining,
  })  : robots = {
          for (final resource in Resource.values)
            resource: resource == Resource.ore ? 1 : 0,
        },
        resources = {
          for (final resource in Resource.values) resource: 0,
        },
        skipRobots = const {};

  final Map<Resource, int> robots;
  final Map<Resource, int> resources;
  final Set<Resource> skipRobots;
  final int timeRemaining;

  bool canBuildRobot({required Map<Resource, int> cost}) => cost.keys.every(
        (key) => resources[key]! >= cost[key]!,
      );

  State buildRobot(Resource resource, {required Map<Resource, int> cost}) =>
      State._(
        robots: robots.map(
          (key, value) => MapEntry(key, value + (key == resource ? 1 : 0)),
        ),
        resources: resources.map(
          (key, value) =>
              MapEntry(key, value + robots[key]! - (cost[key] ?? 0)),
        ),
        timeRemaining: timeRemaining - 1,
      );

  State idle({Set<Resource> skipRobots = const {}}) => State._(
        robots: robots,
        resources: resources.map(
          (key, value) => MapEntry(key, value + robots[key]!),
        ),
        skipRobots: {...this.skipRobots, ...skipRobots},
        timeRemaining: timeRemaining - 1,
      );
}

enum Resource {
  ore,
  clay,
  obsidian,
  geode;

  static Resource parse(String value) => Resource.values.byName(value);
}
