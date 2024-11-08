import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Consumer<Settings>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              const SizedBox(height: 16),
              _buildSection(
                title: "Appearance",
                children: [
                  _buildSettingsTile(
                    title: "Dark Theme",
                    subtitle: "Use darker colors for the app interface",
                    trailing: Switch.adaptive(
                      value: settings.useDarkTheme,
                      onChanged: (value) {
                        settings.useDarkTheme = value;
                        settings.saveSettings();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: "Units",
                children: [
                  _buildSettingsTile(
                    title: "Metric System",
                    subtitle: "Use kilograms(kg) instead of pounds(lbs)",
                    trailing: Switch.adaptive(
                      value: settings.useMetric,
                      onChanged: (value) {
                        settings.useMetric = value;
                        settings.saveSettings();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: "Connectivity",
                children: [
                  _buildSettingsTile(
                    title: "Online Mode",
                    subtitle: "Enable online features and sync",
                    trailing: Switch.adaptive(
                      value: settings.useOnline,
                      onChanged: (value) {
                        settings.useOnline = value;
                        settings.saveSettings();
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: trailing,
    );
  }
}
