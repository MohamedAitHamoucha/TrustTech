import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsTaches.dart';
import 'ModifierTaches.dart';
import 'AddTaches.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyTacheApp(),
  ));
}

class MyTacheApp extends StatefulWidget {
  @override
  _MyTacheAppState createState() => _MyTacheAppState();
}

class _MyTacheAppState extends State<MyTacheApp> {
  GlobalKey<_MyTacheAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> taches = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTaches();
  }

  Future<void> fetchTaches() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllTaches'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('taches')) {
        setState(() {
          taches = responseBody['taches'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  Future<void> searchTaches(String query) async {
    if (query.isEmpty) {
      fetchTaches();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getTacheDetails?nom=$query'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('tache')) {
        setState(() {
          taches = [responseBody['tache']];
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
            'assets/taches.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Taches'),
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
                    searchTaches(searchController.text);
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
                    builder: (context) => MyAddTacheApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchTaches(); // Refresh the list of collaborateurs after adding
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
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: taches.map<DataRow>((collaborateur) {
                return DataRow(cells: [
                  DataCell(Text(collaborateur['id'].toString())),
                  DataCell(Text(collaborateur['nom'])),
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

  Future<void> deleteTache(String nom) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteTache'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nom': nom},
    );

    if (response.statusCode == 200) {
      fetchTaches();
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
              ModifierTache(nom: collaborateur['nom'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteTache(collaborateur['nom']);
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
