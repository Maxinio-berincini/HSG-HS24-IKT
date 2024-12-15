import 'package:flutter/material.dart';
import 'package:solardach_demo/src/demo/pvSystems/add_pv_systems.dart';
import 'package:solardach_demo/src/demo/pvSystems/edit_pv_systems_page.dart';
import 'package:solardach_demo/src/demo/pvSystems/pv_systems_page.dart';
import 'package:solardach_demo/src/demo/roof/add_roof_page.dart';
import 'package:solardach_demo/src/demo/roof/edit_roof_page.dart';
import 'package:solardach_demo/src/demo/roof/roof_page.dart';
import 'package:solardach_demo/src/settings/settings_view.dart';

import 'analysis/analysis_page.dart';
import 'app_drawer.dart';
import 'contract/add_contract_page.dart';
import 'contract/contracts_page.dart';
import 'contract/edit_contract_page.dart';
import 'owner/add_owner_page.dart';
import 'owner/edit_owner_page.dart';
import 'owner/owners_page.dart';

class HomePage extends StatefulWidget {
  final dynamic controller;

  const HomePage({super.key, required this.controller});

  @override
  _HomePageState createState() => _HomePageState();
}

enum MenuOption { Statistics, Roofs, Owners, Contracts, PVSystems, Settings }

class _HomePageState extends State<HomePage> {
  MenuOption _selectedOption = MenuOption.Statistics;

  @override
  Widget build(BuildContext context) {
    Widget content;
    String title = 'Solardachinitiative St. Gallen';
    FloatingActionButton? fab;

    switch (_selectedOption) {
      case MenuOption.Statistics:
        content = AnalysisPage();
        title = 'Unternehmensstatistiken';
        fab = null; // Kein FAB auf der Statistikseite
        break;
      case MenuOption.Roofs:
        content = RoofsPage(
          onEdit: _pushEditRoofPage,
          onAdd: _pushAddRoofPage,
        );
        title = 'Dachflächen Übersicht';
        fab = FloatingActionButton(
          heroTag: 'roofs_fab',
          onPressed: () async {
            await _pushAddRoofPage();
            setState(() {});
          },
          child: const Icon(Icons.add),
        );
        break;
      case MenuOption.Owners:
        content = OwnersPage(
          onEdit: _pushEditOwnerPage,
          onAdd: _pushAddOwnerPage,
        );
        title = 'Eigentümerverwaltung';
        fab = FloatingActionButton(
          heroTag: 'owners_fab',
          onPressed: () async {
            await _pushAddOwnerPage();
            setState(() {});
          },
          child: const Icon(Icons.add),
        );
        break;
      case MenuOption.Contracts:
        content = ContractsPage(
          onEdit: _pushEditContractPage,
          onAdd: _pushAddContractPage,
        );
        title = 'Vertragsverwaltung';
        fab = FloatingActionButton(
          heroTag: 'contracts_fab',
          onPressed: () async {
            await _pushAddContractPage();
            setState(() {});
          },
          child: const Icon(Icons.add),
        );
        break;
      case MenuOption.PVSystems:
        content = PVSystemsPage(
          onEdit: _pushEditPVSystemPage,
          onAdd: _pushAddPVSystemPage,
        );
        title = 'PV-Anlagenverwaltung';
        fab = FloatingActionButton(
          heroTag: 'pv_systems_fab',
          onPressed: () async {
            await _pushAddPVSystemPage();
            setState(() {});
          },
          child: const Icon(Icons.add),
        );
        break;
      case MenuOption.Settings:
        content = SettingsView(controller: widget.controller);
        title = 'Einstellungen';
        fab = null;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: AppDrawer(
        selectedOption: _selectedOption,
        onSelectOption: (option) {
          setState(() {
            _selectedOption = option;
          });
          Navigator.pop(context); // Schliesst den Drawer
        },
      ),
      body: content,
      floatingActionButton: fab,
    );
  }

  // Navigationsmethoden für Dachflächen
  Future<void> _pushEditRoofPage(Map<String, dynamic> roof) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditRoofPage(dachflache: roof),
      ),
    );
  }

  Future<void> _pushAddRoofPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddRoofPage()),
    );
  }

  // Navigationsmethoden für Eigentümer
  Future<void> _pushEditOwnerPage(Map<String, dynamic> owner) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditOwnerPage(owner: owner),
      ),
    );
  }

  Future<void> _pushAddOwnerPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddOwnerPage()),
    );
  }

  // Navigationsmethoden für Verträge
  Future<void> _pushEditContractPage(Map<String, dynamic> contract) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditContractPage(contract: contract),
      ),
    );
  }

  Future<void> _pushAddContractPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddContractPage()),
    );
  }

  // Navigationsmethoden für PV-Anlagen
  Future<void> _pushEditPVSystemPage(Map<String, dynamic> pvSystem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPVSystemPage(pvSystem: pvSystem),
      ),
    );
  }

  Future<void> _pushAddPVSystemPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPVSystemPage()),
    );
  }
}
