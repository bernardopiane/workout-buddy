import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Settings"),
            Consumer<Settings>(
              builder: (context, settings, child) {
                return Column(
                  children: [
                    const Text("Use Dark Theme"),
                    Switch(
                      value: settings.useDarkTheme,
                      onChanged: (value) {
                        settings.useDarkTheme = value;
                        settings.saveSettings();
                      },
                    ),
                    const Text("Use Metric"),
                    Switch(
                      value: settings.useMetric,
                      onChanged: (value) {
                        settings.useMetric = value;
                        settings.saveSettings();
                      },
                    ),
                    const Text("Use Online"),
                    Switch(
                      value: settings.useOnline,
                      onChanged: (value) {
                        settings.useOnline = value;
                        settings.saveSettings();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
