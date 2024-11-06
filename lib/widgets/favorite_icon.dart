import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/favorites.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Consumer<Favorites>(
      builder: (context, favoritesNotifier, child) {
        return FloatingActionButton(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              favoritesNotifier.isFavorite(exercise)
                  ? Icons.favorite
                  : Icons.favorite_border,
              key: ValueKey<bool>(favoritesNotifier.isFavorite(exercise)),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          onPressed: () {
            favoritesNotifier.toggleFavorite(exercise);
          },
        );
      },
    );
  }
}
