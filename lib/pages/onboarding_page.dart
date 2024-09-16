import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_buddy/model/user_data.dart';

import 'home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;
  int lastStep = 4;

  bool _metricSystem = false;
  // TODO modify so that the metric is saved per user and not global

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //   Load metric system from Shared Preferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _metricSystem = prefs.getBool('metricSystem') ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement widget
    // User provides their name, age, height, weight, and weight goal on first boot of the app
    return Scaffold(
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < lastStep) {
            if (_currentStep == 1) {
              debugPrint("Step is 1");
              // If current step is 1, save user data when form is valid
              if (_formKey.currentState!.validate()) {
                debugPrint("Form is valid");
                _formKey.currentState!.save();
                Provider.of<UserData>(context, listen: false).saveUserData();
                setState(() {
                  _currentStep++;
                });
              } else {
                debugPrint("Form is invalid");
              }
            } else {
              setState(() {
                _currentStep++;
              });
            }
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        steps: [
          Step(
              title: const Text('Step 0'),
              content: Consumer<UserData>(builder: (context, userData, child) {
                return Column(
                  children: [
                    const Text(
                        'Select if should use Metric(Kg, Lbs, cm, in) or Imperial(ft, mi, m, yd) system'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //   Radio Selection for metric system
                        Radio(
                          value: true,
                          groupValue: _metricSystem,
                          onChanged: (value) {
                            setState(() {
                              _metricSystem = true;
                            });
                            //   Save using Shared Preferences
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setBool('metricSystem', _metricSystem);
                            });
                            userData.setUseMetric(_metricSystem);
                            debugPrint("Metric system set to true");
                          },
                        ),
                        const Text('Metric'),
                        const SizedBox(width: 32.0),
                        //   Radio Selection for imperial system
                        Radio(
                          value: false,
                          groupValue: _metricSystem,
                          onChanged: (value) {
                            setState(() {
                              _metricSystem = false;
                            });
                            //   Save using Shared Preferences
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setBool('metricSystem', _metricSystem);
                            });
                            userData.setUseMetric(_metricSystem);
                            debugPrint("Metric system set to false");
                          },
                        ),
                        const Text('Imperial'),
                      ],
                    ),
                  ],
                );
              })),
          Step(
            title: const Text('Step 1'),
            content: SingleChildScrollView(
              child: Column(children: [
                const Text('Enter your personal information'),
                const SizedBox(height: 16),
                Consumer<UserData>(builder: (context, userData, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          initialValue: "",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData.setName(value!);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Age'),
                          initialValue: "",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData.setAge(int.tryParse(value!)!);
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Height'),
                          initialValue: "",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // TODO Fix not handling imperial system ( 5'8")
                            userData.setHeight(double.tryParse(value!)!);
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Weight'),
                          initialValue: "",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData.setWeight(double.tryParse(value!)!);
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Weight Goal'),
                          initialValue: "",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight goal';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userData.setWeightGoal(double.tryParse(value!)!);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ]),
            ),
          ),
          const Step(
            title: Text('Step 2'),
            content: Text('Select your workout goals'),
          ),
          const Step(
            title: Text('Step 3'),
            content: Text('Choose your workout routines'),
          ),
          const Step(
            title: Text('Step 4'),
            content: Text('Start your workouts'),
          ),
        ],
      ),
    );
  }
}
