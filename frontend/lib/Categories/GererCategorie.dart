import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailsCategorie.dart';
import 'ModifierCategorie.dart';
import 'AddCategorie.dart';
import 'package:frontend/constants.dart';

void main() {
  runApp(MaterialApp(
    home: MyCategorieApp(),
  ));
}

class MyCategorieApp extends StatefulWidget {
  @override
  _MyCategorieAppState createState() => _MyCategorieAppState();
}

class _MyCategorieAppState extends State<MyCategorieApp> {
  GlobalKey<_MyCategorieAppState> scaffoldKey = GlobalKey();
  final serverURL = Constants.baseServerUrl;

  List<dynamic> categories = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('$serverURL/api/getAllCategories'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('categories')) {
        setState(() {
          categories = responseBody['categories'];
        });
      } else {
        // Handle error: The response body is not as expected
        print('Response body does not contain "categories".');
      }
    } else {
      // Handle error: The API response status code is not 200
      print('API request failed with status code ${response.statusCode}');
    }
  }

  // Function to search categories
  Future<void> searchCategories(String query) async {
  if (query.isEmpty) {
    fetchCategories();
    return;
  }

  final response = await http.get(Uri.parse('$serverURL/api/getCategorieDetails?nom=$query'));

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody != null && responseBody.containsKey('category')) {
      setState(() {
        categories = [responseBody['category']];
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
            'assets/categories.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Gérer les Categories'),
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
                    searchCategories(searchController.text);
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
                        MyAddCategorieApp(serverURL: serverURL),
                  ),
                );

                if (result == true) {
                  fetchCategories(); // Refresh the list of categories after adding
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
              rows: categories.map<DataRow>((categorie) {
                return DataRow(cells: [
                  DataCell(Text(categorie['id'].toString())),
                  DataCell(Text(categorie['nom'])),
                  DataCell(buildOptionsDropdown(categorie)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionsDropdown(dynamic categorie) {
    return DropdownButton<String>(
      items: <String>['Supprimer', 'Details'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          handleOptionSelection(newValue, categorie);
        }
      },
    );
  }

  Future<void> deleteCategorie(String nom) async {
    final response = await http.delete(
      Uri.parse('$serverURL/api/deleteCategorie'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'nom': nom},
    );

    if (response.statusCode == 200) {
      fetchCategories(); // Refresh the list of categories
    } else {
      // Handle deletion error
      print('Deletion error: ${response.statusCode}');
    }
  }

  void handleOptionSelection(String option, dynamic categorie) async {
    if (option == 'Supprimer') {
      await deleteCategorie(categorie['nom']);
    } else if (option == 'Details') {
      print('Navigating to details page'); // Add this line
      navigateToDetailsPage(context, categorie['nom']);
    }
  }

  void navigateToDetailsPage(BuildContext context, String nom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsCategorie(nom: nom, serverURL: serverURL),
      ),
    );
  }
}
