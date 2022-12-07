import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day7 extends Day<List<String>, int> {
  const Day7() : super(7);

  @override
  int processPart1(List<String> value) {
    var currentDirectory = Directory();

    for (final line in value) {
      final split = line.split(' ');

      switch (split[0]) {
        case '\$':
          final command = split[1];
          switch (command) {
            case 'cd':
              final name = split[2];
              switch (name) {
                case '/':
                  while (currentDirectory.parent != null) {
                    currentDirectory = currentDirectory.parent!;
                  }
                  break;
                case '..':
                  currentDirectory = currentDirectory.parent!;
                  break;
                default:
                  currentDirectory = currentDirectory.directories
                      .singleWhere((directory) => directory.name == name);
              }
          }
          break;
        case 'dir':
          final name = split[1];
          currentDirectory.directories.add(
            Directory(parent: currentDirectory, name: name),
          );
          break;
        default:
          final size = int.parse(split[0]);
          final name = split[1];
          currentDirectory.files.add(
            File(name: name, size: size),
          );
          break;
      }
    }

    while (currentDirectory.parent != null) {
      currentDirectory = currentDirectory.parent!;
    }

    const maxSize = 100000;

    return _flattenDirectory(currentDirectory)
        .map((directory) => directory.size)
        .where((size) => size <= maxSize)
        .sum;
  }

  Iterable<Directory> _flattenDirectory(Directory currentDirectory) sync* {
    yield currentDirectory;

    for (final directory in currentDirectory.directories) {
      yield* _flattenDirectory(directory);
    }
  }
}

class Directory {
  Directory({this.parent, this.name})
      : directories = <Directory>[],
        files = <File>[];

  final Directory? parent;
  final String? name;
  final List<Directory> directories;
  final List<File> files;

  int get size => [
        ...directories.map((directory) => directory.size),
        ...files.map((file) => file.size),
      ].sum;
}

class File {
  const File({required this.name, required this.size});

  final String name;
  final int size;
}
