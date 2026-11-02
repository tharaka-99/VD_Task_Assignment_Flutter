import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        identifier: identifier,
        password: password,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
      );
      // We don't necessarily cache on register or we can cache;
      // Requirement: On success show success message and navigate to Login.
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String identifier,
  }) async {
    try {
      await remoteDataSource.forgotPassword(identifier: identifier);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getLastUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error during logout: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getRememberedIdentifier() async {
    try {
      final identifier = await localDataSource.getRememberedIdentifier();
      return Right(identifier);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to load remembered identifier: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveRememberedIdentifier(
    String identifier,
  ) async {
    try {
      await localDataSource.saveRememberedIdentifier(identifier);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save remembered identifier: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRememberedIdentifier() async {
    try {
      await localDataSource.clearRememberedIdentifier();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear remembered identifier: $e'));
    }
  }
}
