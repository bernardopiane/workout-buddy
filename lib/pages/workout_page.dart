import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO display list of selected exercises, summary of targeted muscles
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Page'),
      ),
      body: ListView(
        children: const [
          Text('Workout Page'),

        ],
      ),
    );
  }
}
