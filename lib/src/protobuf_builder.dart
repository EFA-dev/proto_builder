import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

class ProtobufBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.proto': ['.pb.dart, .pbenum.dart, .pbgrpc.dart, .pbjson.dart']
      };

  @override
  Future<dynamic> build(BuildStep buildStep) async {
    //
    final filePath = p.relative(buildStep.inputId.path);
    final protoFileName = p.withoutExtension(filePath).split('/').last;
    final outputPath = './lib/protos/src/$protoFileName';

    final file = File(filePath);
    final protoDir = p.relative(p.dirname(file.path));
    var outputDir = Directory(outputPath);

    if (outputDir.existsSync()) {
      await outputDir.delete(recursive: true);
    }

    await Future.delayed(Duration(seconds: 1));
    if (outputDir.existsSync() == false) {
      await outputDir.create(recursive: true);
    }

    final process = Process.runSync('protoc', ['--dart_out=grpc:${outputDir.path}', '--proto_path=$protoDir', filePath], workingDirectory: '.', runInShell: true);

    final code = await process.exitCode;

    if (code != 0) {
      log.severe('Error');
      return;
    } else {
      log.fine('OK!');
    }
  }
}
