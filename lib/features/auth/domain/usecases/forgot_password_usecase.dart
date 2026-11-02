import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  const ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(identifier: params.identifier);
  }
}

class ForgotPasswordParams extends Equatable {
  final String identifier;

  const ForgotPasswordParams({required this.identifier});

  @override
  List<Object?> get props => [identifier];
}
