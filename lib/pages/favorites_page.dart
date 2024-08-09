import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/favorites.dart';
import '../widgets/exercise_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Favorites Page"),
        const Text("List of favorite exercises"),
        Expanded(
          child: Consumer<Favorites>(
            builder: (context, favoritesNotifier, child) {
              // Return a list of favorite exercises
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: favoritesNotifier.exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseCard(
                    exercise: favoritesNotifier.exercises.elementAt(index),
                  );
                },
                padding: const EdgeInsets.all(16.0),
              );
            },
          ),
        ),
      ],
    );
  }
}
