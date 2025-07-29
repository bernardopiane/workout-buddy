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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Sort options for consistent display
    final sortedOptions = options.toList()..sort();

    return DropdownButtonFormField<String?>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        // Subtle background
        hintText: hintText,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Clean, no border
        ),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color: colorScheme.primary)),
        // Add subtle focus indicator
        prefixIcon: Icon(Icons.filter_list,
            size: 18, color: colorScheme.primary.withOpacity(0.7)),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
      style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      dropdownColor: colorScheme.surface,
      // Match dark/light mode
      icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
      isExpanded: true,
      onChanged: onChanged,
      items: [
        if (showAllOption)
          DropdownMenuItem<String?>(
            value: null,
            child: Text(
              'All ${hintText.replaceAll(RegExp(r'^Select\s+'), '')}',
              style:
                  textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
          ),
        ...sortedOptions.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item.toLowerCase(),
            child: Text(
              item,
              style:
                  textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
          );
        }),
      ],
    );
  }
}
