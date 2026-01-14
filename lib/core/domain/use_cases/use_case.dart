// lib/core/usecase/usecase.dart

import 'package:expense_mate/core/error/failure.dart';
import 'package:expense_mate/core/utils/either.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
