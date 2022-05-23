// ignore_for_file: unnecessary_import

import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/widgets/sign_up_screen.dart';
import 'package:tuple/tuple.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (previous, current) => current is SignInErrorState,
        listener: (context, state) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(
                milliseconds:
                    max(4000, (state as SignInErrorState).cause.length * 100)),
            content: Text((state as SignInErrorState).cause),
          ),
        ),
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text('Email:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('email'),
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
                key: const Key('password'),
                controller: _passwordController,
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.go,
                obscureText: true,
                onFieldSubmitted: (value) => signInAction(),
                validator: (value) {
                  return (value ?? "").length >= 8
                      ? null
                      : 'Your password must at least be 8 characters long';
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is SigningInState) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return ElevatedButton(
                    key: const Key('log_in_button'),
                    onPressed: signInAction,
                    child: const Text('Sign in'),
                  );
                },
              ),
              MaterialButton(
                onPressed: () async {
                  final result = await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                  if (result is List<String> && result.length == 2) {
                    _emailController.text = result.first;
                    _passwordController.text = result.last;
                  }
                },
                child: Text(
                  'Want to sign up instead?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
    super.dispose();
  }

  Future<void> signInAction() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();
    if (await context
        .read<AuthenticationCubit>()
        .signIn(_emailController.text, _passwordController.text)) {
      await Navigator.of(context)
          .pushReplacementNamed('/explore', arguments: const Tuple2('', false));
    }
  }
}
