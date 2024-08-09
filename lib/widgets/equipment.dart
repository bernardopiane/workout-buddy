import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class Equipment extends StatelessWidget {
  const Equipment({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getImage(exercise.equipment),
        const SizedBox(width: 8.0),
        Text(
          exercise.equipment ?? '',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _getImage(String? equipment) {
    // TODO get images for equipment
    // Placeholder until images are added
    Widget placeholder = const Placeholder(
      fallbackHeight: 100,
      fallbackWidth: 100,
      color: Colors.grey,
    );

    if (equipment == "body only") {
      return placeholder;
      return const AssetImage("lib/assets/images/body.png");
    } else if (equipment == "machine") {
      return placeholder;

      return const AssetImage("lib/assets/images/machine.png");
    } else if (equipment == "other") {
      return placeholder;

      return const AssetImage("lib/assets/images/other.png");
    } else if (equipment == "foam roll") {
      return placeholder;

      return const AssetImage("lib/assets/images/foam_roll.png");
    } else if (equipment == "kettlebells") {
      return placeholder;

      return const AssetImage("lib/assets/images/kettlebells.png");
    } else if (equipment == "dumbbell") {
      return placeholder;

      return const AssetImage("lib/assets/images/dumbbell.png");
    } else if (equipment == "cable") {
      return placeholder;

      return const AssetImage("lib/assets/images/cable.png");
    } else if (equipment == "barbell") {
      return placeholder;

      return const AssetImage("lib/assets/images/barbell.png");
    } else if (equipment == "bands") {
      return placeholder;

      return const AssetImage("lib/assets/images/bands.png");
    } else if (equipment == "medicine ball") {
      return placeholder;

      return const AssetImage("lib/assets/images/medicine_ball.png");
    } else if (equipment == "exercise") {
      return placeholder;

      return const AssetImage("lib/assets/images/exercise.png");
    } else if (equipment == "e-z curl bar") {
      return placeholder;

      return const AssetImage("lib/assets/images/ezcurlbar.png");
    } else {
      return placeholder;
      return const AssetImage("lib/assets/images/circle.png");
    }
  }
}
