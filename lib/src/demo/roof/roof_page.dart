import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoofsPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onEdit;
  final Function() onAdd;

  RoofsPage({required this.onEdit, required this.onAdd});

  @override
  _RoofsPageState createState() => _RoofsPageState();
}

final supabase = Supabase.instance.client;

class _RoofsPageState extends State<RoofsPage> {
  List<dynamic> dachflachen = [];

  @override
  void initState() {
    super.initState();
    fetchRoofSizes();
  }

  void fetchRoofSizes() async {
    try {
      final data = await supabase.from('Dachflächen').select();
      setState(() {
        dachflachen = data;
      });
    } catch (error) {
      print('Fehler beim Abrufen der Daten: $error');
    }
  }

  void deleteRoof(int roofId) async {
    try {
      await supabase.from('Dachflächen').delete().eq('DachID', roofId);
      fetchRoofSizes();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen des Daches: $error')),
      );
      print('Fehler beim Löschen des Daches: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dachflachen.length,
      itemBuilder: (context, index) {
        final roof = dachflachen[index];
        return ListTile(
          title: Text('DachID: ${roof['DachID']}'),
          subtitle: Text('Grösse: ${roof['Grösse']} m²'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await widget.onEdit(roof);
                  fetchRoofSizes();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteRoof(roof['DachID']);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
