import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPVSystemPage extends StatefulWidget {
  @override
  _AddPVSystemPageState createState() => _AddPVSystemPageState();
}

final supabase = Supabase.instance.client;

class _AddPVSystemPageState extends State<AddPVSystemPage> {
  final _formKey = GlobalKey<FormState>();
  final kapazitaetController = TextEditingController();
  final ertragController = TextEditingController();

  int? selectedRoofId;
  List<dynamic> roofs = [];

  @override
  void initState() {
    super.initState();
    fetchRoofs();
  }

  void fetchRoofs() async {
    try {
      final roofsData = await supabase.from('Dachflächen').select('DachID');
      setState(() {
        roofs = roofsData;
      });
    } catch (error) {
      print('Fehler beim Abrufen der Dachflächen: $error');
    }
  }

  void addPVSystem() async {
    final kapazitaet = double.tryParse(kapazitaetController.text);
    final ertrag = double.tryParse(ertragController.text);

    if (selectedRoofId == null) {
      print('Bitte eine Dachfläche auswählen');
      return;
    }

    try {
      await supabase.from('PV-Anlagen').insert({
        'DachID': selectedRoofId,
        'Kapazität': kapazitaet,
        'Ertrag': ertrag,
      });
      Navigator.pop(context);
    } catch (error) {
      print('Fehler beim Hinzufügen der PV-Anlage: $error');
    }
  }

  @override
  void dispose() {
    kapazitaetController.dispose();
    ertragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neue PV-Anlage hinzufügen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: roofs.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Dachfläche'),
                value: selectedRoofId,
                items: roofs.map<DropdownMenuItem<int>>((roof) {
                  return DropdownMenuItem<int>(
                    value: roof['DachID'],
                    child: Text('DachID: ${roof['DachID']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRoofId = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Bitte eine Dachfläche auswählen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: kapazitaetController,
                decoration: InputDecoration(labelText: 'Kapazität (kW)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Kapazität eingeben';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ertragController,
                decoration: InputDecoration(labelText: 'Ertrag (kWh)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addPVSystem();
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
