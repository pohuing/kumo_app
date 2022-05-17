import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/blocs/authentication_bloc.dart';
import 'package:kumo_app/widgets/sign_up_screen.dart';

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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AutofillGroup(
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Text('Email:', style: Theme.of(context).textTheme.titleMedium),
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
            Text('Password:', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              autofillHints: [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.go,
              obscureText: true,
              validator: (value) {
                return (value ?? "").length >= 6
                    ? null
                    : 'Your password must at least be 6 characters long';
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
                    if (await context.read<AuthenticationBloc>().signIn(
                        _emailController.text, _passwordController.text))
                      Navigator.of(context)
                          .pushNamed('/explore', arguments: '');
                  },
                  child: const Text('Sign in'),
                );
              },
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) => Text(state.runtimeType.toString()),
            ),
            MaterialButton(
              onPressed: () async {
                final result = await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ));
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
    );
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
