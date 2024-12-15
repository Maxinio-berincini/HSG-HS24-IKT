import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddContractPage extends StatefulWidget {
  @override
  _AddContractPageState createState() => _AddContractPageState();
}

final supabase = Supabase.instance.client;

class _AddContractPageState extends State<AddContractPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  final laufzeitController = TextEditingController();
  final strompreisController = TextEditingController();
  final mietpreisController = TextEditingController();

  int? selectedRoofId;
  int? selectedOwnerId;
  List<dynamic> roofs = [];
  List<dynamic> owners = [];

  @override
  void initState() {
    super.initState();
    fetchRoofsAndOwners();
  }

  void fetchRoofsAndOwners() async {
    try {
      final roofsData = await supabase.from('Dachflächen').select('DachID');
      final ownersData =
          await supabase.from('Eigentümer').select('EigentümerID, Name');
      setState(() {
        roofs = roofsData;
        owners = ownersData;
      });
    } catch (error) {
      print('Fehler beim Abrufen der Daten: $error');
    }
  }

  void addContract() async {
    final laufzeit = int.tryParse(laufzeitController.text);
    final strompreis = double.tryParse(strompreisController.text);
    final mietpreis = double.tryParse(mietpreisController.text);

    if (selectedRoofId == null ||
        selectedOwnerId == null ||
        startDate == null) {
      print('Bitte alle Felder ausfüllen');
      return;
    }

    try {
      await supabase.from('Verträge').insert({
        'DachID': selectedRoofId,
        'EigentümerID': selectedOwnerId,
        'Startdatum': startDate!.toIso8601String(),
        'Laufzeit': laufzeit,
        'Strompreis': strompreis,
        'Mietpreis_Pro_Quartal': mietpreis
      });
      Navigator.pop(context);
    } catch (error) {
      print('Fehler beim Hinzufügen des Vertrags: $error');
    }
  }

  @override
  void dispose() {
    laufzeitController.dispose();
    strompreisController.dispose();
    mietpreisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neuen Vertrag hinzufügen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: roofs.isEmpty || owners.isEmpty
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
                    SizedBox(height: 16),
                    TextFormField(
                      controller: laufzeitController,
                      decoration:
                          InputDecoration(labelText: 'Laufzeit (Monate)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte Laufzeit eingeben';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: strompreisController,
                      decoration:
                          InputDecoration(labelText: 'Strompreis (CHF/kWh)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: mietpreisController,
                      decoration: InputDecoration(
                          labelText: 'Mietpreis pro Quartal (CHF)'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: Text(startDate == null
                          ? 'Startdatum auswählen'
                          : 'Startdatum: ${startDate!.toLocal().toString().split(' ')[0]}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            startDate = date;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addContract();
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
