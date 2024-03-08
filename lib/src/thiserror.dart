/// Extending the [ThisError] class allows you to define errors with a string representation computed at display time.
abstract class ThisError<T extends ThisError<T>> {
  final String Function()? _toStringFunc;

  const ThisError([this._toStringFunc]);

  @override
  String toString() {
    final message = this._toStringFunc?.call();
    if (message != null) {
      return "$T: $message";
    }
    return "$T";
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}
