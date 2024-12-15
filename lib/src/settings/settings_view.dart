import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);
  final SettingsController controller;

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

final supabase = Supabase.instance.client;

class _SettingsViewState extends State<SettingsView> {
  bool isResetting = false;

  Future<void> resetDatabase() async {
    setState(() {
      isResetting = true;
    });

    try {
      await supabase.rpc('reset_database');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datenbank erfolgreich zurückgesetzt')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fehler beim Zurücksetzen der Datenbank: $error')),
      );
    } finally {
      setState(() {
        isResetting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Theme-Auswahl
          ListTile(
            title: Text('App-Theme'),
            trailing: DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: widget.controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: widget.controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Reset-Button
          ElevatedButton(
            onPressed: isResetting ? null : resetDatabase,
            child: isResetting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Datenbank zurücksetzen'),
          ),
        ],
      ),
    );
  }
}
