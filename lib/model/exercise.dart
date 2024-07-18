class Exercise {
  String? name;
  String? force;
  String? level;
  String? mechanic;
  String? equipment;
  List<String>? primaryMuscles;
  List<String>? secondaryMuscles;
  List<String>? instructions;
  String? category;
  List<String>? images;
  String? id;

  Exercise(
      {this.name,
      this.force,
      this.level,
      this.mechanic,
      this.equipment,
      this.primaryMuscles,
      this.secondaryMuscles,
      this.instructions,
      this.category,
      this.images,
      this.id});

  Exercise.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    force = json['force'];
    level = json['level'];
    mechanic = json['mechanic'];
    equipment = json['equipment'];
    primaryMuscles = json['primaryMuscles'].cast<String>();
    if (json['secondaryMuscles'] != null) {
      secondaryMuscles = <String>[];
      json['secondaryMuscles'].forEach((v) {
        secondaryMuscles!.add(v);
      });
    }
    instructions = json['instructions'].cast<String>();
    category = json['category'];
    images = json['images'].cast<String>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['force'] = force;
    data['level'] = level;
    data['mechanic'] = mechanic;
    data['equipment'] = equipment;
    data['primaryMuscles'] = primaryMuscles;
    if (secondaryMuscles != null) {
      data['secondaryMuscles'] = secondaryMuscles!.map((v) => v).toList();
    }
    data['instructions'] = instructions;
    data['category'] = category;
    data['images'] = images;
    data['id'] = id;
    return data;
  }
}
