import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModifierCategorie extends StatefulWidget {
  final String nom;
  final String serverURL;

  ModifierCategorie({required this.nom, required this.serverURL});

  @override
  _ModifierCategorieState createState() => _ModifierCategorieState();
}

class _ModifierCategorieState extends State<ModifierCategorie> {
  TextEditingController nomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategorieDetails();
  }

  Future<void> fetchCategorieDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getCategorieDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final categorieDetails = json.decode(response.body)['category'];
      nomController.text = categorieDetails['nom'];
    } else {
      // Handle error
    }
  }

  Future<void> updateCategorie() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateCategorie'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': widget.nom,
        'new_nom': nomController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Category updated successfully
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
            'assets/categories.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier Catégorie'),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateCategorie();
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