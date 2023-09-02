import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AddRessource.dart';
import 'DetailsRessource.dart';
import 'ModifierRessource.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyRessourceApp(),
  ));
}

class MyRessourceApp extends StatefulWidget {
  @override
  _MyRessourceAppState createState() => _MyRessourceAppState();
}

class _MyRessourceAppState extends State<MyRessourceApp> {
  GlobalKey<_MyRessourceAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> resources = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchResources();
  }

  Future<void> fetchResources() async {
    final response =
        await http.get(Uri.parse('$serverURL/api/getAllResources'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('resources')) {
        setState(() {
          resources = responseBody['resources'];
        });
      } else {
        // Handle error: The response body is not as expected
        print('Response body does not contain "resources".');
      }
    } else {
      // Handle error: The API response status code is not 200
      print('API request failed with status code ${response.statusCode}');
    }
  }

  Future<void> searchResources(String query) async {
    if (query.isEmpty) {
      fetchResources();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getResourceDetails?query=$query'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('resources')) {
        setState(() {
          resources = responseBody['resources'];
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
            'assets/ressources.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Ressources'),
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
                    searchResources(searchController.text);
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
                  scaffoldKey.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => MyAddRessourceApp(
                      serverURL: serverURL,
                      fournisseurs:
                          fournisseurs, // Pass the fournisseurs list here
                    ),
                  ),
                );

                if (result == true) {
                  fetchRessources(); // Refresh the list of ressources after adding
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
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Unite')),
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: resources.map<DataRow>((resource) {
                return DataRow(cells: [
                  DataCell(Text(resource['id'].toString())),
                  DataCell(Text(resource['type'])),
                  DataCell(Text(resource['unite'])),
                  DataCell(buildOptionsDropdown(resource)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic resource) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Details', 'Supprimer'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, resource);
        }
      },
    );
  }

  Future<void> deleteResource(String name) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteResource'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'name': name},
    );

    if (response.statusCode == 200) {
      fetchResources();
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic resource) async {
    /*if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyModifyResourceApp(name: resource['name'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteResource(resource['name']);
    } else if (option == 'Details') {
      navigateToDetailsPage(context, resource['name']);
    }*/
  }
  /*void navigateToDetailsPage(BuildContext context, String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MyDetailsResourcePage(name: name, serverURL: serverURL),
      ),
    );
  }*/
}
