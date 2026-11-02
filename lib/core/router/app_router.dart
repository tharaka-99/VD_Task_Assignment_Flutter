import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

class AppRouter {
  const AppRouter._();

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        name: 'login',
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: 'register',
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        name: 'forgot-password',
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        name: 'home',
        path: home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
