import 'package:flutter/material.dart';
import 'package:workout_buddy/pages/home/progress_overview.dart';
import 'package:workout_buddy/pages/home/quick_actions.dart';

import '../settings_page.dart';

class HomeV4 extends StatefulWidget {
  const HomeV4({super.key});

  @override
  State<HomeV4> createState() => _HomeV4State();
}

class _HomeV4State extends State<HomeV4> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              //   Navigates to Settings Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            bottomNavigationBar: Container(
              color: Color(0xff1b2127), //TODO Fix color per theme
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.home), text: 'Home'),
                  Tab(
                      icon: Icon(Icons.search),
                      text: 'Exercises'), //TODO Find icon
                  Tab(
                      icon: Icon(Icons.favorite),
                      text: 'Workouts'), //TODO Find icon
                  Tab(
                      icon: Icon(Icons.show_chart),
                      text: 'Progress'), //TODO Find icon
                  Tab(icon: Icon(Icons.person), text: 'Profile'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.white,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                const SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stack(
                      //   alignment: Alignment.center,
                      //   children: <Widget>[
                      //     const Center(
                      //       child: Text(
                      //         "Home",
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //     Align(
                      //       alignment: Alignment.centerRight,
                      //       child: IconButton(
                      //         onPressed: () {
                      //           //   Navigates to Settings Page
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => const SettingsPage(),
                      //             ),
                      //           );
                      //         },
                      //         icon: const Icon(Icons.settings),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 20),
                      Text('Welcome back, USERNAME',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Text('Stats Content'),
                      SizedBox(height: 20),
                      QuickActions(),
                      SizedBox(height: 20),
                      ProgressOverview(),
                    ],
                  ),
                ),
                const Center(child: Text('Exercises Content')),
                const Center(child: Text('Workouts Content')),
                const Center(child: Text('Progress Content')),
                const Center(child: Text('Profile Content')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
