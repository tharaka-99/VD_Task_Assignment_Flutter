import 'package:flutter/foundation.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/clear_remembered_identifier_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_remembered_identifier_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/save_remembered_identifier_usecase.dart';

enum AuthFlowStatus { idle, loading, success, failure }

class LoginProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetRememberedIdentifierUseCase _getRememberedIdentifierUseCase;
  final SaveRememberedIdentifierUseCase _saveRememberedIdentifierUseCase;
  final ClearRememberedIdentifierUseCase _clearRememberedIdentifierUseCase;

  AuthFlowStatus _status = AuthFlowStatus.idle;
  UserEntity? _currentUser;
  String? _errorMessage;
  String? _successMessage;
  String? _rememberedIdentifier;

  LoginProvider({
    required LoginUseCase loginUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
    required GetRememberedIdentifierUseCase getRememberedIdentifierUseCase,
    required SaveRememberedIdentifierUseCase saveRememberedIdentifierUseCase,
    required ClearRememberedIdentifierUseCase clearRememberedIdentifierUseCase,
  })  : _loginUseCase = loginUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        _getRememberedIdentifierUseCase = getRememberedIdentifierUseCase,
        _saveRememberedIdentifierUseCase = saveRememberedIdentifierUseCase,
        _clearRememberedIdentifierUseCase = clearRememberedIdentifierUseCase;

  AuthFlowStatus get status => _status;
  bool get isLoading => _status == AuthFlowStatus.loading;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get rememberedIdentifier => _rememberedIdentifier;

  Future<void> loadRememberedIdentifier() async {
    final result = await _getRememberedIdentifierUseCase(const NoParams());
    result.fold(
      (_) => null,
      (identifier) {
        if (_rememberedIdentifier != identifier) {
          _rememberedIdentifier = identifier;
          notifyListeners();
        }
      },
    );
  }

  Future<void> loadCurrentUser() async {
    _status = AuthFlowStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) {
        _status = AuthFlowStatus.failure;
        _errorMessage = failure.message;
        _currentUser = null;
        notifyListeners();
      },
      (user) {
        _status = AuthFlowStatus.success;
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  Future<bool> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    if (_status == AuthFlowStatus.loading) return false;

    _status = AuthFlowStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    if (rememberMe) {
      await _saveRememberedIdentifierUseCase(
        SaveRememberedIdentifierParams(identifier),
      );
      _rememberedIdentifier = identifier;
    } else {
      await _clearRememberedIdentifierUseCase(const NoParams());
      _rememberedIdentifier = null;
    }

    final result = await _loginUseCase(
      LoginParams(
        identifier: identifier,
        password: password,
      ),
    );

    return result.fold(
      (failure) {
        _status = AuthFlowStatus.failure;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _status = AuthFlowStatus.success;
        _currentUser = user;
        _successMessage = 'Welcome back, ${user.name}!';
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> logout() async {
    _status = AuthFlowStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _logoutUseCase(const NoParams());

    return result.fold(
      (failure) {
        _status = AuthFlowStatus.failure;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _status = AuthFlowStatus.idle;
        _currentUser = null;
        _successMessage = 'Logged out successfully.';
        notifyListeners();
        return true;
      },
    );
  }
}

