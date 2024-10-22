import 'package:flutter/material.dart';

class MuscleColumn extends StatefulWidget {
  final String title;
  final List<String>? muscles;

  const MuscleColumn({super.key, required this.title, required this.muscles});

  @override
  MuscleColumnState createState() => MuscleColumnState();
}

class MuscleColumnState extends State<MuscleColumn> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8.0),

            // Display muscles (first two visible, rest collapsible)
            if (widget.muscles != null && widget.muscles!.isNotEmpty)
              _buildMusclesChips(context, widget.muscles!),
          ],
        ),
      ),
    );
  }

  Widget _buildMusclesChips(BuildContext context, List<String> muscles) {
    // Determine the muscles to show and hide
    List<String> visibleMuscles = muscles.take(2).toList();
    List<String> hiddenMuscles = muscles.length > 2 ? muscles.sublist(2) : [];

    return ExpansionTile(
      dense: true,
      title: Wrap(
        children: visibleMuscles.map((muscle) {
          return Chip(
            label: Text(
              muscle.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
        }).toList(),
      ),
      children: [
        // Show the hidden muscles when expanded
        if (hiddenMuscles.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: hiddenMuscles.map((muscle) {
              return Chip(
                label: Text(
                  muscle.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
      ],
    );
  }
}
