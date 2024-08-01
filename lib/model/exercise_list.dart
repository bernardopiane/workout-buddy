import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'exercise.dart';

class ExerciseList extends ChangeNotifier {
  Set<Exercise> exercises = <Exercise>{};

  ExerciseList() {
    loadExercises('lib/data/dataset.json');
  }

  Future<void> loadExercises(String path) async {
    try {
      final contents = await rootBundle.loadString(path);
      final List<dynamic> jsonData = json.decode(contents);
      exercises = jsonData.map((json) => Exercise.fromJson(json)).toSet();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }

  Set<Exercise> getAllExercises() {
    return exercises;
  }

  Set<Exercise> getExercisesByMuscle(String muscle) {
    return exercises
        .where((exercise) => exercise.primaryMuscles!.contains(muscle))
        .toSet();
  }
}
