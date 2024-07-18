import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_buddy/widgets/exercise_card.dart';
import '../model/exercise.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Exercise>> _futureExercises;

  @override
  void initState() {
    super.initState();
    _futureExercises = loadExercises('lib/data/dataset.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Exercise>>(
          future: _futureExercises,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ExerciseCard(exercise: snapshot.data![index]);
                },
              );
            } else {
              return const Center(child: Text('No exercises found'));
            }
          },
        ),
      ),
    );
  }

  Future<List<Exercise>> loadExercises(String path) async {
    try {
      final file = File(path);
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}
