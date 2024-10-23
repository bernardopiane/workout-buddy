class ExerciseFilters {
  final String primaryMuscle;
  final String secondaryMuscle;
  final String level;
  final String force;
  final String equipment;
  final String mechanic;
  final String category;

  ExerciseFilters({
    this.primaryMuscle = '',
    this.secondaryMuscle = '',
    this.level = '',
    this.force = '',
    this.equipment = '',
    this.mechanic = '',
    this.category = '',
  });

//   ToString override
  @override
  String toString() {
    return 'ExerciseFilters{primaryMuscle: $primaryMuscle, secondaryMuscle: $secondaryMuscle, level: $level, force: $force, equipment: $equipment, mechanic: $mechanic, category: $category}';
  }
}