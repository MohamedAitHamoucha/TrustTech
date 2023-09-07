// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddCategorieApp extends StatelessWidget {
  final String serverURL;

  MyAddCategorieApp({required this.serverURL});

  TextEditingController nomController = TextEditingController();

  Future<void> addCategorie(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$serverURL/api/addCategorie'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': nomController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Categorie added successfully
      Navigator.pop(context, true); // Pop the page with a success flag
    } else {
      // Handle error
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
        title: Text('Ajouter Categorie'),
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
                decoration: InputDecoration(labelText: 'nom'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addCategorie(context);
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