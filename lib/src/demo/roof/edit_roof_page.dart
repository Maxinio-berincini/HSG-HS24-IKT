// lib/edit_roof_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditRoofPage extends StatefulWidget {
  final Map<String, dynamic> dachflache;

  EditRoofPage({required this.dachflache});

  @override
  _EditRoofPageState createState() => _EditRoofPageState();
}

final supabase = Supabase.instance.client;

class _EditRoofPageState extends State<EditRoofPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController groesseController;
  late TextEditingController neigungController;
  late TextEditingController ausrichtungController;
  int? selectedOwnerId;
  List<dynamic> owners = [];

  @override
  void initState() {
    super.initState();
    groesseController =
        TextEditingController(text: widget.dachflache['Grösse'].toString());
    neigungController =
        TextEditingController(text: widget.dachflache['Neigung'].toString());
    ausrichtungController =
        TextEditingController(text: widget.dachflache['Ausrichtung']);
    selectedOwnerId = widget.dachflache['EigentümerID'];
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

  void updateRoof() async {
    final groesse = double.tryParse(groesseController.text);
    final neigung = double.tryParse(neigungController.text);
    final ausrichtung = ausrichtungController.text;

    if (selectedOwnerId == null) {
      print('Kein Eigentümer ausgewählt');
      return;
    }

    try {
      await supabase
          .from('Dachflächen')
          .update({
        'Grösse': groesse,
        'Neigung': neigung,
        'Ausrichtung': ausrichtung,
        'EigentümerID': selectedOwnerId,
      })
          .eq('DachID', widget.dachflache['DachID']);
      Navigator.pop(context);
    } catch (error) {
      print('Fehler beim Aktualisieren der Dachfläche: $error');
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
        title: Text('Dachfläche bearbeiten'),
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
              ),
              TextFormField(
                controller: neigungController,
                decoration: InputDecoration(labelText: 'Neigung (°)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: ausrichtungController,
                decoration: InputDecoration(labelText: 'Ausrichtung'),
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateRoof();
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
