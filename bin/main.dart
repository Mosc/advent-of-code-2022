import 'package:advent_of_code_2022/day1/day1.dart' as day1;
import 'package:advent_of_code_2022/day2/day2.dart' as day2;
import 'package:advent_of_code_2022/day3/day3.dart' as day3;
import 'package:advent_of_code_2022/day4/day4.dart' as day4;
import 'package:advent_of_code_2022/day5/day5.dart' as day5;
import 'package:advent_of_code_2022/day6/day6.dart' as day6;

Future<void> main(List<String> arguments) async {
  await day1.calculate();
  await day2.calculate();
  await day3.calculate();
  await day4.calculate();
  await day5.calculate();
  await day6.calculate();
}
