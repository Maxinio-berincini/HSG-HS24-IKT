import 'package:flutter/material.dart';
import 'home_page.dart';

class AppDrawer extends StatelessWidget {
  final MenuOption selectedOption;
  final Function(MenuOption) onSelectOption;

  AppDrawer({required this.selectedOption, required this.onSelectOption});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Statistiken'),
            selected: selectedOption == MenuOption.Statistics,
            onTap: () {
              onSelectOption(MenuOption.Statistics);
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dachflächen'),
            selected: selectedOption == MenuOption.Roofs,
            onTap: () {
              onSelectOption(MenuOption.Roofs);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Eigentümer'),
            selected: selectedOption == MenuOption.Owners,
            onTap: () {
              onSelectOption(MenuOption.Owners);
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Verträge'),
            selected: selectedOption == MenuOption.Contracts,
            onTap: () {
              onSelectOption(MenuOption.Contracts);
            },
          ),
          ListTile(
            leading: Icon(Icons.bolt),
            title: Text('PV-Anlagen'),
            selected: selectedOption == MenuOption.PVSystems,
            onTap: () {
              onSelectOption(MenuOption.PVSystems);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Einstellungen'),
            selected: selectedOption == MenuOption.Settings,
            onTap: () {
              onSelectOption(MenuOption.Settings);
            },
          ),
        ],
      ),
    );
  }
}
