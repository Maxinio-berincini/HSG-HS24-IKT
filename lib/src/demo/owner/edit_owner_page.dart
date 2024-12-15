import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditOwnerPage extends StatefulWidget {
  final Map<String, dynamic> owner;

  EditOwnerPage({required this.owner});

  @override
  _EditOwnerPageState createState() => _EditOwnerPageState();
}

final supabase = Supabase.instance.client;

class _EditOwnerPageState extends State<EditOwnerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController adresseController;

  void updateOwner() async {
    final name = nameController.text;
    final adresse = adresseController.text;

    try {
      await supabase.from('Eigentümer').update({
        'Name': name,
        'Adresse': adresse,
      }).eq('EigentümerID', widget.owner['EigentümerID']);
      Navigator.pop(context);
    } catch (error) {
      print('Fehler beim Aktualisieren des Eigentümers: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.owner['Name']);
    adresseController =
        TextEditingController(text: widget.owner['Adresse'] ?? '');
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
        title: Text('Eigentümer bearbeiten'),
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
                    updateOwner();
                  }
                },
                child: Text('Aktualisieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
