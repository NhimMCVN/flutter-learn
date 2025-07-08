import 'package:first_flutter_app/routing/routes.dart';
import 'package:first_flutter_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:first_flutter_app/ui/core/localization/applocalization.dart';
import 'package:first_flutter_app/ui/core/themes/dimens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewModel viewModel;
  const LoginScreen({super.key, required this.viewModel});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(
    text: "email@example.com",
  );
  final TextEditingController _password = TextEditingController(
    text: "password",
  );

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_onResult);
    super.dispose();
  }

  void _onResult() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      context.go(Routes.todo);
    }

    if (widget.viewModel.login.error) {
      widget.viewModel.login.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.of(context).errorWhileLogin),
          action: SnackBarAction(
            label: AppLocalization.of(context).tryAgain,
            onPressed: () => widget.viewModel.login.execute((
              _email.value.text,
              _password.value.text,
            )),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: SvgPicture.asset("assets/logo.svg")),
          Padding(
            padding: Dimens.of(context).edgeInsetsScreenSymmetric,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(controller: _email),
                const SizedBox(height: Dimens.paddingVertical),
                TextField(controller: _password),
                const SizedBox(height: Dimens.paddingVertical),
                ListenableBuilder(
                  listenable: widget.viewModel.login,
                  builder: (context, _) {
                    return FilledButton(
                      child: Text(AppLocalization.of(context).login),
                      onPressed: () {
                        widget.viewModel.login.execute((
                          _email.value.text,
                          _password.value.text,
                        ));
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You don't have an account?",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Register",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
