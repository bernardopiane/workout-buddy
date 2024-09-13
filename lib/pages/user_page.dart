import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/widgets/user_profile_card.dart';
import '../model/user_data.dart';
import 'onboarding_page.dart';

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
              return _buildEmptyState(context, userData);
            }
            return _buildUserProfile(context, userData);
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Complete your profile", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            //   Navigates to the Onboarding page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingPage(),
              ),
            );
          },
          child: const Text('Click me'),
        ),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context, UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("User Details", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        UserProfileCard(userData: userData),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            _displayEditDialog<String>(
                context: context,
                title: 'Name',
                currentValue: userData.name,
                onSave: (newValue) {
                  userData.setName(newValue);
                  userData.saveUserData();
                });
          },
          child: _buildUserInfo("Name", userData.name),
        ),
        GestureDetector(
          onTap: () {
            _displayEditDialog<int>(
              context: context,
              title: 'Age',
              currentValue: userData.age,
              onSave: (newValue) {
                userData.setAge(newValue);
                userData.saveUserData();
              },
              keyboardType: TextInputType.number,
            );
          },
          child: _buildUserInfo("Age", userData.age.toString()),
        ),
        GestureDetector(
          onTap: () {
            _displayEditDialog<double>(
              context: context,
              title: 'Height',
              currentValue: userData.height,
              onSave: (newValue) {
                userData.setHeight(newValue);
                userData.saveUserData();
              },
              keyboardType: TextInputType.number,
            );
          },
          child: _buildUserInfo(
            "Height",
            "${userData.height} ${userData.userSettings.useMetric ? "cm" : "in"}",
          ),
        ),
        GestureDetector(
          onTap: () {
            _displayEditDialog<double>(
              context: context,
              title: 'Weight',
              currentValue: userData.weight,
              onSave: (newValue) {
                userData.updateWeight(newValue);
                userData.saveUserData();
              },
              keyboardType: TextInputType.number,
            );
          },
          child: _buildUserInfo(
            "Weight",
            "${userData.weight} ${userData.userSettings.useMetric ? "kg" : "lbs"}",
          ),
        ),
        GestureDetector(
          onTap: () {
            _displayEditDialog<double>(
              context: context,
              title: 'Weight Goal',
              currentValue: userData.weightGoal,
              onSave: (newValue) {
                userData.setWeightGoal(newValue);
                userData.saveUserData();
              },
              keyboardType: TextInputType.number,
            );
          },
          child: _buildUserInfo(
            "Weight Goal",
            "${userData.weightGoal} ${userData.userSettings.useMetric ? "kg" : "lbs"}",
          ),
        ),
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

  Future<void> _displayEditDialog<T>({
    required BuildContext context,
    required String title,
    required T currentValue,
    required ValueChanged<T> onSave,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    var formKey = GlobalKey<FormState>();
    var textController = TextEditingController(text: currentValue.toString());

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              keyboardType: keyboardType,
              decoration: InputDecoration(labelText: title),
              validator: validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your $title';
                    }
                    return null;
                  },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (T == String) {
                    onSave(textController.text as T);
                  } else if (T == int) {
                    onSave(int.parse(textController.text) as T);
                  } else if (T == double) {
                    onSave(double.parse(textController.text) as T);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
