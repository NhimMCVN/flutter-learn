import 'package:first_flutter_app/data/repositories/auth/auth_repository.dart';
import 'package:first_flutter_app/data/repositories/booking/booking_repository.dart';
import 'package:first_flutter_app/data/repositories/user/user_repository.dart';
import 'package:first_flutter_app/routing/routes.dart';
import 'package:first_flutter_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:first_flutter_app/ui/auth/login/widgets/login_screen.dart';
import 'package:first_flutter_app/ui/home/view_models/home_viewmodel.dart';
import 'package:first_flutter_app/ui/home/widgets/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => LoginScreen(
        viewModel: LoginViewModel(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomeScreen(
        viewModel: HomeviewModel(
          bookingRepository: context.read<BookingRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
      ),
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.home;
  if (!loggedIn) return Routes.login;

  if (loggingIn) {
    return Routes.home;
  }
  return null;
}
