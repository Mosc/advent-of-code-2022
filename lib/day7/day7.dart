import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day7 extends Day<Iterable<int>, int> {
  const Day7() : super(7);

  @override
  Iterable<int> preprocess(List<String> value) {
    final root = Directory();
    late Directory currentDirectory;

    for (final line in value) {
      final tokens = line.split(' ');

      if (tokens[0] == r'$') {
        if (tokens[1] == 'cd') {
          if (tokens[2] == '/') {
            currentDirectory = root;
          } else if (tokens[2] == '..') {
            currentDirectory = currentDirectory.parent!;
          } else {
            currentDirectory = currentDirectory = currentDirectory.directories
                .singleWhere((directory) => directory.name == tokens[2]);
          }
        }
      } else if (tokens[0] == 'dir') {
        currentDirectory.directories
            .add(Directory(parent: currentDirectory, name: tokens[1]));
      } else {
        currentDirectory.files
            .add(File(name: tokens[1], size: int.parse(tokens[0])));
      }
    }

    return _flattenDirectory(root).map((directory) => directory.size);
  }

  @override
  int processPart1(Iterable<int> value) {
    const maxSize = 100000;

    return value.where((size) => size <= maxSize).sum;
  }

  @override
  int processPart2(Iterable<int> value) {
    const totalSize = 70000000;
    const requiredSize = 30000000;
    final unusedSize = totalSize - value.first;

    return value
        .sorted((a, b) => a.compareTo(b))
        .firstWhere((size) => unusedSize + size >= requiredSize);
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
