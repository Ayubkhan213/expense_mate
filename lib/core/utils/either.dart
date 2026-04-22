// lib/core/utils/either.dart

class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isRight; // ✅ track right explicitly, not by null check

  Either._(this._left, this._right, this._isRight);

  factory Either.left(L value) => Either._(value, null, false);
  factory Either.right([R? value]) =>
      Either._(null, value, true); // ✅ optional value

  bool get isLeft => !_isRight;
  bool get isRight => _isRight;

  L get left => _left!;
  R? get right => _right;

  T fold<T>(T Function(L l) leftFn, T Function(R? r) rightFn) {
    if (isLeft) return leftFn(_left!);
    return rightFn(_right); // ✅ no null crash for void
  }
}

// Convenience functions
Either<L, R> Left<L, R>(L value) => Either.left(value);
Either<L, R> Right<L, R>([R? value]) => Either.right(value); // ✅ optional
