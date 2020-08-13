import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

class ProtobufBuilder implements Builder {
  final BuilderOptions options;

  ProtobufBuilder(this.options);

  @override
  Map<String, List<String>> get buildExtensions => {
        '.proto': ['.pb.dart, .pbenum.dart, .pbgrpc.dart, .pbjson.dart']
      };

  @override
  Future<bool> build(BuildStep buildStep) async {
    var assetPath = buildStep.inputId.path;
    log.info('*************' + assetPath);
    return await buildFile(assetPath);
  }

  Future<bool> buildFile(String path) async {
    final filePath = p.relative(path);
    final protoFileName = p.withoutExtension(filePath).split('/').last;
    final outputPath = './lib/protos/src/$protoFileName';

    final file = File(filePath);
    final protoDir = p.relative(p.dirname(file.path));
    var outputDir = Directory(outputPath);

    if (outputDir.existsSync()) {
      await outputDir.delete(recursive: true);
    }

    if (outputDir.existsSync() == false) {
      await outputDir.create(recursive: true);
    }

    final process = Process.runSync('protoc', ['--dart_out=grpc:${outputDir.path}', '--proto_path=$protoDir', filePath], workingDirectory: '.', runInShell: true);

    final code = await process.exitCode;

    if (code != 0) {
      var logFilePath = outputPath + '/$protoFileName.txt';
      log.severe('Error Log: $logFilePath');
      var logFile = File(logFilePath);
      logFile.writeAsStringSync(process.stdout);
      return Future.value(false);
    } else {
      log.finest('Completed: ************* $path');
    }

    return Future.value(true);
  }
}
