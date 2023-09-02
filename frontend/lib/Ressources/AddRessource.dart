import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddRessourceApp extends StatefulWidget {
  final String serverURL;
  final List<dynamic> fournisseurs; // List of fournisseurs

  MyAddRessourceApp({required this.serverURL, required this.fournisseurs});

  @override
  _MyAddRessourceAppState createState() => _MyAddRessourceAppState();
}

class _MyAddRessourceAppState extends State<MyAddRessourceApp> {
  GlobalKey<_MyAddRessourceAppState> scaffoldKey = GlobalKey();

  TextEditingController typeController = TextEditingController();
  TextEditingController uniteController = TextEditingController();
  String selectedFournisseur = ''; // To store the selected fournisseur

  Future<void> addRessource(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addRessource'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': typeController.text,
        'unite': uniteController.text,
        'fournisseur': selectedFournisseur, // Use the selected fournisseur
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
              DropdownButton<String>(
                value: selectedFournisseur,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFournisseur = newValue!;
                  });
                },
                items: widget.fournisseurs.map<DropdownMenuItem<String>>((fournisseur) {
                  return DropdownMenuItem<String>(
                    value: fournisseur['id'].toString(), // Use the fournisseur's ID as the value
                    child: Text(fournisseur['nom']), // Display the fournisseur's nom
                  );
                }).toList(),
                hint: Text('Sélectionner un fournisseur'), // Initial hint text
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextField(
                controller: uniteController,
                decoration: InputDecoration(labelText: 'Unité'),
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