import 'package:thiserror/thiserror.dart';

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

// Usually, you would use a result type like from the `rust_core` package.
IoError writeToDisk(Object objToWrite) {
  final diskpath = "/home/user/data_file";
  // write fails..
  final ioError = IoErrorDiskWrite(objToWrite, diskpath);
  return ioError;
}

void main() {
  final err = writeToDisk("data here");
  switch (err) {
      case IoErrorDiskRead():
      // your code here
      case IoErrorDiskWrite(:final obj):
      // your code here
      case IoErrorUnknown():
      // your code here
      case IoErrorEmpty():
      // your code here
  }
  print(err);
  // IoError: Could not write 'data here' to '/home/user/data_file' on disk.
}