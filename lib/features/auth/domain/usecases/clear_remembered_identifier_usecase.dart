import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ClearRememberedIdentifierUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  const ClearRememberedIdentifierUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearRememberedIdentifier();
  }
}

