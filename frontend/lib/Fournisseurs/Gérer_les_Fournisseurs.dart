import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Details_Fournisseurs.dart';
import 'Modifier_Fournisseurs.dart';
import 'Add_Fournisseurs.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyFournisseurApp(),
  ));
}

class MyFournisseurApp extends StatefulWidget {
  @override
  _MyFournisseurAppState createState() => _MyFournisseurAppState();
}

class _MyFournisseurAppState extends State<MyFournisseurApp> {
  GlobalKey<_MyFournisseurAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> fournisseurs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFournisseurs();
  }

  Future<void> fetchFournisseurs() async {
    final response =
        await http.get(Uri.parse('$serverURL/api/getAllFournisseurs'));
    if (response.statusCode == 200) {
      setState(() {
        fournisseurs = json.decode(response.body)['fournisseurs'];
      });
    } else {
      // Handle error
    }
  }

  Future<void> searchFournisseurs(String query) async {
    if (query.isEmpty) {
      fetchFournisseurs();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getFournisseurDetails?nom=$query'));
    if (response.statusCode == 200) {
      setState(() {
        fournisseurs = [json.decode(response.body)['fournisseur']];
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
        title: Text('Gérer les Fournisseurs'),
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
                    searchFournisseurs(searchController.text);
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
                    builder: (context) =>
                        MyAddFournisseurApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchFournisseurs(); // Refresh the list of fournisseurs after adding
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
                DataColumn(label: Text('Nom')),
                DataColumn(label: Text('Email')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: fournisseurs.map<DataRow>((fournisseur) {
                return DataRow(cells: [
                  DataCell(Text(fournisseur['id'].toString())),
                  DataCell(Text(fournisseur['nom'])),
                  DataCell(Text(fournisseur['email'])),
                  DataCell(buildOptionsDropdown(fournisseur)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic fournisseur) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, fournisseur);
        }
      },
    );
  }

  Future<void> deleteFournisseur(String nom) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteFournisseur'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nom': nom},
    );

    if (response.statusCode == 200) {
      fetchFournisseurs(); // Refresh the list of fournisseurs
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic fournisseur) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifierFournisseurs(
              nom: fournisseur['nom'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteFournisseur(fournisseur['nom']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, fournisseur['nom']);
    }
  }

  void navigateToDetailsPage(BuildContext context, String nom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(nom: nom, serverURL: serverURL),
      ),
    );
  }
}