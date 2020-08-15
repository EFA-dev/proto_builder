import 'dart:async';

import 'package:build/build.dart';
import 'package:proto_builder/src/protoc.dart';

class ProtobufBuilder implements Builder {
  final BuilderOptions options;

  ProtobufBuilder(this.options);

  @override
  Map<String, List<String>> get buildExtensions => {
        '.proto': ['.pb.dart, .pbenum.dart, .pbgrpc.dart, .pbjson.dart']
      };

  Protoc protoc = Protoc();

  @override
  Future<bool> build(BuildStep buildStep) async {
    var buildResult = await protoc.buildFile(buildStep.inputId.path);
    return buildResult.result;
  }
}
