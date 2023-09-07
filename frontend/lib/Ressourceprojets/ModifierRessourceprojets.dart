import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifierRessourceprojet extends StatefulWidget {
  final String id;
  final String serverURL;

  ModifierRessourceprojet({required this.id, required this.serverURL});

  @override
  _ModifierRessourceprojetState createState() =>
      _ModifierRessourceprojetState();
}

class _ModifierRessourceprojetState extends State<ModifierRessourceprojet> {
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
    fetchRessourceprojetDetails();
  }

  Future<void> fetchRessourceprojetDetails() async {
    final response = await http.get(
      Uri.parse(
          '${widget.serverURL}/api/getResourceProjectDetails?id=${widget.id}'),
    );

    if (response.statusCode == 200) {
      final ressourceprojetDetails =
          json.decode(response.body)['resourceProject'];
      quantiteController.text = ressourceprojetDetails['quantite'].toString();
      prixController.text = ressourceprojetDetails['prix'].toString();
      selectedRessource = ressourceprojetDetails['ressource'].toString();
      selectedProjet = ressourceprojetDetails['projet'].toString();
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

  Future<void> fetchProjets() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllProjets'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('projets')) {
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

  Future<void> updateRessourceprojet() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateResourceProject?id=${widget.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': widget.id,
        'quantite': quantiteController.text,
        'prix': prixController.text,
        'ressource': selectedRessource,
        'projet': selectedProjet,
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
            'assets/bill 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier la Facture'),
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
              DropdownButton<String>(
                value: selectedProjet,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedProjet = newValue;
                  });
                },
                items: projets.map<DropdownMenuItem<String>>((projet) {
                  return DropdownMenuItem<String>(
                    key: Key(projet['id'].toString()), // Provide a unique key
                    value: projet['id'].toString(),
                    child: Text(projet['titre']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Projet'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateRessourceprojet();
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
