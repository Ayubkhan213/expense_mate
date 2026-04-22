// lib/core/usecase/usecase.dart

import 'package:spendio/core/error/failure.dart';
import 'package:spendio/core/utils/either.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
