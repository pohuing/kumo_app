import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../blocs/theme_cubit.dart';

class AccentColorPicker extends StatelessWidget {
  const AccentColorPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorPicker(
          enableAlpha: false,
          pickerColor: ThemeCubit.seed,
          onColorChanged: (color) => context.read<ThemeCubit>().setSeed(color),
        ),
        const SizedBox(height: 16),
        Text(
          'Bright theme',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            var brightScheme = ThemeCubit.getTheme(isBright: true).colorScheme;
            return Row(
              children: [
                Flexible(
                  child: Container(height: 10, color: brightScheme.primary),
                ),
                Flexible(
                  child: Container(
                    height: 10,
                    color: brightScheme.secondary,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 10,
                    color: brightScheme.tertiary,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Dark theme',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            var darkScheme = ThemeCubit.getTheme(isBright: false).colorScheme;
            return Row(
              children: [
                Flexible(
                  child: Container(height: 10, color: darkScheme.primary),
                ),
                Flexible(
                  child: Container(
                    height: 10,
                    color: darkScheme.secondary,
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 10,
                    color: darkScheme.tertiary,
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
