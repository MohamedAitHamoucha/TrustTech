import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsCollaborateur.dart';
import 'ModifierCollaborateur.dart';
import 'AddCollaborateur.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyCollaborateurApp(),
  ));
}

class MyCollaborateurApp extends StatefulWidget {
  @override
  _MyCollaborateurAppState createState() => _MyCollaborateurAppState();
}

class _MyCollaborateurAppState extends State<MyCollaborateurApp> {
  GlobalKey<_MyCollaborateurAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> collaborateurs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCollaborateurs();
  }

  Future<void> fetchCollaborateurs() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllCollaborateurs'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('collaborateurs')) {
        setState(() {
          collaborateurs = responseBody['collaborateurs'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  Future<void> searchCollaborateur(String query) async {
    if (query.isEmpty) {
      fetchCollaborateurs();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getCollaborateursDetails?nom=$query'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('collaborateur')) {
        setState(() {
          collaborateurs = [responseBody['collaborateur']];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
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
            'assets/collaboration 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Collaborateurs'),
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
                    searchCollaborateur(searchController.text);
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
                    builder: (context) => MyAddCollaborateurApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchCollaborateurs(); // Refresh the list of collaborateurs after adding
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
              rows: collaborateurs.map<DataRow>((collaborateur) {
                return DataRow(cells: [
                  DataCell(Text(collaborateur['id'].toString())),
                  DataCell(Text(collaborateur['nom'])),
                  DataCell(Text(collaborateur['email'])),
                  DataCell(buildOptionsDropdown(collaborateur)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic collaborateur) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, collaborateur);
        }
      },
    );
  }

  Future<void> deleteCollaborateur(String nom) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteCollaborateurs'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nom': nom},
    );

    if (response.statusCode == 200) {
      fetchCollaborateurs(); // Refresh the list of collaborateurs
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic collaborateur) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ModifierCollaborateur(nom: collaborateur['nom'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteCollaborateur(collaborateur['nom']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, collaborateur['nom']);
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
