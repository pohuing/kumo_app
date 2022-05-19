import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kumo_app/widgets/general_purpose/accent_color_picker.dart';

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
      onSelected: (OverflowActions value) async {
        switch (value) {
          case OverflowActions.signOut:
            await context.read<AuthenticationCubit>().signOut();
            // ignore: use_build_context_synchronously
            await Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed('/');
            break;
          case OverflowActions.toggleTheme:
            context.read<ThemeCubit>().switchTheme();
            break;
          case OverflowActions.editTheme:
            await AccentColorPicker.showColorPickerDialog(context);
            break;
          case OverflowActions.managePathPoints:
            await Navigator.of(context).pushNamed('/managePathPoints');
            break;
          case OverflowActions.toggleM3:
            context.read<ThemeCubit>().toggleM3();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: OverflowActions.toggleTheme,
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
            value: OverflowActions.toggleM3,
            child: Row(
              children: [
                const Text('Toggle M3'),
                const Spacer(),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) => Text(
                      textAlign: TextAlign.center,
                      state.m3 ? '3' : '2',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                )
              ],
            ),
          ),
          PopupMenuItem(
            value: OverflowActions.editTheme,
            child: Row(
              children: [
                const Text('Edit Theme'),
                const Spacer(),
                Icon(
                  Icons.color_lens,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          if (context.read<AuthenticationCubit>().state is SignedInState)
            PopupMenuItem(
              value: OverflowActions.managePathPoints,
              child: Row(
                children: [
                  const Text('Manage Path Points'),
                  const Spacer(),
                  Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  )
                ],
              ),
            ),
          PopupMenuItem(
            value: OverflowActions.signOut,
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

enum OverflowActions {
  signOut,
  toggleTheme,
  editTheme,
  managePathPoints,
  toggleM3
}
