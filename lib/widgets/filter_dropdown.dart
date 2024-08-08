
import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final Set<String> options;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return DropdownButton<String>(
      value: value,
      hint: Text(hintText),
      onChanged: onChanged,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('All ${hintText.replaceAll('Select ', '')}s'),
        ),
        ...options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value.toLowerCase(),
            child: Text(value),
          );
        }),
      ],
    );
  }
}