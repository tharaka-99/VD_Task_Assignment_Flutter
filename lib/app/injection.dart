import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/clear_remembered_identifier_usecase.dart';
import '../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/get_remembered_identifier_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/save_remembered_identifier_usecase.dart';
import '../features/auth/presentation/providers/forgot_password_provider.dart';
import '../features/auth/presentation/providers/login_provider.dart';
import '../features/auth/presentation/providers/register_provider.dart';

class AppInjection extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final Widget child;

  const AppInjection({
    super.key,
    required this.sharedPreferences,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Data Sources
    final remoteDataSource = MockAuthRemoteDataSourceImpl();
    final localDataSource =
        AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);

    // Repository Implementation
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // Use Cases
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final forgotPasswordUseCase = ForgotPasswordUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
    final getRememberedIdentifierUseCase =
        GetRememberedIdentifierUseCase(authRepository);
    final saveRememberedIdentifierUseCase =
        SaveRememberedIdentifierUseCase(authRepository);
    final clearRememberedIdentifierUseCase =
        ClearRememberedIdentifierUseCase(authRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(
            loginUseCase: loginUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            logoutUseCase: logoutUseCase,
            getRememberedIdentifierUseCase: getRememberedIdentifierUseCase,
            saveRememberedIdentifierUseCase: saveRememberedIdentifierUseCase,
            clearRememberedIdentifierUseCase: clearRememberedIdentifierUseCase,
          )..loadRememberedIdentifier(),
        ),
        ChangeNotifierProvider<RegisterProvider>(
          create: (_) => RegisterProvider(
            registerUseCase: registerUseCase,
          ),
        ),
        ChangeNotifierProvider<ForgotPasswordProvider>(
          create: (_) => ForgotPasswordProvider(
            forgotPasswordUseCase: forgotPasswordUseCase,
          ),
        ),
      ],
      child: child,
    );
  }
}

