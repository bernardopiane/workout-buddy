import 'package:flutter/material.dart';
import 'package:workout_buddy/model/exercise.dart';

class RelatedCard extends StatelessWidget {
  const RelatedCard({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        elevation: 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Image.asset(
                "lib/data/${exercise.images!.elementAt(0)}",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    stops: [0, 0.50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Text(
                  exercise.name.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
