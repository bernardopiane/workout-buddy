import 'package:flutter/material.dart';

import '../model/user_data.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, required this.userData});
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              child: Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 100,
                child: Text("User Image"),
              ),
            ),
            Text(userData.name),
          ],
        ),
      ),
    );
  }
}
