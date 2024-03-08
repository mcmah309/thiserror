# thiserror
[![Pub Version](https://img.shields.io/pub/v/thiserror.svg)](https://pub.dev/packages/thiserror)
[![Dart Package Docs](https://img.shields.io/badge/documentation-pub.dev-blue.svg)](https://pub.dev/documentation/thiserror/latest/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/mcmah309/thiserror/actions/workflows/dart.yml/badge.svg)](https://github.com/mcmah309/thiserror/actions)

thiserror is a library for conveniently writing Error enums (sealed classes) in Dart and is based off the Rust crate
with the same name [thiserror](https://github.com/dtolnay/thiserror).

## ThisError

Extending the `ThisError` class allows you to define errors with a string representation computed at display time. 

### How To Use
`ThisError` objects can be passed a template and objects to inject into the template at the corresponding index if `toString()` is called. 
Missing template data will never cause an issue.

Here is an example of modeling an `IoError` with the [rust_core](https://github.com/mcmah309/rust_core) `Result` type.
```dart
sealed class IoError extends ThisError<IoError> {
  const IoError([super.template, super.values]);
}

final class IoErrorDiskRead extends IoError {
  IoErrorDiskRead(String path) : super("Could not read '{0}' from disk.", [path]);
}

final class IoErrorDiskWrite extends IoError {
  Object obj;

  IoErrorDiskWrite(this.obj, String path) : super("Could not write '{0}' to '{1}' on disk.", [obj, path]);
}

final class IoErrorUnknown extends IoError {
  IoErrorUnknown() : super("An unknown error occurred.");
}

final class IoErrorEmpty extends IoError {
  IoErrorEmpty();
}

Result<(), IoError> writeToDisk(Object objToWrite) {
  final diskpath = "/home/user/data_file";
  // Somewhere here write fails..
  final ioError = IoErrorDiskWrite(objToWrite, diskpath);
  return Err(ioError);
}

void main() {
  final result = writeToDisk("data here");
  switch (result) {
    case IoErrorDiskRead():
      // your code here
    case IoErrorDiskWrite(:final obj):
      // your code here
    case IoErrorUnknown():
      // your code here
    case IoErrorEmpty():
      // your code here
  }
  print(result);
}
```
Output:
```
IoError: Could not write 'data here' to '/home/user/data_file' on disk.
```

## Comparison to anyhow
Use thiserror if you care about designing your own dedicated error type(s) so that the caller receives exactly the information that you choose in the event of failure. This most often applies to library-like code. Use [anyhow](https://pub.dev/packages/anyhow) if you don't care what error type your functions return, you just want it to be easy. This is common in application-like code.