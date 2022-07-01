import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
const lineNumber = 'line-number';

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  ArgResults argResults = parser.parse(arguments);
  // 除了上面register的lineNumber的flag外，剩余的参数都作为路径
  final paths = argResults.rest;

  dcat(paths, showLineNumbers: argResults[lineNumber] as bool);
}

Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
  if (paths.isEmpty) {
    await stdin.pipe(stdout);
  } else {
    // 如果有多个路径，则按照顺序依次输出
    for (final path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter()); // 将文件转换为行
      try {
        await for (final line in lines) {
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}