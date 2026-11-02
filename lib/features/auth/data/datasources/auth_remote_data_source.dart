import 'dart:async';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String identifier,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  });

  Future<void> forgotPassword({
    required String identifier,
  });
}

class MockAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final List<Map<String, String>> _users = [
    {
      'id': 'seed_user_1',
      'name': AppConstants.seedName,
      'email': AppConstants.seedEmail,
      'mobileNumber': AppConstants.seedMobile,
      'password': AppConstants.seedPassword,
      'token': 'mock_jwt_token_seed_user',
    },
  ];

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockLatencyMs),
    );

    final cleanIdentifier = identifier.trim().toLowerCase();

    // Simulate network error for offline@test.com
    if (cleanIdentifier == AppConstants.offlineEmail) {
      throw const NetworkException(
        'Unable to connect to authentication server. Please check your network connection.',
      );
    }

    final userRecord = _users.firstWhere(
      (u) {
        final emailMatch = u['email']?.toLowerCase() == cleanIdentifier;
        final mobileMatch = u['mobileNumber'] == identifier.trim();
        return (emailMatch || mobileMatch) && u['password'] == password;
      },
      orElse: () => {},
    );

    if (userRecord.isEmpty) {
      throw const AuthException(
        'Invalid email/mobile number or password.',
      );
    }

    return UserModel(
      id: userRecord['id']!,
      name: userRecord['name']!,
      email: userRecord['email']!,
      mobileNumber: userRecord['mobileNumber']!,
      token: userRecord['token']!,
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockLatencyMs),
    );

    final cleanEmail = email.trim().toLowerCase();
    final cleanMobile = mobileNumber.trim();

    // Simulate network error for offline@test.com
    if (cleanEmail == AppConstants.offlineEmail) {
      throw const NetworkException(
        'Unable to connect to authentication server. Please check your network connection.',
      );
    }

    // Check duplicate email
    final isDuplicateEmail = _users.any(
      (u) => u['email']?.toLowerCase() == cleanEmail,
    );
    if (isDuplicateEmail) {
      throw const AuthException(
        'An account with this email address already exists.',
      );
    }

    // Check duplicate mobile
    final isDuplicateMobile = _users.any(
      (u) => u['mobileNumber'] == cleanMobile,
    );
    if (isDuplicateMobile) {
      throw const AuthException(
        'An account with this mobile number already exists.',
      );
    }

    final newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final token = 'mock_jwt_token_$newId';

    _users.add({
      'id': newId,
      'name': name.trim(),
      'email': cleanEmail,
      'mobileNumber': cleanMobile,
      'password': password,
      'token': token,
    });

    return UserModel(
      id: newId,
      name: name.trim(),
      email: cleanEmail,
      mobileNumber: cleanMobile,
      token: token,
    );
  }

  @override
  Future<void> forgotPassword({
    required String identifier,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockLatencyMs),
    );

    final cleanIdentifier = identifier.trim().toLowerCase();

    // Simulate network error for offline@test.com
    if (cleanIdentifier == AppConstants.offlineEmail) {
      throw const NetworkException(
        'Unable to connect to authentication server. Please check your network connection.',
      );
    }

    final exists = _users.any(
      (u) =>
          u['email']?.toLowerCase() == cleanIdentifier ||
          u['mobileNumber'] == identifier.trim(),
    );

    if (!exists) {
      throw const AuthException(
        'No account found with this email or mobile number.',
      );
    }
  }
}
