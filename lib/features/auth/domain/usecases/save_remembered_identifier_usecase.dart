import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SaveRememberedIdentifierUseCase
    implements UseCase<void, SaveRememberedIdentifierParams> {
  final AuthRepository repository;

  const SaveRememberedIdentifierUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveRememberedIdentifierParams params) {
    return repository.saveRememberedIdentifier(params.identifier);
  }
}

class SaveRememberedIdentifierParams extends Equatable {
  final String identifier;

  const SaveRememberedIdentifierParams(this.identifier);

  @override
  List<Object?> get props => [identifier];
}

