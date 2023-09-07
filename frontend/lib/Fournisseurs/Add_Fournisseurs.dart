// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddFournisseurApp extends StatelessWidget {
  final String serverURL;

  MyAddFournisseurApp({required this.serverURL});

  TextEditingController nomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController societeController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  Future<void> addFournisseur(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$serverURL/api/addFournisseur'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': nomController.text,
        'email': emailController.text,
        'telephone': telephoneController.text,
        'societe': societeController.text,
        'adresse': adresseController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Fournisseur added successfully
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
            'assets/delivery-box 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter Fournisseur'),
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'email'),
              ),
              TextField(
                controller: telephoneController,
                decoration: InputDecoration(labelText: 'telephone'),
              ),
              TextField(
                controller: societeController,
                decoration: InputDecoration(labelText: 'societe'),
              ),
              TextField(
                controller: adresseController,
                decoration: InputDecoration(labelText: 'adresse'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addFournisseur(context);
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