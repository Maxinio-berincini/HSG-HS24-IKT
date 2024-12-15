import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRoofPage extends StatefulWidget {
  @override
  _AddRoofPageState createState() => _AddRoofPageState();
}

final supabase = Supabase.instance.client;

class _AddRoofPageState extends State<AddRoofPage> {
  final _formKey = GlobalKey<FormState>();
  final groesseController = TextEditingController();
  final neigungController = TextEditingController();
  final ausrichtungController = TextEditingController();
  int? selectedOwnerId;
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

  void addRoof() async {
    final groesse = double.tryParse(groesseController.text);
    final neigung = double.tryParse(neigungController.text);
    final ausrichtung = ausrichtungController.text;

    if (selectedOwnerId == null) {
      print('Kein Eigentümer ausgewählt');
      return;
    }

    try {
      await supabase.from('Dachflächen').insert({
        'Grösse': groesse,
        'Neigung': neigung,
        'Ausrichtung': ausrichtung,
        'EigentümerID': selectedOwnerId,
      });
      Navigator.pop(context);
    } catch (error) {
      print('Fehler beim Hinzufügen der Dachfläche: $error');
    }
  }

  @override
  void dispose() {
    groesseController.dispose();
    neigungController.dispose();
    ausrichtungController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue Dachfläche hinzufügen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: owners.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: groesseController,
                      decoration: InputDecoration(labelText: 'Grösse (m²)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte Grösse eingeben';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: neigungController,
                      decoration: InputDecoration(labelText: 'Neigung (°)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte Neigung eingeben';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: ausrichtungController,
                      decoration: InputDecoration(labelText: 'Ausrichtung'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte Ausrichtung eingeben';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Eigentümer'),
                      value: selectedOwnerId,
                      items: owners.map<DropdownMenuItem<int>>((owner) {
                        return DropdownMenuItem<int>(
                          value: owner['EigentümerID'],
                          child: Text(owner['Name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOwnerId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Bitte einen Eigentümer auswählen';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addRoof();
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
