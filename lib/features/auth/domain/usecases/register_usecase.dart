import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.register(
      name: params.name,
      email: params.email,
      mobileNumber: params.mobileNumber,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String mobileNumber;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, mobileNumber, password];
}

