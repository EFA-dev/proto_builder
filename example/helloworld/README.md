# How to use?
You can use the package in two different ways.


Direct start
------------
You can run the package directly. When it is run in this way, the process is completed faster.<br/>
***Your .proto files can be found in any folder within the project.***

`pub run proto_builder:main`

Using with [build_runner](https://github.com/dart-lang/build/tree/master/build_runner)
-----------------------
The process takes a little longer if you use it with the build_runner package. 
But I added this support anyway.<br/>
***Your .proto file must be in lib folder.***

`pub run build_runner build --verbose`

<br/>

# Output Settings
You can set it from the **pubspec.yaml** file to save the generated files wherever you want.
If you wish, you can save it in separate folders according to the .proto files.
To make these settings, simply add the following codes to your **pubspec.yaml** file.
The files created are saved in the **lib/grpc/src/** folder by default.

```
proto_builder:
  outputPath: lib/grpc/generated
  seperateFolder: true
```