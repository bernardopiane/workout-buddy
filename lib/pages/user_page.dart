import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:workout_buddy/pages/settings_page.dart';
import '../model/settings.dart';
import '../model/user_data.dart';
import '../widgets/user_profile_card.dart';
import 'onboarding_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh user data
            await context.read<UserData>().loadUserData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Consumer<UserData>(
              builder: (context, userData, child) {
                return userData.name.isEmpty
                    ? _buildEmptyState(context, userData)
                    : _buildUserProfile(context, userData);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, UserData userData) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 64),
          const SizedBox(height: 16),
          Text(
            "Complete your profile",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            "Add your personal information to track your fitness journey",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserProfileCard(userData: userData),
        const SizedBox(height: 24),
        _buildSection(
          title: "Personal Information",
          children: [
            _buildEditableField(
              context: context,
              label: "Name",
              value: userData.name,
              icon: Icons.person,
              onEdit: () => _displayEditDialog<String>(
                context: context,
                title: 'Name',
                currentValue: userData.name,
                onSave: (newValue) {
                  userData.setName(newValue);
                  userData.saveUserData();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
            ),
            _buildEditableField(
              context: context,
              label: "Age",
              value: "${userData.age} years",
              icon: Icons.cake,
              onEdit: () => _displayEditDialog<int>(
                context: context,
                title: 'Age',
                currentValue: userData.age,
                onSave: (newValue) {
                  userData.setAge(newValue);
                  userData.saveUserData();
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 0 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSection(
          title: "Measurements",
          children: [
            Consumer<Settings>(
              builder: (context, settings, child) {
                return Column(
                  children: [
                    _buildEditableField(
                      context: context,
                      label: "Height",
                      value: "${userData.height} ${settings.useMetric ? "cm" : "in"}",
                      icon: Icons.height,
                      onEdit: () => _displayEditDialog<double>(
                        context: context,
                        title: 'Height',
                        currentValue: userData.height,
                        onSave: (newValue) {
                          userData.setHeight(newValue);
                          userData.saveUserData();
                        },
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => _validateMeasurement(value, 'height', settings.useMetric),
                      ),
                    ),
                    _buildEditableField(
                      context: context,
                      label: "Current Weight",
                      value: "${userData.weight} ${settings.useMetric ? "kg" : "lbs"}",
                      icon: Icons.monitor_weight,
                      onEdit: () => _displayEditDialog<double>(
                        context: context,
                        title: 'Weight',
                        currentValue: userData.weight,
                        onSave: (newValue) {
                          userData.updateWeight(newValue);
                          userData.saveUserData();
                        },
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => _validateMeasurement(value, 'weight', settings.useMetric),
                      ),
                    ),
                    _buildEditableField(
                      context: context,
                      label: "Target Weight",
                      value: "${userData.weightGoal} ${settings.useMetric ? "kg" : "lbs"}",
                      icon: Icons.flag,
                      onEdit: () => _displayEditDialog<double>(
                        context: context,
                        title: 'Weight Goal',
                        currentValue: userData.weightGoal,
                        onSave: (newValue) {
                          userData.setWeightGoal(newValue);
                          userData.saveUserData();
                        },
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => _validateMeasurement(value, 'weight goal', settings.useMetric),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildWeightHistoryChart(context, userData),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onEdit,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ),
    );
  }

  Widget _buildWeightHistoryChart(BuildContext context, UserData userData) {
    if (userData.weightHistory.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              "No weight history available yet.\nStart tracking your weight to see progress!",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weight History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text("Date"),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= userData.weightHistory.length) {
                            return const Text('');
                          }
                          return Text(
                            DateFormat('MM/dd').format(
                              userData.weightHistory[value.toInt()].date,
                            ),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Consumer<Settings>(
                        builder: (context, settings, child) {
                          return Text(
                            settings.useMetric ? "Weight (kg)" : "Weight (lbs)",
                          );
                        },
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getWeightSpots(userData),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final date = userData.weightHistory[spot.x.toInt()].date;
                          return LineTooltipItem(
                            '${DateFormat('MM/dd/yyyy').format(date)}\n${spot.y.toStringAsFixed(1)} ${context.read<Settings>().useMetric ? "kg" : "lbs"}',
                            const TextStyle(color: Colors.black),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateMeasurement(String? value, String field, bool isMetric) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $field';
    }

    final measurement = double.tryParse(value);
    if (measurement == null) {
      return 'Please enter a valid number';
    }

    if (field == 'height') {
      if (isMetric && (measurement < 50 || measurement > 250)) {
        return 'Please enter a valid height (50-250 cm)';
      } else if (!isMetric && (measurement < 20 || measurement > 98)) {
        return 'Please enter a valid height (20-98 in)';
      }
    } else if (field.contains('weight')) {
      if (isMetric && (measurement < 20 || measurement > 300)) {
        return 'Please enter a valid weight (20-300 kg)';
      } else if (!isMetric && (measurement < 44 || measurement > 660)) {
        return 'Please enter a valid weight (44-660 lbs)';
      }
    }
    return null;
  }

  List<FlSpot> _getWeightSpots(UserData userData) {
    return List.generate(
      userData.weightHistory.length,
          (index) => FlSpot(
        index.toDouble(),
        userData.weightHistory[index].weight,
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
    final formKey = GlobalKey<FormState>();
    final textController = TextEditingController(text: currentValue.toString());

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
              decoration: InputDecoration(
                labelText: title,
                border: const OutlineInputBorder(),
              ),
              validator: validator,
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  try {
                    if (T == String) {
                      onSave(textController.text as T);
                    } else if (T == int) {
                      onSave(int.parse(textController.text) as T);
                    } else if (T == double) {
                      onSave(double.parse(textController.text) as T);
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid input format'),
                      ),
                    );
                  }
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