import 'package:flutter/material.dart';

class ExerciseLevel extends StatelessWidget {
  const ExerciseLevel({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    if (level == "beginner") {
      return const Row(
        children: [
          Text("Difficulty: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Icon(Icons.star, color: Colors.white,),
          Icon(Icons.star_border_outlined, color: Colors.white,),
          Icon(Icons.star_border_outlined, color: Colors.white,),
        ],
      );
    }

    if (level == "intermediate") {
      return const Row(
        children: [
          Text("Difficulty: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Icon(Icons.star, color: Colors.white,),
          Icon(Icons.star, color: Colors.white,),
          Icon(Icons.star_border_outlined, color: Colors.white,),
        ],
      );
    }

    if (level == "expert") {
      return const Row(
        children: [
          Text("Difficulty: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Icon(Icons.star, color: Colors.white,),
          Icon(Icons.star, color: Colors.white,),
          Icon(Icons.star, color: Colors.white,),
        ],
      );
    }

    return Text("Difficulty: $level");
  }
}
