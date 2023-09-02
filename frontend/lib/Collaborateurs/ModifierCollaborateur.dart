import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifierCollaborateur extends StatefulWidget {
  final String nom;
  final String serverURL;

  ModifierCollaborateur({required this.nom, required this.serverURL});

  @override
  _ModifierCollaborateurState createState() => _ModifierCollaborateurState();
}

class _ModifierCollaborateurState extends State<ModifierCollaborateur> {
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController titreController = TextEditingController();
  String? selectedRessource;

  List<dynamic> ressources = [];

  @override
  void initState() {
    super.initState();
    fetchCollaborateurDetails();
    fetchRessources();
  }

  Future<void> fetchCollaborateurDetails() async {
    final response = await http.get(
      Uri.parse(
          '${widget.serverURL}/api/getCollaborateursDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final collaborateurDetails = json.decode(response.body)['collaborateur'];
      emailController.text = collaborateurDetails['email'];
      telephoneController.text = collaborateurDetails['telephone'];
      titreController.text = collaborateurDetails['titre'];
      selectedRessource = collaborateurDetails['resource'].toString();
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

  Future<void> updateCollaborateur() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateCollaborateurs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': widget.nom,
        'email': emailController.text,
        'telephone': telephoneController.text,
        'titre': titreController.text,
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
            'assets/collaboration 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier la Ressource'),
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
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: telephoneController,
                decoration: InputDecoration(labelText: 'Telephone'),
              ),
              TextField(
                controller: titreController,
                decoration: InputDecoration(labelText: 'Titre'),
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
                hint: Text('Sélectionner une ressource'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateCollaborateur();
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
