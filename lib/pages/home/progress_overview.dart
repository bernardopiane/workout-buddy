import 'package:flutter/material.dart';
import 'package:workout_buddy/theme_data.dart';

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Progress Overview",
          style: titleTextStyle,
        ),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "Workouts completed",
                value: "25",
              ),
            ),
            Expanded(
              child: StatCard(
                title: "Total workouts",
                value: "100",
              ),
            ),
          ],
        )
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 128,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: bodyTextStyle),
              // TODO Fix styling
              Text(
                value,
                style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
