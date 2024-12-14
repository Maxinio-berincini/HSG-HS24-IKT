import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPVSystemPage extends StatefulWidget {
  final Map<String, dynamic> pvSystem;

  EditPVSystemPage({required this.pvSystem});

  @override
  _EditPVSystemPageState createState() => _EditPVSystemPageState();
}

final supabase = Supabase.instance.client;

class _EditPVSystemPageState extends State<EditPVSystemPage> {
  final _formKey = GlobalKey<FormState>();
  final kapazitaetController = TextEditingController();
  final ertragController = TextEditingController();

  int? selectedRoofId;
  List<dynamic> roofs = [];

  @override
  void initState() {
    super.initState();
    kapazitaetController.text = widget.pvSystem['Kapazität'].toString();
    ertragController.text = widget.pvSystem['Ertrag']?.toString() ?? '';
    selectedRoofId = widget.pvSystem['DachID'];
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

  void updatePVSystem() async {
    final kapazitaet = double.tryParse(kapazitaetController.text);
    final ertrag = double.tryParse(ertragController.text);

    if (selectedRoofId == null) {
      print('Bitte eine Dachfläche auswählen');
      return;
    }

    try {
      await supabase
          .from('PV-Anlagen')
          .update({
        'DachID': selectedRoofId,
        'Kapazität': kapazitaet,
        'Ertrag': ertrag,
      })
          .eq('AnlagenID', widget.pvSystem['AnlagenID']);
      Navigator.pop(context);
    } catch (error) {
      print('Fehler beim Aktualisieren der PV-Anlage: $error');
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
        title: Text('PV-Anlage bearbeiten'),
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
              ),
              TextFormField(
                controller: kapazitaetController,
                decoration: InputDecoration(labelText: 'Kapazität (kW)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: ertragController,
                decoration: InputDecoration(labelText: 'Ertrag (kWh)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updatePVSystem();
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
