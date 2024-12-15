import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContractsPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onEdit;
  final Function() onAdd;

  ContractsPage({required this.onEdit, required this.onAdd});

  @override
  _ContractsPageState createState() => _ContractsPageState();
}

final supabase = Supabase.instance.client;

class _ContractsPageState extends State<ContractsPage> {
  List<dynamic> contracts = [];

  @override
  void initState() {
    super.initState();
    fetchContracts();
  }

  void fetchContracts() async {
    try {
      final data = await supabase
          .from('Verträge')
          .select('*, Dachflächen(*), Eigentümer(*)');
      setState(() {
        contracts = data;
      });
    } catch (error) {
      print('Fehler beim Abrufen der Verträge: $error');
    }
  }

  void deleteContract(int contractId) async {
    try {
      await supabase.from('Verträge').delete().eq('VertragsID', contractId);
      fetchContracts();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen des Vertrags: $error')),
      );
      print('Fehler beim Löschen des Vertrags: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];
        final owner = contract['Eigentümer'];
        final roof = contract['Dachflächen'];
        return ListTile(
          title: Text('VertragsID: ${contract['VertragsID']}'),
          subtitle: Text(
              'Eigentümer: ${owner['Name']}, DachID: ${roof['DachID']}, Mietpreis/Q: ${contract['Mietpreis_Pro_Quartal']} CHF'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await widget.onEdit(contract);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteContract(contract['VertragsID']);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
