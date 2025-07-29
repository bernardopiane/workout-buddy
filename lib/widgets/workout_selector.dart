import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/workout_day.dart';
import '../global.dart';
import '../model/exercise.dart';
import '../model/exercise_list.dart';
import 'filter_dropdown.dart';

class WorkoutSelector extends StatefulWidget {
  const WorkoutSelector({
    super.key,
    required this.workoutDay,
    required this.addWorkout,
    required this.removeWorkout,
  });

  final WorkoutDay workoutDay;
  final Function(WorkoutDay workoutDay, Exercise exercise) addWorkout;
  final Function(WorkoutDay workoutDay, Exercise exercise) removeWorkout;

  @override
  State<WorkoutSelector> createState() => _WorkoutSelectorState();
}

class _WorkoutSelectorState extends State<WorkoutSelector> {
  String _searchQuery = '';
  String? selectedPrimaryMuscle;
  String? selectedCategory;
  Set<String> selectedDifficulties = difficultyLevels.toSet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Consumer<ExerciseList>(
      builder: (context, exerciseList, child) {
        final exercises = exerciseList.getAllExercises();

        // Filter logic
        Set<Exercise> filteredExercises = exercises.where((exercise) {
          final matchesSearch = _searchQuery.isEmpty ||
              exercise.name!.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesDifficulty = selectedDifficulties.isEmpty ||
              selectedDifficulties
                  .map((d) => d.toLowerCase())
                  .contains(exercise.level?.toLowerCase());
          final matchesMuscle = selectedPrimaryMuscle == null ||
              exercise.primaryMuscles?.contains(selectedPrimaryMuscle) == true;
          final matchesCategory =
              selectedCategory == null || exercise.category == selectedCategory;

          return matchesSearch &&
              matchesDifficulty &&
              matchesMuscle &&
              matchesCategory;
        }).toSet();

        return Container(
          padding: EdgeInsets.only(
            top: 12,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface, // ✅ Theme surface (light/dark)
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Draggable handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withOpacity(0.4),
                    // ✅ Theme-aware
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                'Select Workouts for ${widget.workoutDay.dayName}',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Search Field
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceVariant,
                  // ✅ Subtle fill
                  hintText: 'Search exercises...',
                  hintStyle: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  isDense: true,
                ),
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurface),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Difficulty Filter Chips
              Wrap(
                spacing: 6,
                children: difficultyLevels.map((level) {
                  final isSelected = selectedDifficulties.contains(level);
                  return FilterChip(
                    label: Text(level),
                    labelStyle: isSelected
                        ? const TextStyle(color: Colors.white)
                        : null,
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedDifficulties.add(level);
                        } else {
                          selectedDifficulties.remove(level);
                        }
                      });
                    },
                    selectedColor: colorScheme.primary,
                    // ✅ Theme primary
                    side: !isSelected
                        ? BorderSide(
                            color: colorScheme.outline.withOpacity(0.3))
                        : null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Dropdown Filters
              Row(
                children: [
                  Expanded(
                    child: FilterDropdown(
                      hintText: 'Muscle Group',
                      value: selectedPrimaryMuscle,
                      options: primaryMuscles,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPrimaryMuscle = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilterDropdown(
                      hintText: 'Category',
                      value: selectedCategory,
                      options: categories,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Results Count
              Text(
                '${filteredExercises.length} exercise(s) found',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),

              // Exercise List
              filteredExercises.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No exercises match your filters',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = filteredExercises.elementAt(index);
                          final isSelected = widget.workoutDay.workouts
                              .any((e) => e.name == exercise.name);

                          return Card(
                      elevation: isSelected ? 2 : 1,
                      color: isSelected
                          ? colorScheme.primaryContainer // ✅ Subtle highlight
                          : colorScheme.surface, // ✅ Match background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CheckboxListTile(
                        dense: true,
                        title: Text(
                          exercise.name!,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          [
                            exercise.category ?? '',
                            exercise.level ?? '',
                            exercise.primaryMuscles?.join(', ') ?? ''
                          ].join(' • '),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            widget.addWorkout(widget.workoutDay, exercise);
                          } else {
                            widget.removeWorkout(widget.workoutDay, exercise);
                          }
                          setState(() {
                            // Rebuild to update checkbox and styling
                          });
                        },
                        activeColor: colorScheme.primary,
                        checkColor: colorScheme.onPrimary,
                        controlAffinity: ListTileControlAffinity.leading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}