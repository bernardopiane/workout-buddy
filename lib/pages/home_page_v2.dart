import 'package:flutter/material.dart';
import 'package:workout_buddy/global.dart';

class HomePageV2 extends StatelessWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTodayCard(context),
            _buildSchedule(context),
          ],
        ),
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return Row(
      children: [
        // TODO Circle avatar
        Placeholder(
          fallbackHeight: 100,
          fallbackWidth: 100,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO fetch user info
            Text("Welcome back, User!",
                style: Theme.of(context).textTheme.headlineLarge),
            Text("Your workout progress",
                style: Theme.of(context).textTheme.headlineSmall),
          ],
        )
      ],
    );
  }

  _buildTodayCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "lib/assets/images/Dumbbell.png",
                  // TODO Adjust sizes
                  height: 48,
                  width: 48,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // TODO Set text color
                    Text("Today's Gym Session",
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text("9.98 Km",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration"),
                    Text("Approx. 3h 30min"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Calories burned"),
                    Text("1,000"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Workout type"),
                    Text("Weight lifting"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildSchedule(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your schedule for:",
                style: Theme.of(context).textTheme.headlineLarge),
            _buildDayPicker(),
          ],
        )
      ],
    );
  }

  // TODO Extract into a new file/widget
  _buildDayPicker() {
    String? selectedDay;

    return DropdownMenu<String>(
      initialSelection: "Today",
      onSelected: (String? day) {
        selectedDay = day;
      },
      dropdownMenuEntries:
          daysOfWeek.map<DropdownMenuEntry<String>>((String day) {
        return DropdownMenuEntry<String>(value: day, label: day);
      }).toList(),
    );
  }
}
