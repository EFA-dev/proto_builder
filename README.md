# What does it do?
This package will find the .proto files contained in your project and convert them into **Dart** files. <br/>
It uses [**protoc_plugin**](https://github.com/dart-lang/protobuf/tree/master/protoc_plugin) to do this.

# How to use?
You can use the package in two different ways.


Direct start
------------
You can run the package directly. When it is run in this way, the process is completed faster.

`pub run proto_builder:main`

Using with [build_runner](https://github.com/dart-lang/build/tree/master/build_runner)
-----------------------
The process takes a little longer if you use it with the build_runner package. But I added this support anyway.

`pub run build_runner build --verbose`

# Output Settings

You can set it from the pubspec.yaml file to save the generated files wherever you want.
If you wish, you can save it in separate folders according to the .proto files.
To make these settings, simply add the following codes to your pubspec.yaml file.

```
proto_builder:
  outputPath: lib/protos/src
  seperateFolder: true
```
