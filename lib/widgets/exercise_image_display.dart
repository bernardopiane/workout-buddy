import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

import 'exercise_level.dart';

class ExerciseImageDisplay extends StatefulWidget {
  const ExerciseImageDisplay({super.key, required this.exercise});
  final Exercise exercise;

  @override
  State<ExerciseImageDisplay> createState() => _ExerciseImageDisplayState();
}

class _ExerciseImageDisplayState extends State<ExerciseImageDisplay> {
  int currentPosition = 0;
  int lastPosition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lastPosition = widget.exercise.images!.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToNextImage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Image.asset(
              "lib/data/${widget.exercise.images!.elementAt(currentPosition)}",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  stops: [0, 0.50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              child: ExerciseLevel(level: widget.exercise.level!),
            ),
          ],
        ),
      ),
    );
  }

  _goToNextImage() {
    if (currentPosition == lastPosition - 1) {
      setState(() {
        currentPosition = 0;
      });
    } else {
      setState(() {
        currentPosition++;
      });
    }
  }
}
