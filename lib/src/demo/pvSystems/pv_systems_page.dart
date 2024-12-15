import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PVSystemsPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onEdit;
  final Function() onAdd;

  PVSystemsPage({required this.onEdit, required this.onAdd});

  @override
  _PVSystemsPageState createState() => _PVSystemsPageState();
}

final supabase = Supabase.instance.client;

class _PVSystemsPageState extends State<PVSystemsPage> {
  List<dynamic> pvSystems = [];

  @override
  void initState() {
    super.initState();
    fetchPVSystems();
  }

  void fetchPVSystems() async {
    try {
      final data =
          await supabase.from('PV-Anlagen').select('*, Dachflächen(*)');
      setState(() {
        pvSystems = data;
      });
    } catch (error) {
      print('Fehler beim Abrufen der PV-Anlagen: $error');
    }
  }

  void deletePVSystem(int pvSystemId) async {
    try {
      await supabase.from('PV-Anlagen').delete().eq('AnlagenID', pvSystemId);
      fetchPVSystems();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen der PV-Anlage: $error')),
      );
      print('Fehler beim Löschen der PV-Anlage: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pvSystems.length,
      itemBuilder: (context, index) {
        final pvSystem = pvSystems[index];
        final roof = pvSystem['Dachflächen'];
        return ListTile(
          title: Text('AnlagenID: ${pvSystem['AnlagenID']}'),
          subtitle: Text(
              'DachID: ${roof['DachID']}, Kapazität: ${pvSystem['Kapazität']} kW, Einspeisevergütung: ${pvSystem['Einspeisevergütung']} CHF/kWh'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await widget.onEdit(pvSystem);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deletePVSystem(pvSystem['AnlagenID']);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
