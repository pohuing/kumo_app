import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme_cubit.dart';
import 'accent_color_picker.dart';
import 'material_adaptive_scaffold.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialAdaptiveScaffold(
      body: AccentColorPicker(
        onChange: (color, m3, isBright) {
          context
              .read<ThemeCubit>()
              .setTheme(color, m3: m3, isBright: isBright);
        },
      ),
      title: 'Edit your theme',
    );
  }
}
