// lib/features/auth/domain/use_cases/update_profile_usecase.dart

import 'package:expense_mate/core/data/models/user_model.dart';
import 'package:expense_mate/features/auth/domain/repository/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<UserModel> call(UserModel updatedUser) async {
    return await repository.updateUserProfile(updatedUser);
  }
}
