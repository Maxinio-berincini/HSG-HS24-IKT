import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddOwnerPage extends StatefulWidget {
  @override
  _AddOwnerPageState createState() => _AddOwnerPageState();
}

final supabase = Supabase.instance.client;

class _AddOwnerPageState extends State<AddOwnerPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final adresseController = TextEditingController();

  void addOwner() async {
    final name = nameController.text;
    final adresse = adresseController.text;

    try {
      await supabase.from('Eigentümer').insert({
        'Name': name,
        'Adresse': adresse,
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eigentümer erfolgreich hinzugefügt')),
      );
    } catch (error) {
      print('Fehler beim Hinzufügen des Eigentümers: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fehler beim Hinzufügen des Eigentümers: $error')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    adresseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neuen Eigentümer hinzufügen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Name eingeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: adresseController,
                decoration: InputDecoration(labelText: 'Adresse'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addOwner();
                  }
                },
                child: Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
