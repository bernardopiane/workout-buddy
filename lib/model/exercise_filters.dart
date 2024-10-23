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

  // copyWith method
  ExerciseFilters copyWith({
    String? primaryMuscle,
    String? secondaryMuscle,
    String? level,
    String? force,
    String? equipment,
    String? mechanic,
    String? category,
  }) {
    return ExerciseFilters(
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      secondaryMuscle: secondaryMuscle ?? this.secondaryMuscle,
      level: level ?? this.level,
      force: force ?? this.force,
      equipment: equipment ?? this.equipment,
      mechanic: mechanic ?? this.mechanic,
      category: category ?? this.category,
    );
  }

  // ToString override
  @override
  String toString() {
    return 'ExerciseFilters{primaryMuscle: $primaryMuscle, secondaryMuscle: $secondaryMuscle, level: $level, force: $force, equipment: $equipment, mechanic: $mechanic, category: $category}';
  }
}
