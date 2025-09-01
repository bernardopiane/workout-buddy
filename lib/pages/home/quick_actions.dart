import 'package:flutter/material.dart';

import '../../theme_data.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: titleTextStyle,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrimaryButton(),
            SecondaryButton(),
          ],
        )
      ],
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).brightness == Brightness.light
          ? secondaryElevatedButtonStyleLight
          : secondaryElevatedButtonStyleDark,
      onPressed: () {
        // TODO Handle action 2
      },
      child: const Text('Browse Exercises'),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO Handle action 1
      },
      child: const Text('Start Workout'),
    );
  }
}
