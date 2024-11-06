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
    super.initState();
    lastPosition = widget.exercise.images!.length;
  }

  @override
  Widget build(BuildContext context) {
    _precacheImages();

    return GestureDetector(
      onTap: _goToNextImage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                "lib/data/${widget.exercise.images!.elementAt(currentPosition)}",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                key: ValueKey(currentPosition),
              ),
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
            // If widget.exercise.images!.length > 1, add a touch app icon
            widget.exercise.images!.length > 1
                ? Positioned(
                    bottom: 10,
                    right: 10,
                    child: Icon(
                      Icons.touch_app,
                      color: Colors.white.withOpacity(0.2), // Subtle icon color
                      size: 30.0, // Subtle icon size
                    ),
                  )
                : const SizedBox(),
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

  void _precacheImages() {
    for (var image in widget.exercise.images!) {
      precacheImage(AssetImage("lib/data/$image"), context);
    }
  }
}
