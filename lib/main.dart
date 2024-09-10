import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 // import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_buddy/model/favorites.dart';
import 'package:workout_buddy/model/workout_plan.dart';
import 'package:workout_buddy/pages/home_page.dart';
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
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Favorites()),
      ChangeNotifierProvider(create: (_) => ExerciseList()),
      ChangeNotifierProvider(create: (_) => WorkoutPlan()),
      ChangeNotifierProvider(create: (_) => UserData()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<Favorites>(context, listen: false).loadFavorites();
    Provider.of<WorkoutPlan>(context, listen: false)
        .loadFromSharedPreferences();
    Provider.of<UserData>(context, listen: false).loadUserData();
    return MaterialApp(
      title: 'Workout Buddy',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Use system theme by default
      home: const HomePage(),
    );
  }
}
