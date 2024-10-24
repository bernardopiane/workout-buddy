
import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final Set<String> options;
  final ValueChanged<String?> onChanged;
  final bool showAllOption;

  const FilterDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.options,
    required this.onChanged,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color; // Get text color from theme

    return DropdownButton<String>(
      value: value,
      hint: Text(
        hintText,
        style: TextStyle(color: textColor), // Apply text color to hint
      ),
      onChanged: onChanged,
      items: [
        if (showAllOption)
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'All ${hintText.replaceAll('Select ', '')}s',
              style: TextStyle(color: textColor), // Apply text color to "All" option
            ),
          ),
        ...options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value.toLowerCase(),
            child: Text(
              value,
              style: TextStyle(color: textColor), // Apply text color to dropdown items
            ),
          );
        }),
      ],
    );
  }
}