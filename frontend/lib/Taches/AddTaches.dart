import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddTacheApp extends StatefulWidget {
  final String serverURL;

  MyAddTacheApp({required this.serverURL});

  @override
  _MyAddTacheAppState createState() => _MyAddTacheAppState();
}

class _MyAddTacheAppState extends State<MyAddTacheApp> {
  GlobalKey<_MyAddTacheAppState> scaffoldKey = GlobalKey();

  TextEditingController nomController = TextEditingController();

  String? selectedCollaborateur;
  String? selectedProjet;
  

  List<dynamic> collaborateurs = [];
  List<dynamic> projets = [];
  
  @override
  void initState() {
    super.initState();

    fetchcollaborateurs();
    fetchprojets();
  }

  Future<void> fetchcollaborateurs() async {
    final response = await http
        .get(Uri.parse('${widget.serverURL}/api/getAllCollaborateurs'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null &&
          responseBody.containsKey('collaborateurs')) {
        setState(() {
          collaborateurs = responseBody['collaborateurs'];
          if (collaborateurs.isNotEmpty) {
            selectedCollaborateur = collaborateurs[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchprojets() async {
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

  Future<void> addTache(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addTache'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': nomController.text,
        'collaborateur': selectedCollaborateur,
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
            'assets/taches.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter une Tache'),
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
              DropdownButton<String>(
                value: selectedCollaborateur,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCollaborateur = newValue;
                  });
                },
                items: collaborateurs
                    .map<DropdownMenuItem<String>>((collaborateur) {
                  return DropdownMenuItem<String>(
                    key: Key(collaborateur['id']
                        .toString()), // Provide a unique key
                    value: collaborateur['id'].toString(),
                    child: Text(collaborateur['nom']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Collaborateur'),
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
                    key: Key(
                        projet['id'].toString()), // Provide a unique key
                    value: projet['id'].toString(),
                    child: Text(projet['titre']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Projet'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addTache(context);
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