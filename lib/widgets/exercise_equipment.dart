import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class ExerciseEquipment extends StatelessWidget {
  const ExerciseEquipment({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Increased elevation for better shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getImageWidget(exercise.equipment, context),
            const SizedBox(
                width: 16.0), // Increased space between image and text
            Expanded(
              // Allow text to expand and occupy available space
              child: Text(
                exercise.equipment?.toUpperCase() ?? 'UNKNOWN',
                style: TextStyle(
                  fontSize: 20.0, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface, // Use theme color
                  letterSpacing: 1.2, // Added letter spacing for readability
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImageWidget(String? equipment, BuildContext context) {
    // Map of equipment types to their corresponding asset paths
    const equipmentImages = {
      "body only": "lib/assets/images/Body Only.png",
      "machine": "lib/assets/images/Machine.png",
      "other": "lib/assets/images/Other.png",
      "foam roll": "lib/assets/images/Foam Roll.png",
      "kettlebells": "lib/assets/images/Kettlebells.png",
      "dumbbell": "lib/assets/images/Dumbbell.png",
      "cable": "lib/assets/images/Cable.png",
      "barbell": "lib/assets/images/Barbell.png",
      "bands": "lib/assets/images/Bands.png",
      "medicine ball": "lib/assets/images/Medicine Ball.png",
      "exercise ball": "lib/assets/images/Exercise Ball.png",
      "e-z curl bar": "lib/assets/images/E-Z Curl Bar.png",
    };

    // Retrieve the image path based on the equipment type
    final imagePath = equipmentImages[equipment?.toLowerCase() ?? ""];

    debugPrint("Image path: $imagePath");

    if (imagePath != null) {
      // If current theme is dark, invert the image colors
      return Image.asset(
        imagePath,
        height: 30, // Increased image size for better visibility
        width: 30,
        fit: BoxFit.contain,
        color: Theme.of(context).colorScheme.primary,
      );
    } else {
      // Fallback placeholder if the equipment type is unknown
      return const Placeholder(
        fallbackHeight: 30,
        fallbackWidth: 30,
        color: Colors.grey,
      );
    }
  }
}
