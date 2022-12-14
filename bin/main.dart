import 'package:advent_of_code_2022/day.dart';
import 'package:advent_of_code_2022/day1/day1.dart';
import 'package:advent_of_code_2022/day10/day10.dart';
import 'package:advent_of_code_2022/day11/day11.dart';
import 'package:advent_of_code_2022/day12/day12.dart';
import 'package:advent_of_code_2022/day13/day13.dart';
import 'package:advent_of_code_2022/day14/day14.dart';
import 'package:advent_of_code_2022/day15/day15.dart';
import 'package:advent_of_code_2022/day16/day16.dart';
import 'package:advent_of_code_2022/day17/day17.dart';
import 'package:advent_of_code_2022/day18/day18.dart';
import 'package:advent_of_code_2022/day19/day19.dart';
import 'package:advent_of_code_2022/day2/day2.dart';
import 'package:advent_of_code_2022/day20/day20.dart';
import 'package:advent_of_code_2022/day21/day21.dart';
import 'package:advent_of_code_2022/day22/day22.dart';
import 'package:advent_of_code_2022/day23/day23.dart';
import 'package:advent_of_code_2022/day24/day24.dart';
import 'package:advent_of_code_2022/day25/day25.dart';
import 'package:advent_of_code_2022/day3/day3.dart';
import 'package:advent_of_code_2022/day4/day4.dart';
import 'package:advent_of_code_2022/day5/day5.dart';
import 'package:advent_of_code_2022/day6/day6.dart';
import 'package:advent_of_code_2022/day7/day7.dart';
import 'package:advent_of_code_2022/day8/day8.dart';
import 'package:advent_of_code_2022/day9/day9.dart';

const filter = [];

const _days = <Day>[
  Day1(),
  Day2(),
  Day3(),
  Day4(),
  Day5(),
  Day6(),
  Day7(),
  Day8(),
  Day9(),
  Day10(),
  Day11(),
  Day12(),
  Day13(),
  Day14(),
  Day15(),
  Day16(),
  Day17(),
  Day18(),
  Day19(),
  Day20(),
  Day21(),
  Day22(),
  Day23(),
  Day24(),
  Day25(),
];

Future<void> main() async {
  final stopwatch = Stopwatch()..start();

  for (var day in _days) {
    if (filter.isEmpty || filter.contains(day.number)) {
      await day.calculate();
    }
  }

  stopwatch.stop();
  print('Total: ${stopwatch.elapsedMilliseconds}ms');
}
