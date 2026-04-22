// lib/features/auth/domain/use_cases/update_profile_usecase.dart

// import 'package:spendio/core/data/models/user_model.dart';
import 'package:spendio/core/data/models/user_sql_model.dart';
import 'package:spendio/features/auth/domain/repository/auth_repository.dart';
import 'package:spendio/features/auth/domain/repository/sql/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<UserModel> call(UserModel updatedUser) async {
    return await repository.updateUserProfile(updatedUser);
  }
}
