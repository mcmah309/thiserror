import 'package:thiserror/thiserror.dart';
import 'package:test/test.dart';

sealed class IoError extends ThisError<IoError> {
  const IoError([super.template, super.values]);
}

final class OneTemplateVariable extends IoError {
  OneTemplateVariable(String path) : super("Could not read '{0}' from disk.", [path]);
}

final class TwoTemplateVariables extends IoError {
  TwoTemplateVariables(Object obj, String path)
      : super("Could not write '{0}' to '{1}' on disk.", [obj, path]);
}

final class OneTemplateVariableTwoTimes extends IoError {
  OneTemplateVariableTwoTimes(String path)
      : super("Make sure that {0} is correct {0}", [path, path]);
}

final class NoTemplateVariables extends IoError {
  NoTemplateVariables() : super("An unknown error occurred.");
}

final class Empty extends IoError {
  Empty();
}

final class TwoTemplateVariablesOutOfOrder extends IoError {
  TwoTemplateVariablesOutOfOrder(String one, String two) : super("Could not write '{1}' to '{0}' on disk.", [one, two]);
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
    expect(x.toString(), "IoError: Could not read '/home/user/file' from disk.");
  });

  test("twoTemplateVariables", () {
    final x = TwoTemplateVariables("bing bong", "/home/user/file");
    expect(x.toString(), "IoError: Could not write 'bing bong' to '/home/user/file' on disk.");
  });
  test("oneTemplateVariableTwoTimes", () {
    final value = "bing bong";
    final x = OneTemplateVariableTwoTimes(value);
    expect(x.toString(), "IoError: Make sure that bing bong is correct bing bong");
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
    expect(x.toString(), "IoError: Could not write '/home/user/file' to 'bing bong' on disk.");
  });
}
