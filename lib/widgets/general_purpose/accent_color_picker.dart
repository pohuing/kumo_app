import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../blocs/theme_cubit.dart';

class AccentColorPicker extends StatefulWidget {
  const AccentColorPicker({
    Key? key,
  }) : super(key: key);

  static Future<void> showColorPickerDialog(BuildContext context){
    return showDialog(context: context, builder: (context) => const AccentColorPicker());
  }

  @override
  State<AccentColorPicker> createState() => _AccentColorPickerState();
}

class _AccentColorPickerState extends State<AccentColorPicker> {
  Color currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    currentColor = ThemeCubit.seed;
  }

  @override
  Widget build(BuildContext context) {
    var brightScheme =
        ThemeCubit.getTheme(isBright: true, seed: currentColor).colorScheme;
    var darkScheme =
        ThemeCubit.getTheme(isBright: false, seed: currentColor).colorScheme;

    return AlertDialog(
      title: const Text('Select a new color seed'),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.read<ThemeCubit>().setSeed(currentColor);
          },
          child: Text(
            'Save color',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        )
      ],
      content: SingleChildScrollView(
          child: Column(
        children: [
          ColorPicker(
            enableAlpha: false,
            pickerColor: currentColor,
            onColorChanged: (color) => setState(() => currentColor = color),
          ),
          const SizedBox(height: 16),
          Text(
            'Bright theme',
            style: Theme.of(context).textTheme.titleMedium,
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
          Text(
            'Dark theme',
            style: Theme.of(context).textTheme.titleMedium,
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
        ],
      )),
    );
  }
}
