import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication_bloc.dart';
import '../../blocs/theme_cubit.dart';

class AppBarOverflow extends StatefulWidget {
  const AppBarOverflow({Key? key}) : super(key: key);

  @override
  State<AppBarOverflow> createState() => _AppBarOverflowState();

}

class _AppBarOverflowState extends State<AppBarOverflow> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => context.read<ThemeCubit>().switchTheme(),
            child: Row(
              children: [
                const Text('Toggle Theme'),
                const Spacer(),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) => state.isBright
                      ? Icon(
                          Icons.brightness_2,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.brightness_high_sharp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                )
              ],
            ),
          ),
          PopupMenuItem(
            child: const Text('Select color seed'),
            onTap: () async {

            },
          ),
          if (context.read<AuthenticationCubit>().state is SignedInState)
            PopupMenuItem(
              onTap: () async {
                await context.read<AuthenticationCubit>().signOut();
                // ignore: use_build_context_synchronously
                await Navigator.of(context, rootNavigator: true)
                    .pushReplacementNamed('/');
              },
              child: Row(
                children: [
                  const Text('Sign out'),
                  const Spacer(),
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            ),
        ];
      },
    );
  }
}
