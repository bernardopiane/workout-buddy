import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../settings_page.dart';

class HomeV3 extends StatelessWidget {
  const HomeV3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: ListView(
        children: [
          SizedBox(
            // TODO Make the height dynamic
            height: 550,
            child: Stack(
              children: [
                Positioned(
                  top: 0, //Makes the child stick to its correct size
                  left: 0, //Makes the child stick to its correct size
                  right: 0, //Makes the child stick to its correct size
                  child: Header(),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: defaultPadding,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          children: [
                            Center(child: Text("Card 1")),
                            Center(child: Text("Card 2")),
                            Center(child: Text("Card 3")),
                            Center(child: Text("Card 4")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: defaultPadding,
            child: Column(
              children: [
                Row(
                  children: [
                    // TODO Export workouts button
                    Expanded(
                      child: Card(
                        color: Colors.transparent,
                        // Make card transparent to show gradient
                        elevation: 0,
                        // Optional: remove card shadow if gradient is enough
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: primaryGradient,
                            borderRadius: BorderRadius.circular(
                                12), // Optional: for rounded corners
                          ),
                          child: Padding(
                            padding: defaultPadding,
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
                    Expanded(
                      child: Card(
                        color: Colors.transparent,
                        // Make card transparent to show gradient
                        elevation: 0,
                        // Optional: remove card shadow if gradient is enough
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: secondaryGradient,
                            borderRadius: BorderRadius.circular(
                                12), // Optional: for rounded corners
                          ),
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
                ),
                // TODO Today workouts card
                Card(
                  child: Padding(
                    padding: defaultPadding,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // TODO add dynamic
                            Text("TODAY"),
                            Text(" * "),
                            Text("WED, Jun 1"),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Workout Name"),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Workout stats"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // TODO Upcoming workouts
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // TODO Style text
                        Text("UPCOMING WORKOUTS"),
                        Text("View all")
                      ],
                    ),
                    //   TODO Display the upcoming workouts for the week
                    Card(
                      child: Padding(
                        padding: defaultPadding,
                        child: Column(
                          children: [
                            Text("Day"),
                            Text("Workout Name"),
                            Text("Workout stats"),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: defaultPadding,
                        child: Column(
                          children: [
                            Text("Day"),
                            Text("Workout Name"),
                            Text("Workout stats"),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: defaultPadding,
                        child: Column(
                          children: [
                            Text("Day"),
                            Text("Workout Name"),
                            Text("Workout stats"),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: defaultPadding,
                        child: Column(
                          children: [
                            Text("Day"),
                            Text("Workout Name"),
                            Text("Workout stats"),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: defaultPadding,
                        child: Column(
                          children: [
                            Text("Day"),
                            Text("Workout Name"),
                            Text("Workout stats"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          //   TODO Navigate to the appropriate page based on the selected tab
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                          Text('Today is your day to crush your workouts!',
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ],
                      ),
                      // TODO replace with user avatar
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          onPressed: () {
                            // Navigate to settings page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
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
    );
  }
}
