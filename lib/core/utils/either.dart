// lib/core/utils/either.dart

class Either<L, R> {
  final L? _left;
  final R? _right;

  Either._(this._left, this._right);

  factory Either.left(L value) => Either._(value, null);
  factory Either.right(R value) => Either._(null, value);

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left!;
  R get right => _right!;

  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    if (isLeft) return leftFn(_left!);
    return rightFn(_right!);
  }
}

// Convenience functions
Either<L, R> Left<L, R>(L value) => Either.left(value);
Either<L, R> Right<L, R>(R value) => Either.right(value);
