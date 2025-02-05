import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_buddy/model/favorites.dart';
import 'package:workout_buddy/model/settings.dart';
import 'package:workout_buddy/model/workout_plan.dart';
import 'package:workout_buddy/providers/workout_plan_manager.dart';
import 'package:workout_buddy/pages/home_page.dart';
import 'package:workout_buddy/pages/onboarding_page.dart';
import 'package:workout_buddy/theme_data.dart';

import 'model/exercise_list.dart';
import 'model/user_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO implement Supabase features
  // await Supabase.initialize(
  //   url: 'https://hieuqpydsjhaxmffqfoc.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhpZXVxcHlkc2poYXhtZmZxZm9jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjE1MTQ1MjMsImV4cCI6MjAzNzA5MDUyM30.Y38cTModuek0kKNp5Qq8UsB3V073EmB75VahG6a_c0g',
  // );

  final favorites = Favorites();
  await favorites.loadFavorites();

  final workoutPlan = WorkoutPlan();
  await workoutPlan.loadFromSharedPreferences();

  final userData = UserData();
  await userData.loadUserData();

  final workoutPlanManager = WorkoutPlanManager();
  await workoutPlanManager.loadAllPlansFromSharedPreferences();
  await workoutPlanManager.loadSelectedPlanFromSharedPreferences();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => favorites),
      ChangeNotifierProvider(create: (_) => ExerciseList()),
      ChangeNotifierProvider(create: (_) => workoutPlan),
      ChangeNotifierProvider(create: (_) => userData),
      ChangeNotifierProvider(create: (_) => workoutPlanManager),
      ChangeNotifierProvider(create: (_) => Settings()),
    ], child: const WorkoutBuddyApp()),
  );
}

class WorkoutBuddyApp extends StatefulWidget {
  const WorkoutBuddyApp({super.key});

  @override
  State<WorkoutBuddyApp> createState() => _WorkoutBuddyAppState();
}

class _WorkoutBuddyAppState extends State<WorkoutBuddyApp> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = SharedPreferencesAsync();
    final isFirstLaunch = await prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('first_launch', false);
      setState(() {
        _isFirstLaunch = true;
      });
    } else {
      setState(() {
        _isFirstLaunch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Workout Buddy',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.useDarkTheme
              ? ThemeMode.dark
              : ThemeMode.light, // Use settings.useDarkTheme
          home: _isFirstLaunch ? const OnboardingPage() : const HomePage(),
        );
      },
    );
  }
}
