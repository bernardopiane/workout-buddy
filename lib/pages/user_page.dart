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
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserData>(builder: (context, userData, child) {
            if (userData.name.isEmpty) {
              return _buildEmptyState(userData);
            }
            return _buildUserProfile(context, userData);
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState(UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Complete your profile", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        _buildForm(userData),
        const SizedBox(height: 16),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context, UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("User Details", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        UserProfileCard(userData: userData),
        const SizedBox(height: 16),
        _buildUserInfo("Name", userData.name),
        _buildUserInfo("Age", userData.age.toString()),
        _buildUserInfo("Height", "${userData.height} cm"),
        _buildUserInfo("Weight", "${userData.weight} kg"),
        _buildUserInfo("Weight Goal", "${userData.weightGoal} kg"),
        _buildUserInfo("BMI", userData.getBMI().toStringAsFixed(2)),
        const SizedBox(height: 16),
        _buildForm(userData),
        const SizedBox(height: 16),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:"),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Form _buildForm(UserData userData) {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            label: "Name",
            initialValue: userData.name,
            onChanged: (value) {
              if (value.isNotEmpty) {
                userData.setName(value);
              }
            },
          ),
          _buildTextField(
            label: "Age",
            initialValue: userData.age.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              userData.setAge(int.tryParse(value) ?? 0);
            },
          ),
          _buildTextField(
            label: "Height",
            initialValue: userData.height.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              userData.setHeight(double.tryParse(value) ?? 0.0);
            },
          ),
          _buildTextField(
            label: "Weight",
            initialValue: userData.weight.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              userData.setWeight(double.tryParse(value) ?? 0.0);
            },
          ),
          _buildTextField(
            label: "Weight Goal",
            initialValue: userData.weightGoal.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              userData.setWeightGoal(double.tryParse(value) ?? 0.0);
            },
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  ElevatedButton _buildSaveButton() {
    return ElevatedButton(
      child: const Text('Save'),
      onPressed: () {
        // Save user data
      },
    );
  }
}
