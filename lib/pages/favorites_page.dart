import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          Text("Favorites Page"),
          Text("List of favorite exercises")
        ],
      ),
    );
  }
}
