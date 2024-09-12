import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/model/user_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();

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
          setState(() {
            _currentStep++;
          });
        },
        onStepCancel: () {
          setState(() {
            _currentStep = 0;
          });
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        steps: [
          const Step(
            title: Text('Step 0'),
            content: Text('Select if should use Kg or Lbs, cm or in, offline or online'),
          //   TODO implement initial settings for user
          ),
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

                        //   Confirmation Button
                        ElevatedButton(
                          child: const Text('Confirm'),
                          onPressed: () {
                            // Save user data
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              //   Navigate to Home Page
                              // TODO: implement navigation
                            }
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
