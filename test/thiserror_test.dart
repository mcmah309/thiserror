import 'package:thiserror/thiserror.dart';
import 'package:test/test.dart';

sealed class IoError extends ThisError<IoError> {
  const IoError([super.toStringFunc]);
}

final class OneVariable extends IoError {
  OneVariable(String path)
      : super(() => "Could not read '$path' from disk.");
}

final class TwoVariables extends IoError {
  TwoVariables(Object obj, String path)
      : super(() => "Could not write '$obj' to '$path' on disk.");
}

final class OneVariableTwoTimes extends IoError {
  OneVariableTwoTimes(String path)
      : super(() => "Make sure that $path is correct $path");
}

final class JustAString extends IoError {
  JustAString() : super("An unknown error occurred.");
}

final class Empty extends IoError {
  Empty();
}

final class ObjectFunction extends IoError {
  ObjectFunction()
      : super(() => 1);
}

final class NullFunction extends IoError {
  NullFunction()
      : super(() => null);
}

void main() {
  test("OneVariable", () {
    final diskpath = "/home/user/file";
    final IoError x = OneVariable(diskpath);
    switch (x) {
      case OneVariable():
      case TwoVariables():
      case OneVariableTwoTimes():
      case JustAString():
      case Empty():
      case ObjectFunction():
      case NullFunction():
    }
    expect(
        x.toString(), "IoError: Could not read '/home/user/file' from disk.");
  });

  test("TwoVariables", () {
    final x = TwoVariables("bing bong", "/home/user/file");
    expect(x.toString(),
        "IoError: Could not write 'bing bong' to '/home/user/file' on disk.");
  });
  test("OneVariableTwoTimes", () {
    final value = "bing bong";
    final x = OneVariableTwoTimes(value);
    expect(
        x.toString(), "IoError: Make sure that bing bong is correct bing bong");
  });

  test("JustAString", () {
    final x = JustAString();
    expect(x.toString(), "IoError: An unknown error occurred.");
  });

  test("Empty", () {
    final x = Empty();
    expect(x.toString(), "IoError");
  });

  test("ObjectFunction", () {
    final x = ObjectFunction();
    expect(x.toString(),
        "IoError: 1");
  });

  test("NullFunction", () {
    final x = NullFunction();
    expect(x.toString(),
        "IoError");
  });
}
