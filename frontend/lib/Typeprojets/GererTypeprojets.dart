import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsTypeprojets.dart';
import 'ModifierTypeprojets.dart';
import 'AddTypeprojets.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyTypeprojetApp(),
  ));
}

class MyTypeprojetApp extends StatefulWidget {
  @override
  _MyTypeprojetAppState createState() => _MyTypeprojetAppState();
}

class _MyTypeprojetAppState extends State<MyTypeprojetApp> {
  GlobalKey<_MyTypeprojetAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> typeprojets = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTypeprojets();
  }

  Future<void> fetchTypeprojets() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllTypeProjets'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('typeProjets')) {
        setState(() {
          typeprojets = responseBody['typeProjets'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  Future<void> searchTypeprojets(String query) async {
    if (query.isEmpty) {
      fetchTypeprojets();
      return;
    }

    final response =
        await http.get(Uri.parse('$serverURL/api/getTypeProjetDetails?type=$query'));
    if (response.statusCode == 200) {
      setState(() {
        typeprojets = [json.decode(response.body)['typeProjet']];
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
            'assets/typeprojet.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Types de Projet'),
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
                    searchTypeprojets(searchController.text);
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
                    builder: (context) => MyAddTypeProjetApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchTypeprojets();
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
                DataColumn(
                  label: Text(
                    'Options',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: typeprojets.map<DataRow>((typeProjet) {
                return DataRow(cells: [
                  DataCell(Text(typeProjet['id'].toString())),
                  DataCell(Text(typeProjet['type'])),
                  DataCell(buildOptionsDropdown(typeProjet)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic typeProjet) {
    return DropdownButton<String>(
      items: <String>['Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, typeProjet);
        }
      },
    );
  }

  Future<void> deleteTypeProjet(String type) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteTypeProjet'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'type': type},
    );

    if (response.statusCode == 200) {
      fetchTypeprojets();
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic typeProjet) async {
     if (option == 'Supprimer') {
      await deleteTypeProjet(typeProjet['type']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, typeProjet['type']);
    }
  }

  void navigateToDetailsPage(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(type: type, serverURL: serverURL),
      ),
    );
  }
}
