import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/exercise.dart';
import 'package:workout_buddy/widgets/related_card.dart';

import '../model/exercise_list.dart';

class RelatedExercises extends StatelessWidget {
  const RelatedExercises({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return _buildRelatedExercises(context, exercise);
  }

  _buildRelatedExercises(BuildContext context, Exercise exercise) {
    //   fetch all exercises with primary muscle as this exercise
    Set<Exercise> exerciseMatched =
        Provider.of<ExerciseList>(context, listen: false)
            .getExercisesByMuscle(exercise.primaryMuscles![0]);
    // remove this exercise from the list
    exerciseMatched.remove(exercise);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: exerciseMatched.length,
      itemBuilder: (context, index) {
        return RelatedCard(exercise: exerciseMatched.elementAt(index));
      },
    );
  }
}
