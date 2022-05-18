import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc.dart';
import '../blocs/theme_cubit.dart';

class CommonAppBar extends AppBar {
  final String _title;

  CommonAppBar({Key? key, required String title})
      : _title = title,
        super(key: key, actions: [
          PopupMenuButton(
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
                                Icons.brightness_1,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      )
                    ],
                  ),
                ),
                if (context.read<AuthenticationCubit>().state is SignedInState)
                  PopupMenuItem(
                    onTap: () async {
                      await context.read<AuthenticationCubit>().signOut();
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
          )
        ]);

  @override
  Widget get title => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Text(_title),
      );
}
