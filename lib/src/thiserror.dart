/// Extending the [ThisError] class allows you to define errors with a string representation computed at display time.
abstract class ThisError<T extends ThisError<T>> {
  static final _innerNumberCapture = RegExp(r'{(\d+)}');

  final String? template;
  final List<Object>? values;

  const ThisError([this.template, this.values]);

  @override
  String toString() {
    if (values == null) {
      if (template == null) {
        return "$T";
      } else {
        return "$T: $template";
      }
    }
    if (template == null) {
      return "$T";
    }
    final replacedTemplate =
        template!.replaceAllMapped(_innerNumberCapture, (Match match) {
      int index = int.parse(match.group(1)!);
      if (index < values!.length) {
        return values![index].toString();
      } else {
        // If index is out of bounds, keep the original placeholder
        return match.group(0)!;
      }
    }).trim();
    if (replacedTemplate.isEmpty) {
      return "$T";
    } else {
      return "$T: $replacedTemplate";
    }
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}
