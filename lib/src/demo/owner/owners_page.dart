import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'add_owner_page.dart';
import 'edit_owner_page.dart';

class OwnersPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onEdit;
  final Function() onAdd;

  OwnersPage({required this.onEdit, required this.onAdd});
  @override
  _OwnersPageState createState() => _OwnersPageState();
}

final supabase = Supabase.instance.client;

class _OwnersPageState extends State<OwnersPage> {
  List<dynamic> owners = [];

  @override
  void initState() {
    super.initState();
    fetchOwners();
  }

  void fetchOwners() async {
    try {
      final data = await supabase.from('Eigentümer').select();
      setState(() {
        owners = data;
      });
    } catch (error) {
      print('Fehler beim Abrufen der Eigentümer: $error');
    }
  }

  void deleteOwner(int ownerId) async {
    try {
      await supabase.from('Eigentümer').delete().eq('EigentümerID', ownerId);
      fetchOwners();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen des Eigentümers: $error')),
      );
      print('Fehler beim Löschen des Eigentümers: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: owners.length,
        itemBuilder: (context, index) {
          final owner = owners[index];
          return ListTile(
            title: Text(owner['Name']),
            subtitle: Text(owner['Adresse'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await widget.onEdit(owner);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteOwner(owner['EigentümerID']);
                  },
                ),
              ],
            ),
          );
        },
      );
  }
}
