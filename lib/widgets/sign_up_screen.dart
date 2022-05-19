import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/widgets/general_purpose/common_app_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Sign up'),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AutofillGroup(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Text('Email:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                autofillHints: const [AutofillHints.email],
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
              const SizedBox(height: 16),
              Text('Password:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: true,
                validator: (value) {
                  return (value ?? "").length >= 8
                      ? null
                      : 'Your password must at least be 8 characters long';
                },
              ),
              const SizedBox(height: 16),
              Text('Repeat password:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordRepeatController,
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: true,
                onFieldSubmitted: (v) => signupAction(),
                validator: (value) {
                  return value == _passwordController.text
                      ? null
                      : 'Passwords have to match';
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is SigningInState) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  return ElevatedButton(
                    onPressed: signupAction,
                    child: const Text('Sign up'),
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  Future<void> signupAction() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();
    final result = await context
        .read<AuthenticationCubit>()
        .signUp(_emailController.text, _passwordController.text);
    if (result == true) {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pop([_emailController.text, _passwordController.text]);
    }
  }
}
