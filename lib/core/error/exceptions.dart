class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server exception occurred']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network connection error']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache operation failed']);

  @override
  String toString() => message;
}

