import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddCollaborateurApp extends StatefulWidget {
  final String serverURL;

  MyAddCollaborateurApp({required this.serverURL});

  @override
  _MyAddCollaborateurAppState createState() => _MyAddCollaborateurAppState();
}

class _MyAddCollaborateurAppState extends State<MyAddCollaborateurApp> {
  GlobalKey<_MyAddCollaborateurAppState> scaffoldKey = GlobalKey();

  TextEditingController nomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController titreController = TextEditingController();
  String? selectedRessource;

  List<dynamic> ressources = [];

  @override
  void initState() {
    super.initState();
    fetchRessources();
  }

  Future<void> fetchRessources() async {
    final response = await http.get(Uri.parse('${widget.serverURL}/api/getAllResources'));

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

  Future<void> addCollaborateur(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addCollaborateurs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': nomController.text,
        'email': emailController.text,
        'telephone': telephoneController.text,
        'titre': titreController.text,
        'resource': selectedRessource,
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
            'assets/collaboration 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter Collaborateur'),
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
                    key: Key(ressource['id'].toString()), // Provide a unique key
                    value: ressource['id'].toString(),
                    child: Text(ressource['type']),
                  );
                }).toList(),
                hint: Text('Sélectionner une ressource'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addCollaborateur(context);
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