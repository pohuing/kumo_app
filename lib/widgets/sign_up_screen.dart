import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/widgets/common_app_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();
  final _emailController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Sign up'),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AutofillGroup(
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.all(16),
            children: [
              Text('Email:'),
              SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                autofillHints: [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (EmailValidator.validate(value!)) {
                    return null;
                  } else {
                    return 'Please enter an email address';
                  }
                },
              ),
              SizedBox(height: 16),
              Text('Password:'),
              SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: true,
                validator: (value) {
                  return (value ?? "").length >= 8
                      ? null
                      : 'Your password must at least be 8 characters long';
                },
              ),
              SizedBox(height: 16),
              Text('Repeat password:'),
              SizedBox(height: 8),
              TextFormField(
                controller: _passwordRepeatController,
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: true,
                validator: (value) {
                  return value == _passwordController.text
                      ? null
                      : 'Passwords have to match';
                },
              ),
              SizedBox(height: 16),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is SigningInState) {
                    return Center(child: CircularProgressIndicator.adaptive());
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState?.save();
                      final result = await context
                          .read<AuthenticationBloc>()
                          .signUp(
                              _emailController.text, _passwordController.text);
                      if (result == true) {
                        Navigator.of(context).pop(
                            [_emailController.text, _passwordController.text]);
                      }
                    },
                    child: const Text('Sign in'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }
}
