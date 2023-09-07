import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddRessourceProjetApp extends StatefulWidget {
  final String serverURL;

  MyAddRessourceProjetApp({required this.serverURL});

  @override
  _MyAddFactureAppState createState() => _MyAddFactureAppState();
}

class _MyAddFactureAppState extends State<MyAddRessourceProjetApp> {
  GlobalKey<_MyAddFactureAppState> scaffoldKey = GlobalKey();

  TextEditingController quantiteController = TextEditingController();
  TextEditingController prixController = TextEditingController();

  String? selectedRessource;
  String? selectedProjet;

  List<dynamic> ressources = [];
  List<dynamic> projets = [];

  @override
  void initState() {
    super.initState();
    fetchRessources();
    fetchProjets();
  }

  Future<void> fetchRessources() async {
    final response = await http
        .get(Uri.parse('${widget.serverURL}/api/getAllResources'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null &&
          responseBody.containsKey('resources')) {
        setState(() {
          ressources = responseBody['resources'];
          if (ressources.isNotEmpty) {
            selectedRessource = ressources[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchProjets() async {
    final response = await http
        .get(Uri.parse('${widget.serverURL}/api/getAllProjets'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null &&
          responseBody.containsKey('projets')) {
        setState(() {
          projets = responseBody['projets'];
          if (projets.isNotEmpty) {
            selectedProjet = projets[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> addRessourceProjet(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addResourceProject'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'quantite': quantiteController.text,
        'prix': prixController.text,
        'ressource': selectedRessource,
        'projet': selectedProjet,
      }),
    );

    if (response.statusCode == 201) {
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
            'assets/ressourceprojet.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter une Ressource de Projet'),
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
                controller: quantiteController,
                decoration: InputDecoration(labelText: 'Quantite'),
              ),
              TextField(
                controller: prixController,
                decoration: InputDecoration(labelText: 'Prix'),
              ),
              DropdownButton<String>(
                value: selectedRessource,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRessource = newValue;
                  });
                },
                items: ressources
                    .map<DropdownMenuItem<String>>((ressource) {
                  return DropdownMenuItem<String>(
                    key: Key(ressource['id']
                        .toString()), // Provide a unique key
                    value: ressource['id'].toString(),
                    child: Text(ressource['type']),
                  );
                }).toList(),
                hint: Text('Sélectionner une Ressource'),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedProjet,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedProjet = newValue;
                  });
                },
                items: projets
                    .map<DropdownMenuItem<String>>((projet) {
                  return DropdownMenuItem<String>(
                    key: Key(projet['id']
                        .toString()), // Provide a unique key
                    value: projet['id'].toString(),
                    child: Text(projet['titre']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Projet'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addRessourceProjet(context);
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