import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class Equipment extends StatelessWidget {
  const Equipment({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getImageWidget(exercise.equipment),
        const SizedBox(width: 8.0),
        Text(
          exercise.equipment ?? 'Unknown',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _getImageWidget(String? equipment) {
    // Map of equipment types to their corresponding asset paths
    const equipmentImages = {
      "body only": "lib/assets/images/body.png",
      "machine": "lib/assets/images/machine.png",
      "other": "lib/assets/images/other.png",
      "foam roll": "lib/assets/images/foam_roll.png",
      "kettlebells": "lib/assets/images/kettlebells.png",
      "dumbbell": "lib/assets/images/dumbbell.png",
      "cable": "lib/assets/images/cable.png",
      "barbell": "lib/assets/images/barbell.png",
      "bands": "lib/assets/images/bands.png",
      "medicine ball": "lib/assets/images/medicine_ball.png",
      "exercise": "lib/assets/images/exercise.png",
      "e-z curl bar": "lib/assets/images/ezcurlbar.png",
    };

    // Retrieve the image path based on the equipment type
    final imagePath = equipmentImages[equipment?.toLowerCase() ?? ""];

    if (imagePath != null) {
      return Image.asset(
        imagePath,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
      );
    } else {
      // Fallback placeholder if the equipment type is unknown
      return const Placeholder(
        fallbackHeight: 100,
        fallbackWidth: 100,
        color: Colors.grey,
      );
    }
  }
}
