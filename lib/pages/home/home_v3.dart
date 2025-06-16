import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_buddy/providers/workout_plan_manager.dart';

import '../settings_page.dart';

const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft, // Corresponds to 135deg
  end: Alignment.bottomRight, // Corresponds to 135deg
  colors: [
    Color(0xFF667EEA), // #667eea
    Color(0xFF764BA2), // #764ba2
  ],
);

const LinearGradient secondaryGradient = LinearGradient(
  begin: Alignment.topLeft, // Corresponds to 135deg
  end: Alignment.bottomRight, // Corresponds to 135deg
  colors: [
    Color(0xFFF093FB), // #f093fb
    Color(0xFFF5576C), // #f5576c
  ],
);

class HomeV3 extends StatelessWidget {
  const HomeV3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0, //Makes the child stick to its correct size
            left: 0, //Makes the child stick to its correct size
            right: 0, //Makes the child stick to its correct size
            child: SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(gradient: primaryGradient),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome back, John!',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                  Text(
                                      'Today is your day to crush your workouts!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                ],
                              ),
                              // TODO replace with user avatar
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: IconButton(
                                  onPressed: () {
                                    // Navigate to settings page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.settings),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 12,
            right: 12,
            bottom: 0,
            child: ListView(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView(
                    shrinkWrap: true,
                    // Important to prevent unbounded height
                    physics: NeverScrollableScrollPhysics(),
                    // Disable GridView's own scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    children: [
                      Center(child: Text("Card 1")),
                      Center(child: Text("Card 2")),
                      Center(child: Text("Card 3")),
                      Center(child: Text("Card 4")),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // TODO Export workouts button
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: primaryGradient,
                          borderRadius: BorderRadius.circular(
                              12), // Optional: for rounded corners
                        ),
                        child: Card(
                          color: Colors.transparent,
                          // Make card transparent to show gradient
                          elevation: 0,
                          // Optional: remove card shadow if gradient is enough
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Placeholder(
                                  fallbackHeight: 50,
                                  fallbackWidth: 50,
                                ),
                                Text("Start Workout",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: secondaryGradient,
                          borderRadius: BorderRadius.circular(
                              12), // Optional: for rounded corners
                        ),
                        child: Card(
                          color: Colors.transparent,
                          // Make card transparent to show gradient
                          elevation: 0,
                          // Optional: remove card shadow if gradient is enough
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Placeholder(
                                  fallbackHeight: 50,
                                  fallbackWidth: 50,
                                ),
                                Text("View Progress",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                // TODO Today workouts card
                // TODO Upcoming workouts
                // TODO bottom nav bar
              ],
            ),
          ),
        ],
      ),
    );
  }
}
