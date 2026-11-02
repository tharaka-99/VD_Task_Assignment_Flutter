import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastUser();
  Future<void> clearUser();

  Future<void> saveRememberedIdentifier(String identifier);
  Future<String?> getRememberedIdentifier();
  Future<void> clearRememberedIdentifier();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await sharedPreferences.setString(AppConstants.cachedUserKey, jsonString);
      if (user.token != null) {
        await sharedPreferences.setString(
          AppConstants.cachedTokenKey,
          user.token!,
        );
      }
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getLastUser() async {
    try {
      final jsonString =
          sharedPreferences.getString(AppConstants.cachedUserKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> jsonMap =
            jsonDecode(jsonString) as Map<String, dynamic>;
        return UserModel.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(AppConstants.cachedUserKey);
      await sharedPreferences.remove(AppConstants.cachedTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> saveRememberedIdentifier(String identifier) async {
    try {
      await sharedPreferences.setString(
        AppConstants.rememberedIdentifierKey,
        identifier,
      );
    } catch (e) {
      throw CacheException('Failed to save remembered identifier: $e');
    }
  }

  @override
  Future<String?> getRememberedIdentifier() async {
    try {
      return sharedPreferences.getString(AppConstants.rememberedIdentifierKey);
    } catch (e) {
      throw CacheException('Failed to get remembered identifier: $e');
    }
  }

  @override
  Future<void> clearRememberedIdentifier() async {
    try {
      await sharedPreferences.remove(AppConstants.rememberedIdentifierKey);
    } catch (e) {
      throw CacheException('Failed to clear remembered identifier: $e');
    }
  }
}
