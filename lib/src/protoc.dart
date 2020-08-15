import 'dart:io';

import 'package:logging/logging.dart';
import 'package:proto_builder/src/pubspec_options.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class Protoc {
  // Protoc(this.log);

  Future<PubspecOptions> get pubspecOptions async => await pubspecOptionsRead();
  PubspecOptions _chachedOptions;

  final Logger log = Logger.root;

  Future<BuildResult> buildFile(String filePath) async {
    log.info('*** Processing *** $filePath');

    var userOptions = await pubspecOptions;

    final protoFileName = p.withoutExtension(filePath).split('/').last;
    var outputPath = userOptions.outputPath;

    if (userOptions.seperateFolder) {
      outputPath = p.join(outputPath, protoFileName);
    }

    final file = File(filePath);
    final protoDir = p.relative(p.dirname(file.path));
    var outputDir = Directory(outputPath);

    // To rebuild the changed file, we have to clean up the old output.
    if (outputDir.existsSync()) {
      await outputDir.delete(recursive: true);
    }

    if (outputDir.existsSync() == false) {
      await outputDir.create(recursive: true);
    }

    final process =
        Process.runSync('protoc', ['--dart_out=grpc:${outputDir.path}', '--proto_path=$protoDir', filePath], workingDirectory: '.', runInShell: true);

    final code = await process.exitCode;

    if (code != 0) {
      var logFilePath = p.join(outputPath, '$protoFileName.txt');
      log.severe('Error Log: $logFilePath');
      var logFile = File(logFilePath);
      logFile.writeAsStringSync(process.stdout);
      return Future.value(BuildResult(filePath, false));
    } else {
      log.finer('### Completed ### ${outputPath}');
    }

    return Future.value(BuildResult(filePath, true));
  }

  Future<PubspecOptions> pubspecOptionsRead() async {
    if (_chachedOptions == null) {
      var pubspecFile = File('./pubspec.yaml');
      var fileContent = pubspecFile.readAsStringSync();
      YamlMap pubspec = loadYaml(fileContent);
      if (pubspec != null && pubspec is Map) {
        if (pubspec['proto_builder'] != null) {
          var protoBuilder = pubspec['proto_builder'];
          _chachedOptions = PubspecOptions.fromJson(protoBuilder);
        } else {
          _chachedOptions = PubspecOptions();
        }
      }
    }

    return _chachedOptions;
  }
}

class BuildResult {
  final String filePath;
  final bool result;

  BuildResult(this.filePath, this.result);
}
