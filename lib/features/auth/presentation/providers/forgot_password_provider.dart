import 'package:flutter/foundation.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import 'login_provider.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthFlowStatus _status = AuthFlowStatus.idle;
  String? _errorMessage;
  String? _successMessage;

  ForgotPasswordProvider({
    required ForgotPasswordUseCase forgotPasswordUseCase,
  }) : _forgotPasswordUseCase = forgotPasswordUseCase;

  AuthFlowStatus get status => _status;
  bool get isLoading => _status == AuthFlowStatus.loading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> forgotPassword({required String identifier}) async {
    if (_status == AuthFlowStatus.loading) return false;

    _status = AuthFlowStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(identifier: identifier),
    );

    return result.fold(
      (failure) {
        _status = AuthFlowStatus.failure;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _status = AuthFlowStatus.success;
        _successMessage =
            'A password reset link has been sent to your email or mobile.';
        notifyListeners();
        return true;
      },
    );
  }
}

