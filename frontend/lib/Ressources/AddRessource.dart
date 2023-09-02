import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddRessourceApp extends StatefulWidget {
  final String serverURL;

  MyAddRessourceApp({required this.serverURL});

  @override
  _MyAddRessourceAppState createState() => _MyAddRessourceAppState();
}

class _MyAddRessourceAppState extends State<MyAddRessourceApp> {
  GlobalKey<_MyAddRessourceAppState> scaffoldKey = GlobalKey();

  TextEditingController typeController = TextEditingController();
  TextEditingController uniteController = TextEditingController();
  String? selectedFournisseur; // To store the selected fournisseur

  List<dynamic> fournisseurs = []; // Store the list of fournisseurs

  @override
  void initState() {
    super.initState();
    fetchFournisseurs(); // Fetch fournisseurs data when the widget initializes
  }

  Future<void> fetchFournisseurs() async {
    final response = await http.get(Uri.parse('${widget.serverURL}/api/getAllFournisseurs'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('fournisseurs')) {
        setState(() {
          fournisseurs = responseBody['fournisseurs'];
          if (fournisseurs.isNotEmpty) {
            selectedFournisseur = fournisseurs[0]['id'].toString(); // Initialize with the first fournisseur
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> addRessource(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addResource'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': typeController.text,
        'unite': uniteController.text,
        'fournisseur': selectedFournisseur,
      }),
    );

    if (response.statusCode == 201) {
      // Ressource added successfully
      Navigator.pop(context, true); // Pop the page with a success flag
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
            'assets/ressources.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter Ressource'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: uniteController,
                decoration: InputDecoration(labelText: 'Unité'),
              ),
              DropdownButton<String>(
                value: selectedFournisseur,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFournisseur = newValue;
                  });
                },
                items: fournisseurs.map<DropdownMenuItem<String>>((fournisseur) {
                  return DropdownMenuItem<String>(
                    key: Key(fournisseur['id'].toString()), // Provide a unique key
                    value: fournisseur['id'].toString(),
                    child: Text(fournisseur['nom']),
                  );
                }).toList(),
                hint: Text('Sélectionner un fournisseur'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addRessource(context);
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}