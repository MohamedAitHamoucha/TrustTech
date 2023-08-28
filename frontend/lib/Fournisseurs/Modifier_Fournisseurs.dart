import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ModifierFournisseurs extends StatefulWidget {
  final String nom;
  final String serverURL;

  ModifierFournisseurs({required this.nom, required this.serverURL});

  @override
  _ModifierFournisseursState createState() => _ModifierFournisseursState();
}

class _ModifierFournisseursState extends State<ModifierFournisseurs> {
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController societeController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFournisseurDetails();
  }

  Future<void> fetchFournisseurDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getFournisseurDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final fournisseurDetails = json.decode(response.body)['fournisseur'];
      emailController.text = fournisseurDetails['email'];
      telephoneController.text = fournisseurDetails['telephone'];
      societeController.text = fournisseurDetails['societe'];
      adresseController.text = fournisseurDetails['adresse'];
    } else {
      // Handle error
    }
  }

  Future<void> updateFournisseur() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateFournisseur'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': widget.nom,
        'email': emailController.text,
        'telephone': telephoneController.text,
        'societe': societeController.text,
        'adresse': adresseController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Fournisseur updated successfully
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
            'assets/delivery-box 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier Fournisseur'),
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
                  updateFournisseur();
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