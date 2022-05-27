import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme_cubit.dart';
import 'accent_color_picker.dart';
import 'material_adaptive_scaffold.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  var globalKey = GlobalKey<AccentColorPickerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialAdaptiveScaffold(
      body: AccentColorPicker(
        key: globalKey,
        onChange: (color, m3, isBright, respectSystemBrightness) {},
      ),
      actions: [
        IconButton(
          onPressed: () {
            final s = globalKey.currentState;
            if (s != null) {
              context.read<ThemeCubit>().setTheme(
                    s.currentColor,
                    m3: s.useMaterial3,
                    isBright: s.isBright,
                    respectSystemTheme: s.respectSystemBrightness,
                  );
            }
          },
          icon: const Icon(Icons.save),
        )
      ],
      title: 'Edit your theme',
    );
  }
}
