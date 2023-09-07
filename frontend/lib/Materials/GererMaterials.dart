import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsMaterials.dart';
import 'ModifierMaterials.dart';
import 'AddMaterials.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatefulWidget {
  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  GlobalKey<_MyMaterialAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> materiels = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllMaterials'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('materiels')) {
        setState(() {
          materiels = responseBody['materiels'];
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
      fetchMaterials();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getMaterielDetails?nom=$query'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('materiel')) {
        setState(() {
          materiels = [responseBody['materiel']];
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
            'assets/equipment 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Materiels'),
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
                    builder: (context) => MyAddMaterielApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchMaterials(); // Refresh the list of collaborateurs after adding
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
                DataColumn(label: Text('Reference')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: materiels.map<DataRow>((materiel) {
                return DataRow(cells: [
                  DataCell(Text(materiel['id'].toString())),
                  DataCell(Text(materiel['nom'])),
                  DataCell(Text(materiel['reference'])),
                  DataCell(buildOptionsDropdown(materiel)),
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

  Future<void> deleteMateriel(String nom) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteMateriel'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nom': nom},
    );

    if (response.statusCode == 200) {
      fetchMaterials();
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic materiel) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ModifierMateriel(nom: materiel['nom'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteMateriel(materiel['nom']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, materiel['nom']);
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
