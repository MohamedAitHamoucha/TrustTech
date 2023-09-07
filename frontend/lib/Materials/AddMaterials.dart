import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddMaterielApp extends StatefulWidget {
  final String serverURL;

  MyAddMaterielApp({required this.serverURL});

  @override
  _MyAddMaterielAppState createState() => _MyAddMaterielAppState();
}

class _MyAddMaterielAppState extends State<MyAddMaterielApp> {
  GlobalKey<_MyAddMaterielAppState> scaffoldKey = GlobalKey();

  TextEditingController nomController = TextEditingController();
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
    fetchCategories();
    fetchRessources();
  }

  Future<void> fetchCategories() async {
    final response = await http
        .get(Uri.parse('${widget.serverURL}/api/getAllCategories'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null &&
          responseBody.containsKey('categories')) {
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

  Future<void> addMateriel(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addMaterial'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': nomController.text,
        'reference': referenceController.text,
        'quantite': quantiteController.text,
        'prix_achat': prixachatController.text,
        'categorie': selectedCategorie,
        'ressource': selectedRessource,
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
            'assets/equipment 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter un Materiel'),
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
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
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
                items: categories
                    .map<DropdownMenuItem<String>>((categories) {
                  return DropdownMenuItem<String>(
                    key: Key(categories['id']
                        .toString()), // Provide a unique key
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
                    key: Key(
                        ressource['id'].toString()), // Provide a unique key
                    value: ressource['id'].toString(),
                    child: Text(ressource['type']),
                  );
                }).toList(),
                hint: Text('Sélectionner une Ressource'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addMateriel(context);
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
