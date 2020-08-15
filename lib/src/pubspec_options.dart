import 'package:yaml/yaml.dart';

class PubspecOptions {
  String outputPath;
  bool seperateFolder;

  PubspecOptions({this.outputPath = './lib/protos/src/', this.seperateFolder = true});

  factory PubspecOptions.fromJson(YamlMap json) {
    return PubspecOptions(outputPath: json['outputPath'], seperateFolder: json['seperateFolder'] as bool);
  }
}
