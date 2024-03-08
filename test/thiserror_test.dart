import 'package:thiserror/thiserror.dart';
import 'package:test/test.dart';

sealed class IoError extends ThisError<IoError> {
  const IoError([super.toStringFunc]);
}

final class OneTemplateVariable extends IoError {
  OneTemplateVariable(String path)
      : super(() => "Could not read '$path' from disk.");
}

final class TwoTemplateVariables extends IoError {
  TwoTemplateVariables(Object obj, String path)
      : super(() => "Could not write '$obj' to '$path' on disk.");
}

final class OneTemplateVariableTwoTimes extends IoError {
  OneTemplateVariableTwoTimes(String path)
      : super(() => "Make sure that $path is correct $path");
}

final class NoTemplateVariables extends IoError {
  NoTemplateVariables() : super(() => "An unknown error occurred.");
}

final class Empty extends IoError {
  Empty();
}

final class TwoTemplateVariablesOutOfOrder extends IoError {
  TwoTemplateVariablesOutOfOrder(String one, String two)
      : super(() => "Could not write '$two' to '$one' on disk.");
}

void main() {
  test("oneTemplateVariable", () {
    final diskpath = "/home/user/file";
    final IoError x = OneTemplateVariable(diskpath);
    switch (x) {
      case OneTemplateVariable():
      case TwoTemplateVariables():
      case OneTemplateVariableTwoTimes():
      case NoTemplateVariables():
      case Empty():
      case TwoTemplateVariablesOutOfOrder():
    }
    expect(
        x.toString(), "IoError: Could not read '/home/user/file' from disk.");
  });

  test("twoTemplateVariables", () {
    final x = TwoTemplateVariables("bing bong", "/home/user/file");
    expect(x.toString(),
        "IoError: Could not write 'bing bong' to '/home/user/file' on disk.");
  });
  test("oneTemplateVariableTwoTimes", () {
    final value = "bing bong";
    final x = OneTemplateVariableTwoTimes(value);
    expect(
        x.toString(), "IoError: Make sure that bing bong is correct bing bong");
  });

  test("noTemplateVariable", () {
    final x = NoTemplateVariables();
    expect(x.toString(), "IoError: An unknown error occurred.");
  });

  test("empty", () {
    final x = Empty();
    expect(x.toString(), "IoError");
  });

  test("twoTemplateVariables", () {
    final value = "bing bong";
    final diskpath = "/home/user/file";
    final x = TwoTemplateVariablesOutOfOrder(value, diskpath);
    expect(x.toString(),
        "IoError: Could not write '/home/user/file' to 'bing bong' on disk.");
  });
}
