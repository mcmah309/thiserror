/// Extending the [ThisError] class allows you to define errors with a string representation computed at display time.
abstract class ThisError<T extends ThisError<T>> {
  final Object? _stringifiable;

  const ThisError([this._stringifiable]);

  @override
  String toString() {
    final stringifiable = _stringifiable;
    if (stringifiable == null) {
      return "$T";
    }
    if (stringifiable is Object? Function()) {
      final obj = stringifiable();
      if (obj == null) {
        return "$T";
      }
      return "$T: $obj";
    }
    return "$T: $stringifiable";
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}
