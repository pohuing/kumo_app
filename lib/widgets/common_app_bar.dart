import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc.dart';
import '../blocs/theme_cubit.dart';

class CommonAppBar extends AppBar {
  final String _title;


  CommonAppBar({Key? key, required String title}) : _title = title, super(key: key, actions: [
    PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => context.read<ThemeCubit>().switchTheme(),
            child: Row(
              children: [const
                Text('Toggle Theme'),
                const Spacer(),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) => state.isBright
                      ? const Icon(Icons.brightness_2_outlined)
                      : const Icon(Icons.brightness_1_outlined),
                )
              ],
            ),
          ),
          if (context.read<AuthenticationCubit>().state is SignedInState)
            PopupMenuItem(
              onTap: () async {
                await context.read<AuthenticationCubit>().signOut();
                await Navigator.of(context, rootNavigator: true).pushReplacementNamed('/');
              },
              child: Row(
                children: const [Text('Sign out'), Spacer(), Icon(Icons.logout)],
              ),
            ),
        ];
      },
    )
  ]);

  @override
  Widget get title => Text(_title);
}
