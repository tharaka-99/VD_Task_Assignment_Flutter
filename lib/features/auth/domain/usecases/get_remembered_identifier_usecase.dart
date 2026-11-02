import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class GetRememberedIdentifierUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  const GetRememberedIdentifierUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return repository.getRememberedIdentifier();
  }
}

