import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

final supabase = Supabase.instance.client;

class _AnalysisPageState extends State<AnalysisPage> {
  bool isLoading = true;

  double gesamteDachflaeche = 0.0;
  int anzahlVertraege = 0;
  double gesamterGenerierterStrom = 0.0;
  double gesamterVerbrauchStrom = 0.0;
  double gesamterEingespeisterStrom = 0.0;

  List<Map<String, dynamic>> quartalsErzeugung = [];
  List<Map<String, dynamic>> vertraegeVerbrauch = [];

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    setState(() {
      isLoading = true;
    });

    try {
      // globale Statistiken
      final globalStatsResponse = await supabase.rpc('get_global_stats');
      if (globalStatsResponse != null) {
        gesamteDachflaeche =
            (globalStatsResponse['gesamte_dachflaeche'] ?? 0.0).toDouble();
        anzahlVertraege = globalStatsResponse['anzahl_vertraege'] ?? 0;
        gesamterGenerierterStrom =
            (globalStatsResponse['gesamter_generierter_strom'] ?? 0.0)
                .toDouble();
        gesamterVerbrauchStrom =
            (globalStatsResponse['gesamter_verbrauch_strom'] ?? 0.0).toDouble();
        gesamterEingespeisterStrom =
            (globalStatsResponse['gesamter_eingespeister_strom'] ?? 0.0)
                .toDouble();
      }

      // Quartals-Erzeugung
      final quartalsResponse = await supabase.rpc('get_quartals_erzeugung');
      if (quartalsResponse != null) {
        quartalsErzeugung = (quartalsResponse as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }

      // Verträge-Verbrauch
      final vertraegeResponse = await supabase.rpc('get_vertraege_verbrauch');
      if (vertraegeResponse != null) {
        vertraegeVerbrauch = (vertraegeResponse as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print('Fehler beim Abrufen der Statistiken: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Globale Statistiken',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildGlobalStatsTable(),
          SizedBox(height: 40),
          Text(
            'Quartalsweise Erzeugung',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildQuartalsErzeugungTable(),
          SizedBox(height: 40),
          Text(
            'Verbrauch und Kosten pro Vertrag',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildVertraegeVerbrauchTable(),
        ],
      ),
    );
  }

  Widget _buildGlobalStatsTable() {
    return DataTable(
      columns: [
        DataColumn(
            label: Text(
          'Kennzahl',
          style: TextStyle(fontStyle: FontStyle.italic),
        )),
        DataColumn(
            label: Text(
          'Wert',
          style: TextStyle(fontStyle: FontStyle.italic),
        )),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('Gesamte Dachflächengrösse')),
          DataCell(Text('$gesamteDachflaeche m²')),
        ]),
        DataRow(cells: [
          DataCell(Text('Anzahl Verträge')),
          DataCell(Text(anzahlVertraege.toString())),
        ]),
        DataRow(cells: [
          DataCell(Text('Gesamter generierter Strom')),
          DataCell(Text('$gesamterGenerierterStrom kWh')),
        ]),
        DataRow(cells: [
          DataCell(Text('Gesamter verbrauchter Strom')),
          DataCell(Text('$gesamterVerbrauchStrom kWh')),
        ]),
        DataRow(cells: [
          DataCell(Text('Gesamter eingespeister Strom')),
          DataCell(Text('$gesamterEingespeisterStrom kWh')),
        ]),
      ],
    );
  }

  Widget _buildQuartalsErzeugungTable() {
    if (quartalsErzeugung.isEmpty) {
      return Text('Keine Daten vorhanden.');
    }
    return DataTable(
      columns: [
        DataColumn(label: Text('QuartalID')),
        DataColumn(label: Text('GesamtErzeugungKWh')),
      ],
      rows: quartalsErzeugung.map((item) {
        return DataRow(cells: [
          DataCell(Text(item['QuartalID'].toString())),
          DataCell(Text(item['GesamtErzeugungKWh'].toString())),
        ]);
      }).toList(),
    );
  }

  Widget _buildVertraegeVerbrauchTable() {
    if (vertraegeVerbrauch.isEmpty) {
      return Text('Keine Daten vorhanden.');
    }
    return DataTable(
      columns: [
        DataColumn(label: Text('VertragsID')),
        DataColumn(label: Text('GesamtVerbrauchKWh')),
        DataColumn(label: Text('Gesamtkosten (CHF)')),
      ],
      rows: vertraegeVerbrauch.map((item) {
        return DataRow(cells: [
          DataCell(Text(item['VertragsID'].toString())),
          DataCell(Text(item['GesamtVerbrauchKWh'].toString())),
          DataCell(Text(item['Gesamtkosten'].toStringAsFixed(2))),
        ]);
      }).toList(),
    );
  }
}
