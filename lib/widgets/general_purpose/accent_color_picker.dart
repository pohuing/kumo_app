import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../blocs/theme_cubit.dart';

class AccentColorPicker extends StatefulWidget {
  const AccentColorPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<AccentColorPicker> createState() => _AccentColorPickerState();

  static Future<void> showColorPickerDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) => const AccentColorPicker(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
    );
  }
}

class _AccentColorPickerState extends State<AccentColorPicker> {
  late Color currentColor;

  @override
  Widget build(BuildContext context) {
    var brightScheme =
        ThemeCubit.getTheme(isBright: true, seed: currentColor).colorScheme;
    var darkScheme =
        ThemeCubit.getTheme(isBright: false, seed: currentColor).colorScheme;

    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 1,
      snapSizes: [1],
      snap: true,
      builder: (context, controller) => Column(
        children: [
          AppBar(title: const Text('Select a new color seed')),
          ColorPicker(
            enableAlpha: false,
            pickerColor: currentColor,
            onColorChanged: (color) => setState(() => currentColor = color),
            displayThumbColor: true,
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
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ThemeCubit>().setSeed(currentColor);
              Navigator.pop(context);
            },
            child: Text(
              'Save color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentColor = ThemeCubit.seed;
  }
}
