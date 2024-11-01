import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/settings.dart';
import 'package:workout_buddy/widgets/user_profile_card.dart';
import '../model/user_data.dart';
import '../utils.dart';
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
          child: Consumer<Settings>(
            builder: (context, settings, child) {
              return _buildUserInfo(
                "Height",
                "${userData.height} ${settings.useMetric ? "cm" : "in"}",
              );
            },
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
          child: Consumer<Settings>(
            builder: (context, settings, child) {
              return _buildUserInfo(
                "Weight",
                "${userData.weight} ${settings.useMetric ? "kg" : "lbs"}",
              );
            },
          ),
        ),
        GestureDetector(onTap: () {
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
        }, child: Consumer<Settings>(
          builder: (context, settings, child) {
            return _buildUserInfo(
              "Weight Goal",
              "${userData.weightGoal} ${settings.useMetric ? "kg" : "lbs"}",
            );
          },
        )),
        SizedBox(
          height: 320,
          width: MediaQuery.of(context).size.width,
          child: Consumer<UserData>(builder: (context, userData, child) {
            //   Display the graph using a LineChart for the user's weight history
            return LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _getWeightSpots(userData),
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.3)),
                    dotData: FlDotData(show: true),
                    barWidth: 4,
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      "Date",
                      style: const TextStyle(fontSize: 12),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, size) {
                        List<String> days = [];
                        for (int i = 0;
                            i < userData.weightHistory.length;
                            i++) {
                          String day =
                              '${userData.weightHistory[i].date.day}/${userData.weightHistory[i].date.month}';
                          days.add(day);
                        }

                        return Text(
                          days[value.toInt()].toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
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

  _getWeightSpots(UserData userData) {
    // Create the spots for the graph using the weight history
    if (userData.weightHistory.isEmpty) {
      return [];
    }

    final List<FlSpot> spots = [];
    for (int i = 0; i < userData.weightHistory.length; i++) {
      // TODO fix date formatting
      FlSpot spot = FlSpot(i.toDouble(), userData.weightHistory[i].weight);
      spots.add(spot);
    }
    debugPrint("Spots: ${spots.toString()}");
    return spots;
  }
}
