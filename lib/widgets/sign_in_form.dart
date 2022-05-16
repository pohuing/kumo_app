import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/AuthenticationBloc.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: [
            Text('Email:', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _emailController,
              autofillHints: [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (EmailValidator.validate(value!)) {
                  return null;
                } else {
                  return 'Please enter an email address';
                }
              },
            ),
            SizedBox(
              height: 16,
            ),
            Text('Password:', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _passwordController,
              autofillHints: [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) {
                return (value ?? "").length >= 6
                    ? null
                    : 'Your password must at least be 6 characters long';
              },
            ),
            SizedBox(
              height: 16,
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is SigningInState) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                return ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState?.save();
                    context
                        .read<AuthenticationBloc>()
                        .signIn(_emailController.text, _passwordController.text);
                  },
                  child: const Text('Sign in'),
                );
              },
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) => Text(state.runtimeType.toString()),
            )
          ],
        ),
      ),
    );
  }
}
