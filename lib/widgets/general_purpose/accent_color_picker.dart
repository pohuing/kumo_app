import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../blocs/theme_cubit.dart';

class AccentColorPicker extends StatefulWidget {
  final void Function(
    Color color,
    bool m3,
    bool isBright,
    bool respectSystemBrightness,
  )? onChange;

  const AccentColorPicker({
    Key? key,
    this.onChange,
  }) : super(key: key);

  @override
  State<AccentColorPicker> createState() => AccentColorPickerState();

  static Future<void> showColorPickerDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      enableDrag: true,
      builder: (context) => const AccentColorPicker(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    );
  }
}

class AccentColorPickerState extends State<AccentColorPicker> {
  late Color currentColor;
  late bool useMaterial3;
  late bool isBright;
  late bool respectSystemBrightness;

  @override
  Widget build(BuildContext context) {
    var brightScheme = ThemeCubit.getTheme(
      isBright: true,
      seed: currentColor,
      m3: useMaterial3,
    ).colorScheme;
    var darkScheme = ThemeCubit.getTheme(
      isBright: false,
      seed: currentColor,
      m3: useMaterial3,
    ).colorScheme;

    return ListView(
      children: [
        ColorPicker(
          enableAlpha: false,
          pickerColor: currentColor,
          onColorChanged: (color) {
            setState(() => currentColor = color);
            onChange();
          },
          displayThumbColor: true,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Bright theme',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: Container(
                height: 10,
                color: brightScheme.primary,
              ),
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
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Dark theme',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: Container(
                height: 10,
                color: darkScheme.primary,
              ),
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
        ),
        const SizedBox(height: 16),
        SwitchListTile.adaptive(
          title: const Text('Use Material 3'),
          value: useMaterial3,
          onChanged: (v) {
            setState(() => useMaterial3 = v);
            onChange();
          },
        ),
        SwitchListTile.adaptive(
          title: const Text('Bright Theme'),
          value: isBright,
          onChanged: (b) {
            setState(() => isBright = b);
            onChange();
          },
        ),
        SwitchListTile.adaptive(
          title: const Text('Respect System Brightness'),
          value: respectSystemBrightness,
          onChanged: (b) {
            setState(() => respectSystemBrightness = b);
            onChange();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    useMaterial3 = context.read<ThemeCubit>().state.m3;
    isBright = context.read<ThemeCubit>().state.isBright;
    currentColor = context.read<ThemeCubit>().state.seed;
    respectSystemBrightness =
        context.read<ThemeCubit>().state.respectSystemBrightness;
    super.initState();
  }

  void onChange() {
    widget.onChange?.call(
      currentColor,
      useMaterial3,
      isBright,
      respectSystemBrightness,
    );
  }
}
