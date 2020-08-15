import 'package:yaml/yaml.dart';

class PubspecOptions {
  String outputPath;
  bool seperateFolder;

  PubspecOptions({this.outputPath = './lib/grpc/', this.seperateFolder = true});

  factory PubspecOptions.fromJson(YamlMap json) {
    var outputPath;
    var seperateFolder;

    if (json.containsKey('outputPath')) {
      outputPath = json['outputPath'];
    }
    if (json.containsKey('seperateFolder')) {
      seperateFolder = json['seperateFolder'] as bool;
    }

    return PubspecOptions(outputPath: outputPath ?? './lib/grpc/', seperateFolder: seperateFolder ?? true);
  }
}
