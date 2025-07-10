import 'package:first_flutter_app/ui/auth/register/view_models/register_viewmodel.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterViewModel viewModel;

  const RegisterScreen({super.key, required this.viewModel});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.register.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant RegisterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.register.removeListener(_onResult);
    widget.viewModel.register.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.register.removeListener(_onResult);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void _onResult() {
    if (widget.viewModel.register.completed) {
      setState(() {
        _isSubmitting = false;
      });
      widget.viewModel.register.clearResult();
      Navigator.pushReplacementNamed(context, '/note');
      return;
    }

    if (widget.viewModel.register.error) {
      setState(() {
        _isSubmitting = false;
      });
      widget.viewModel.register.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed. Please try again."),
          action: SnackBarAction(
            label: "Try Again",
            onPressed: () => _submitForm(),
          ),
        ),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _rePasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      widget.viewModel.register.execute((
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        label: Text("Name"),
                        hintText: "Enter your name",
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "Please enter your name"
                          : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: Text("Email"),
                        hintText: "Enter your email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        label: Text("Password"),
                        hintText: "Enter your password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _rePasswordController,
                      decoration: InputDecoration(
                        label: Text("Re-enter Password"),
                        hintText: "Re-enter your password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please re-enter your password";
                        }
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    FilledButton(
                      onPressed:
                          (_isSubmitting || widget.viewModel.register.running)
                          ? null
                          : _submitForm,
                      child:
                          (_isSubmitting || widget.viewModel.register.running)
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
