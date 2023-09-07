import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifierTache extends StatefulWidget {
  final String nom;
  final String serverURL;

  ModifierTache({required this.nom, required this.serverURL});

  @override
  _ModifierTacheState createState() => _ModifierTacheState();
}

class _ModifierTacheState extends State<ModifierTache> {
  String? selectedCollaborateur;
  String? selectedProjet;

  List<dynamic> collaborateurs = [];
  List<dynamic> projets = [];

  @override
  void initState() {
    super.initState();
    fetchTacheDetails();
    fetchcollaborateurs();
    fetchprojets();
  }

  Future<void> fetchTacheDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getTacheDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final tacheDetails = json.decode(response.body)['tache'];
      selectedCollaborateur = tacheDetails['collaborateur'].toString();
      selectedProjet = tacheDetails['projet'].toString();
    } else {
      // Handle error
    }
  }

  Future<void> fetchcollaborateurs() async {
    final response = await http
        .get(Uri.parse('${widget.serverURL}/api/getAllCollaborateurs'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('collaborateurs')) {
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

  Future<void> updateTache() async {
    try {
      final response = await http.put(
        Uri.parse('${widget.serverURL}/api/updateTache?nom=${widget.nom}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nom': widget.nom,
          'collaborateur': selectedCollaborateur,
          'projet': selectedProjet,
        }),
      );

      if (response.statusCode == 200) {
        // Tache updated successfully
        Navigator.pop(context);
      } else if (response.statusCode == 404) {
        // Tache not found
        print('Tache not found');
      } else {
        // Handle other errors
        print('Error updating Tache. Status Code: ${response.statusCode}');
        print('Error Response Body: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error updating Tache: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Modifier la Tache'),
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
                    key: Key(
                        collaborateur['id'].toString()), // Provide a unique key
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
                  updateTache();
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
