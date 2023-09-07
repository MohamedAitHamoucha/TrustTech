import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsFacture.dart';
import 'ModifierFacture.dart';
import 'AddFacture.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyFactureApp(),
  ));
}

class MyFactureApp extends StatefulWidget {
  @override
  _MyFactureAppState createState() => _MyFactureAppState();
}

class _MyFactureAppState extends State<MyFactureApp> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> factures = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFactures();
  }

  Future<void> fetchFactures() async {
    final response =
        await http.get(Uri.parse('$serverURL/api/getAllFactureDetails'));
    if (response.statusCode == 200) {
      setState(() {
        factures = json.decode(response.body)['factureDetails'];
      });
    } else {
      // Handle error
    }
  }

  Future<void> searchFactures(String query) async {
    if (query.isEmpty) {
      fetchFactures();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getFactureDetails?reference=$query'));
    if (response.statusCode == 200) {
      setState(() {
        factures = [json.decode(response.body)['facture']];
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
            'assets/bill 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Factures'),
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
                    searchFactures(searchController.text);
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
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyAddFactureApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchFactures(); // Refresh the list of factures after adding
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
                DataColumn(label: Text('Reference')),
                DataColumn(label: Text('Titre')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: factures.map<DataRow>((facture) {
                return DataRow(cells: [
                  DataCell(Text(facture['id'].toString())),
                  DataCell(Text(facture['reference'])),
                  DataCell(Text(facture['titre'])),
                  DataCell(buildOptionsDropdown(facture)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic facture) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, facture);
        }
      },
    );
  }

  Future<void> deleteFacture(String reference) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteFacture'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'reference': reference},
    );

    if (response.statusCode == 200) {
      fetchFactures(); // Refresh the list of factures
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic facture) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifierFacture(
            reference: facture['reference'],
            serverURL: serverURL,
          ),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteFacture(facture['reference']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, facture['reference']);
    }
  }

  void navigateToDetailsPage(BuildContext context, String reference) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPageFacture(
          reference: reference,
          serverURL: serverURL,
        ),
      ),
    );
  }
}