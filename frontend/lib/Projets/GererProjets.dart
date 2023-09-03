import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsProjets.dart';
import 'ModifierProjets.dart';
import 'AddProjets.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyProjetApp(),
  ));
}

class MyProjetApp extends StatefulWidget {
  @override
  _MyProjetAppState createState() => _MyProjetAppState();
}

class _MyProjetAppState extends State<MyProjetApp> {
  GlobalKey<_MyProjetAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> projets = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjets();
  }

  Future<void> fetchProjets() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllProjets'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('projets')) {
        setState(() {
          projets = responseBody['projets'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  Future<void> searchProjets(String query) async {
    if (query.isEmpty) {
      fetchProjets();
      return;
    }

    final response =
        await http.get(Uri.parse('$serverURL/api/getProjetDetails?titre=$query'));
    if (response.statusCode == 200) {
      setState(() {
        projets = [json.decode(response.body)['projet']];
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
            'assets/projet.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Projets'),
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
                    searchProjets(searchController.text);
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
                      .currentContext!,
                  MaterialPageRoute(
                    builder: (context) => MyAddProjetApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchProjets(); 
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
                DataColumn(label: Text('Titre')),
                DataColumn(label: Text('Budget')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: projets.map<DataRow>((projet) {
                return DataRow(cells: [
                  DataCell(Text(projet['id'].toString())),
                  DataCell(Text(projet['titre'])),
                  DataCell(Text(projet['budget'])),
                  DataCell(buildOptionsDropdown(projet)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic projet) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, projet);
        }
      },
    );
  }

  Future<void> deleteProjet(String titre) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteProjet'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'titre': titre},
    );

    if (response.statusCode == 200) {
      fetchProjets();
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic projet) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ModifierProjet(titre: projet['titre'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteProjet(projet['titre']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, projet['titre']);
    }
  }

  void navigateToDetailsPage(BuildContext context, String titre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(titre: titre, serverURL: serverURL),
      ),
    );
  }
}