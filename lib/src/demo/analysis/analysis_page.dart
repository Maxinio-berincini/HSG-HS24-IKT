import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_drawer.dart';
import '../home_page.dart';


class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

final supabase = Supabase.instance.client;

class _AnalysisPageState extends State<AnalysisPage> {
  double totalRoofArea = 0.0;
  double totalCapacity = 0.0;
  int totalContracts = 0;

  List<dynamic> ertragProDachgroesse = [];
  List<dynamic> strompreisProLaufzeit = [];

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  void fetchStatistics() async {
    try {
      // Gesamte Dachfläche berechnen
      final roofData = await supabase.from('Dachflächen').select('Grösse');
      totalRoofArea =
          roofData.fold(0.0, (sum, item) => sum + (item['Grösse'] ?? 0.0));

      // Gesamtkapazität der PV-Anlagen berechnen
      final pvData = await supabase.from('PV-Anlagen').select('Kapazität');
      totalCapacity =
          pvData.fold(0.0, (sum, item) => sum + (item['Kapazität'] ?? 0.0));

      // Gesamtzahl der Verträge abrufen
      final contractData = await supabase.from('Verträge').select('VertragsID');
      totalContracts = contractData.length;

      // Abfrage 1: Ertrag pro Dachgrösse
      final ertragData = await supabase.rpc('get_ertrag_pro_dachgroesse');
      ertragProDachgroesse = ertragData;

      // Abfrage 2: Strompreis pro Laufzeit
      final strompreisData = await supabase.rpc('get_strompreis_pro_laufzeit');
      strompreisProLaufzeit = strompreisData;

      setState(() {});
    } catch (error) {
      print('Fehler beim Abrufen der Statistiken: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: totalRoofArea == 0 &&
            totalCapacity == 0 &&
            totalContracts == 0 &&
            ertragProDachgroesse.isEmpty &&
            strompreisProLaufzeit.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            Text('Gesamte Dachfläche: $totalRoofArea m²'),
            Text('Gesamtkapazität der PV-Anlagen: $totalCapacity kW'),
            Text('Anzahl der Verträge: $totalContracts'),
            SizedBox(height: 20),
            Text(
              'Ertragskraft nach Dachgrösse:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Dachgrösse (m²)')),
                DataColumn(label: Text('Gesamtertrag (kWh)')),
              ],
              rows: ertragProDachgroesse
                  .map<DataRow>((item) => DataRow(cells: [
                DataCell(Text(item['Grösse'].toString())),
                DataCell(Text(item['GesamtErtrag'].toString())),
              ]))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Strompreise nach Vertragslaufzeit:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Laufzeit (Monate)')),
                DataColumn(
                    label: Text('Durchschn. Strompreis (CHF/kWh)')),
              ],
              rows: strompreisProLaufzeit
                  .map<DataRow>((item) => DataRow(cells: [
                DataCell(Text(item['Laufzeit'].toString())),
                DataCell(Text(item['DurchschnittlicherStrompreis']
                    .toString())),
              ]))
                  .toList(),
            ),
          ],
        ),
      );
  }
}
