import 'package:flutter/foundation.dart';
import '../../domain/usecases/register_usecase.dart';
import 'login_provider.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  AuthFlowStatus _status = AuthFlowStatus.idle;
  String? _errorMessage;
  String? _successMessage;

  RegisterProvider({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase;

  AuthFlowStatus get status => _status;
  bool get isLoading => _status == AuthFlowStatus.loading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    if (_status == AuthFlowStatus.loading) return false;

    _status = AuthFlowStatus.loading;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await _registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        mobileNumber: mobileNumber,
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
        _successMessage = 'Account created successfully! Please sign in.';
        notifyListeners();
        return true;
      },
    );
  }
}

