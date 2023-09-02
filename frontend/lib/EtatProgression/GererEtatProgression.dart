import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsEtatProgression.dart';
import 'ModifierEtatProgression.dart';
import 'AddEtatProgression.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyEtatProgressionApp(),
  ));
}

class MyEtatProgressionApp extends StatefulWidget {
  @override
  _MyEtatProgressionAppState createState() => _MyEtatProgressionAppState();
}

class _MyEtatProgressionAppState extends State<MyEtatProgressionApp> {
  GlobalKey<_MyEtatProgressionAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> etatProgressions = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEtatProgressions();
  }

  Future<void> fetchEtatProgressions() async {
    final response =
        await http.get(Uri.parse('$serverURL/api/getAllEtatProgression'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null &&
          responseBody.containsKey('etatProgressions')) {
        setState(() {
          etatProgressions = responseBody['etatProgressions'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  Future<void> searchEtatProgressions(String query) async {
    if (query.isEmpty) {
      fetchEtatProgressions();
      return;
    }

    final response = await http.get(
        Uri.parse('$serverURL/api/getEtatProgressionDetails?libelle=$query'));
    if (response.statusCode == 200) {
      setState(() {
        etatProgressions = [json.decode(response.body)['etatProgression']];
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 0, 230, 1),
        leading: IconButton(
          icon: Image.asset(
            'assets/etat.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Etats de Progression'),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/backarr.png',
              width: 30,
              height: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    searchEtatProgressions(searchController.text);
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  scaffoldKey
                      .currentContext!, // Use the scaffoldKey to access the context
                  MaterialPageRoute(
                    builder: (context) => MyAddEtatProgressiontApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchEtatProgressions(); // Refresh the list of etatProgressions after adding
                }
              },
              child: Text('Ajouter'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Libelle')),
                DataColumn(label: Text('order')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: etatProgressions.map<DataRow>((etatProgression) {
                return DataRow(cells: [
                  DataCell(Text(etatProgression['id'].toString())),
                  DataCell(Text(etatProgression['libelle'])),
                  DataCell(Text(etatProgression['ordre'] != null
                      ? etatProgression['ordre'].toString()
                      : 'N/A')),
                  DataCell(buildOptionsDropdown(etatProgression)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic etatProgression) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, etatProgression);
        }
      },
    );
  }

  Future<void> deleteEtatProgression(String libelle) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteEtatProgression'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'libelle': libelle},
    );

    if (response.statusCode == 200) {
      fetchEtatProgressions(); // Refresh the list of etatProgressions
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic etatProgression) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ModifierEtatProgressions(libelle: etatProgression['libelle'], serverURL: serverURL),
        ),
      );
    } else
    if (option == 'Supprimer') {
      await deleteEtatProgression(etatProgression['libelle']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, etatProgression['libelle']);
    }
  }

  void navigateToDetailsPage(BuildContext context, String libelle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(libelle: libelle, serverURL: serverURL),
      ),
    );
  }
}
