import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseEquipment extends StatelessWidget {
  const ExerciseEquipment({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getImageWidget(exercise.equipment),
            const SizedBox(width: 8.0),
            Text(
              exercise.equipment?.toUpperCase() ?? 'Unknown',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImageWidget(String? equipment) {
    // Map of equipment types to their corresponding asset paths
    const equipmentImages = {
      "body only": "lib/assets/images/Body Only.png",
      "machine": "lib/assets/images/Machine.png",
      "other": "lib/assets/images/Other.png",
      "foam roll":
          "lib/assets/images/Foam Roll.png", // TODO: add images for foam roll
      "kettlebells": "lib/assets/images/Kettlebells.png",
      "dumbbell": "lib/assets/images/Dumbbell.png",
      "cable": "lib/assets/images/Cable.png",
      "barbell": "lib/assets/images/Barbell.png",
      "bands": "lib/assets/images/Bands.png",
      "medicine ball": "lib/assets/images/Medicine Ball.png",
      "exercise ball": "lib/assets/images/Exercise Ball.png",
      "e-z curl bar": "lib/assets/images/E-Z Curl Bar.png",
    };
    //TODO: add attribution to images
    // "Icon made by juicy-fish from https://www.flaticon.com/authors/juicy-fish'

    // Retrieve the image path based on the equipment type
    final imagePath = equipmentImages[equipment?.toLowerCase() ?? ""];

    debugPrint("Image path: $imagePath");

    if (imagePath != null) {
      // If current theme is dark, invert the image colors
      if (PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
        return Image.asset(
          imagePath,
          height: 24,
          width: 24,
          fit: BoxFit.contain,
          color: Colors.white,
        );
      }
      return Image.asset(
        imagePath,
        height: 24,
        width: 24,
        fit: BoxFit.contain,
      );
    } else {
      // Fallback placeholder if the equipment type is unknown
      return const Placeholder(
        fallbackHeight: 24,
        fallbackWidth: 24,
        color: Colors.grey,
      );
    }
  }
}
