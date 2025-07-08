import 'package:first_flutter_app/data/repositories/auth/auth_repository.dart';
import 'package:first_flutter_app/routing/router.dart';
import 'package:first_flutter_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:first_flutter_app/ui/auth/login/widgets/login_screen.dart';
import 'package:first_flutter_app/ui/auth/register/widgets/register_screen.dart';
import 'package:first_flutter_app/ui/note/note_screen/widgets/note_screen.dart';
import 'package:first_flutter_app/ui/note/note_screen/widgets/update_note.dart';

import 'ui/core/localization/applocalization.dart';
import 'ui/core/themes/theme.dart';
import 'ui/core/ui/scroll_behavior.dart';

import "package:flutter/material.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'main_development.dart' as development;

void main() {
  development.main();
}

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthRepository>(context, listen: false);

    return FutureBuilder<bool>(
      future: auth.isAuthenticated,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == false) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return SizedBox.shrink();
        }
        return child;
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        AppLocalizationDelegate(),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      scrollBehavior: AppCustomScrollBehavior(),
      themeMode: ThemeMode.system,
      initialRoute: '/note',
      routes: {
        '/login': (context) => LoginScreen(
          viewModel: LoginViewModel(
            authRepository: Provider.of<AuthRepository>(context, listen: false),
          ),
        ),
        '/register': (context) => RegisterScreen(),
        '/note': (context) => AuthGuard(child: NoteScreen()),
        '/updateNote': (context) {
          final route = ModalRoute.of(context);
          final noteId = route != null && route.settings.arguments != null
              ? route.settings.arguments as String
              : '';
          return AuthGuard(child: UpdateNote(id: noteId));
        },
      },
    );
  }
}
