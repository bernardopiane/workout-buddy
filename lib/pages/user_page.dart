import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/widgets/user_profile_card.dart';

import '../model/user_data.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<UserData>(builder: (context, userData, child) {
            //     If userData is null or empty, return a placeholder
            if (userData.name.isEmpty) {
              return Column(
                children: [
                  _buildForm(userData),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      Provider.of<UserData>(context, listen: false)
                          .saveUserData();
                    },
                  ),
                ],
              );
            }
            return Column(
              children: [
                const Text("User Page"),
                UserProfileCard(userData: userData),
                Text("Name: ${userData.name}"),
                Text("Age: ${userData.age}"),
                Text("Height: ${userData.height} cm"),
                Text("Weight: ${userData.weight} kg"),
                Text("Weight Goal: ${userData.weightGoal} kg"),
                Text("BMI: ${userData.getBMI().toString()}"),
                _buildForm(userData),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Provider.of<UserData>(context, listen: false)
                        .saveUserData();
                  },
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Form _buildForm(UserData userData) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Name",
            ),
            initialValue: userData.name,
            onChanged: (value) {
              if (value.isNotEmpty) {
                userData.setName(value);
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Age",
            ),
            initialValue: userData.age.toString(),
            onChanged: (value) {
              // If empty, set to 0
              if (value.isEmpty) {
                userData.setAge(0);
                return;
              }
              userData.setAge(int.parse(value));
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Height",
            ),
            initialValue: userData.height.toString(),
            onChanged: (value) {
              // If empty, set to 0
              if (value.isEmpty) {
                userData.setHeight(0);
                return;
              }
              userData.setHeight(double.parse(value));
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
            initialValue: userData.weight.toString(),
            onChanged: (value) {
              // If empty, set to 0
              if (value.isEmpty) {
                userData.setWeight(0);
                return;
              }
              userData.setWeight(double.parse(value));
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Weight Goal",
            ),
            initialValue: userData.weightGoal.toString(),
            onChanged: (value) {
              // If empty, set to 0
              if (value.isEmpty) {
                userData.setWeightGoal(0);
                return;
              }
              userData.setWeightGoal(double.parse(value));
            },
          ),
        ],
      ),
    );
  }
}
