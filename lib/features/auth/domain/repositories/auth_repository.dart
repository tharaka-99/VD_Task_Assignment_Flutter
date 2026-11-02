import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  });

  Future<Either<Failure, void>> forgotPassword({
    required String identifier,
  });

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, String?>> getRememberedIdentifier();

  Future<Either<Failure, void>> saveRememberedIdentifier(String identifier);

  Future<Either<Failure, void>> clearRememberedIdentifier();
}
