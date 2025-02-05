import 'package:flutter/material.dart';

String convertNumberToWeekday(int number) {
  switch (number) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Invalid';
  }
}

IconData getWorkoutIcon(String? workoutType) {
  switch (workoutType?.toLowerCase()) {
    case 'strength':
      return Icons.fitness_center;
    case 'cardio':
      return Icons.directions_run;
    case 'flexibility':
      return Icons.self_improvement;
    case 'hiit':
      return Icons.timer;
    default:
      return Icons.sports_gymnastics;
  }
}
