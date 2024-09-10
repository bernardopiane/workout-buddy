import 'dart:math';

class UserData {
  String name;
  int age;
  double height;
  double weight;
  double weightGoal;
  List<UserWeightHistory> weightHistory = [];

  UserData(
      {this.name = '',
      this.age = 0,
      this.height = 0.0,
      this.weight = 0.0,
      this.weightGoal = 0.0,
      this.weightHistory = const []});

  setName(String name) {
    assert(name.isNotEmpty, 'Name cannot be empty');
    this.name = name;
  }

  setAge(int age) {
    assert(age >= 0, 'Age cannot be negative');
    this.age = age;
  }

  setHeight(double height) {
    assert(height >= 0, 'Height cannot be negative');
    this.height = height;
  }

  setWeight(double weight) {
    assert(weight >= 0, 'Weight cannot be negative');
    this.weight = weight;
  }

  setWeightGoal(double weightGoal) {
    assert(weightGoal >= 0, 'Weight goal cannot be negative');
    this.weightGoal = weightGoal;
  }

  double getBMI() {
    double bmi = weight / pow(height / 100, 2);
    return double.parse(bmi.toStringAsFixed(2));
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? 0.0,
      weight: json['weight'] ?? 0.0,
      weightGoal: json['weightGoal'] ?? 0.0,
      //   Parse weight history from JSON
      weightHistory: json['weightHistory'] != null
          ? json['weightHistory']
              .map((e) => UserWeightHistory.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    data['height'] = height;
    data['weight'] = weight;
    data['weightGoal'] = weightGoal;
    data['weightHistory'] = weightHistory.map((e) => e.toJson()).toList();
    return data;
  }
}

class UserWeightHistory {
  DateTime date;
  double weight;

  UserWeightHistory({required this.date, required this.weight});

  factory UserWeightHistory.fromJson(Map<String, dynamic> json) {
    return UserWeightHistory(
      date: DateTime.parse(json['date']),
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date.toString();
    data['weight'] = weight;
    return data;
  }
}
