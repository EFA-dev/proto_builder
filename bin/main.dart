import 'dart:io';

import 'package:glob/glob.dart';
import 'package:logging/logging.dart';
import 'package:proto_builder/src/protoc.dart';
import 'package:build_runner/src/logging/std_io_logging.dart';

final protoFile = Glob('**.proto');

void main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    stdout.write(colorLog(record, verbose: true));
  });

  var successful = <BuildResult>[];
  var failed = <BuildResult>[];
  var protoc = Protoc();
  final stopwatch = Stopwatch()..start();
  await for (var entity in protoFile.list()) {
    var buildResult = await protoc.buildFile(entity.path);
    if (buildResult.result) {
      successful.add(buildResult);
    } else {
      failed.add(buildResult);
    }
  }

  Logger.root.finest('************* ${successful.length} Proto Files Completed Successfully');
  if (failed.isNotEmpty) {
    Logger.root.warning('************* ${failed.length} Proto Files Failed');
    for (var failedFile in failed) {
      Logger.root.severe('************* ${failedFile.filePath} Failed');
    }
  }

  Logger.root.info('************* ${stopwatch.elapsed.dayHourMinuteSecondFormatted()} Operation Time');
  stopwatch.stop();
}

extension DurationFormatter on Duration {
  String dayHourMinuteSecondFormatted() {
    toString();
    return [inHours.remainder(24), inMinutes.remainder(60), inSeconds.remainder(60)].map((seg) {
      return seg.toString().padLeft(2, '0');
    }).join(':');
  }
}
