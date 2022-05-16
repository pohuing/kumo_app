import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/AuthenticationBloc.dart';
import '../blocs/ThemeCubit.dart';

class CommonAppBar extends AppBar {
  CommonAppBar({Key? key}) : super(key: key);

  List<Widget> actions = [
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
}
