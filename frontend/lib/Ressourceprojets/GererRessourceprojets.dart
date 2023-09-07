import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AddRessourceprojets.dart';
import 'DetailsRessourceprojets.dart';
import 'ModifierRessourceprojets.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyRessourceprojetsApp(),
  ));
}

class MyRessourceprojetsApp extends StatefulWidget {
  @override
  _MyRessourceprojetsAppState createState() => _MyRessourceprojetsAppState();
}

class _MyRessourceprojetsAppState extends State<MyRessourceprojetsApp> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> ressourceprojets = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchressourceprojets();
  }

  Future<void> fetchressourceprojets() async {
    final response =
        await http.get(Uri.parse('$serverURL/api/getAllResourceProjects'));
    if (response.statusCode == 200) {
      setState(() {
        ressourceprojets = json.decode(response.body)['resourceProjects'];
      });
    } else {
      // Handle error
    }
  }

  Future<void> searchRessourceprojets(String query) async {
    if (query.isEmpty) {
      fetchressourceprojets();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getResourceProjectDetails?id=$query'));
    if (response.statusCode == 200) {
      setState(() {
        ressourceprojets = [json.decode(response.body)['resourceProject']];
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
            'assets/ressourceprojet.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les ressources de Projet'),
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
                    searchRessourceprojets(searchController.text);
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
                        MyAddRessourceProjetApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchressourceprojets(); 
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
                DataColumn(label: Text('Quantite')),
                DataColumn(label: Text('Projet')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: ressourceprojets.map<DataRow>((ressourceprojet) {
                return DataRow(cells: [
                  DataCell(Text(ressourceprojet['id'].toString())),
                  DataCell(Text(ressourceprojet['quantite'].toString())),
                  DataCell(Text(ressourceprojet['projet'].toString())),
                  DataCell(buildOptionsDropdown(ressourceprojet)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic ressourceprojet) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, ressourceprojet);
        }
      },
    );
  }

  Future<void> deleteFacture(String id) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteResourceProject'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      fetchressourceprojets(); 
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic ressourceprojet) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifierRessourceprojet(
            id: ressourceprojet['id'].toString(),
            serverURL: serverURL,
          ),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteFacture(ressourceprojet['id'].toString());
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, ressourceprojet['id'].toString());
    }
  }

  void navigateToDetailsPage(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(id: id, serverURL: serverURL),
      ),
    );
  }
}