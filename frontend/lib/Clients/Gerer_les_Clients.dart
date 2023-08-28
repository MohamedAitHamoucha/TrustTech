import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Details_Client.dart';
import 'Modifier_Client.dart';
import 'Add_Client.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyClientApp(),
  ));
}

class MyClientApp extends StatefulWidget {
  @override
  _MyClientAppState createState() => _MyClientAppState();
}

class _MyClientAppState extends State<MyClientApp> {
  GlobalKey<_MyClientAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> clients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllClients'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('Clients')) {
        setState(() {
          clients = responseBody['Clients'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  Future<void> searchClients(String query) async {
    if (query.isEmpty) {
      fetchClients();
      return;
    }

    final response = await http
        .get(Uri.parse('$serverURL/api/getClientDetails?nom=$query'));
    if (response.statusCode == 200) {
      setState(() {
        clients = [json.decode(response.body)['Client']];
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
        title: Text('Gérer les Clients'),
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
                    searchClients(searchController.text);
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
                    builder: (context) => MyAddClientApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchClients(); // Refresh the list of clients after adding
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
              rows: clients.map<DataRow>((client) {
                return DataRow(cells: [
                  DataCell(Text(client['id'].toString())),
                  DataCell(Text(client['nom'])),
                  DataCell(Text(client['email'])),
                  DataCell(buildOptionsDropdown(client)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic client) {
    return DropdownButton<String>(
      items: <String>['Modifier', 'Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, client);
        }
      },
    );
  }

  Future<void> deleteClient(String nom) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteClient'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nom': nom},
    );

    if (response.statusCode == 200) {
      fetchClients(); // Refresh the list of clients
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic client) async {
    if (option == 'Modifier') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ModifierClients(nom: client['nom'], serverURL: serverURL),
        ),
      );
    } else if (option == 'Supprimer') {
      await deleteClient(client['nom']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, client['nom']);
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