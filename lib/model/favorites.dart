import 'package:workout_buddy/model/exercise.dart';

class Favorites{
  List<Exercise> exercises;

  Favorites(this.exercises);

  addToFavorites(Exercise e){
    if(!exercises.contains(e)){
      exercises.add(e);
    }
  }

  removeFromFavorites(Exercise e){
    exercises.removeWhere((current) => current.id == e.id);
  }
}