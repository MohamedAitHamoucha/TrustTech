import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifierMateriel extends StatefulWidget {
  final String nom;
  final String serverURL;

  ModifierMateriel({required this.nom, required this.serverURL});

  @override
  _ModifierMaterielState createState() => _ModifierMaterielState();
}

class _ModifierMaterielState extends State<ModifierMateriel> {
  TextEditingController referenceController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();
  TextEditingController prixachatController = TextEditingController();

  String? selectedCategorie;
  String? selectedRessource;

  List<dynamic> categories = [];
  List<dynamic> ressources = [];

  @override
  void initState() {
    super.initState();
    fetchMaterielDetails();
    fetchCategories();
    fetchRessources();
  }

  Future<void> fetchMaterielDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getMaterielDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final materielDetails = json.decode(response.body)['materiel'];
      referenceController.text = materielDetails['reference'];
      quantiteController.text = materielDetails['quantite'].toString();
      prixachatController.text = materielDetails['prix_achat'].toString();
      selectedCategorie = materielDetails['categorie'].toString();
      selectedRessource = materielDetails['ressource'].toString();
    } else {
      // Handle error
    }
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllCategories'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('categories')) {
        setState(() {
          categories = responseBody['categories'];
          if (categories.isNotEmpty) {
            selectedCategorie = categories[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchRessources() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllResources'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('resources')) {
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

  Future<void> updateMateriel() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateMateriel'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': widget.nom,
        'reference': referenceController.text,
        'quantite': quantiteController.text,
        'prix_achat': prixachatController.text,
        'categorie': selectedCategorie,
        'ressource': selectedRessource,
      }),
    );

    if (response.statusCode == 200) {
      // Client updated successfully
      Navigator.pop(context);
    } else {
      // Handle update error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Modifier la Materiel'),
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
                controller: referenceController,
                decoration: InputDecoration(labelText: 'Reference'),
              ),
              TextField(
                controller: quantiteController,
                decoration: InputDecoration(labelText: 'Quantite'),
              ),
              TextField(
                controller: prixachatController,
                decoration: InputDecoration(labelText: "Prix d'Achat"),
              ),
              DropdownButton<String>(
                value: selectedCategorie,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategorie = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((categories) {
                  return DropdownMenuItem<String>(
                    key: Key(
                        categories['id'].toString()), // Provide a unique key
                    value: categories['id'].toString(),
                    child: Text(categories['nom']),
                  );
                }).toList(),
                hint: Text('Sélectionner une Categorie'),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedRessource,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRessource = newValue;
                  });
                },
                items: ressources.map<DropdownMenuItem<String>>((ressource) {
                  return DropdownMenuItem<String>(
                    key:
                        Key(ressource['id'].toString()), // Provide a unique key
                    value: ressource['id'].toString(),
                    child: Text(ressource['type']),
                  );
                }).toList(),
                hint: Text('Sélectionner une Ressource'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateMateriel();
                },
                child: Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
