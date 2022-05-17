import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication_bloc.dart';
import '../blocs/theme_cubit.dart';

class CommonAppBar extends AppBar {
  String _title;
  final List<Widget> actions = [
    PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () => context.read<ThemeCubit>().switchTheme(),
            child: Row(
              children: [
                Text('Toggle Theme'),
                Spacer(),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) => state.isBright
                      ? Icon(Icons.brightness_2_outlined)
                      : Icon(Icons.brightness_1_outlined),
                )
              ],
            ),
          ),
          if (context.read<AuthenticationBloc>().state is SignedInState)
            PopupMenuItem(
              onTap: () => context.read<AuthenticationBloc>().signOut(),
              child: Row(
                children: [Text('Sign out'), Spacer(), Icon(Icons.logout)],
              ),
            ),
        ];
      },
    )
  ];

  CommonAppBar({Key? key, required String title}) : _title = title, super(key: key);

  Widget get title => Text(_title);
}
