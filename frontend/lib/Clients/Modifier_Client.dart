import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ModifierClients extends StatefulWidget {
  final String nom;
  final String serverURL;

  ModifierClients({required this.nom, required this.serverURL});

  @override
  _ModifierClientsState createState() => _ModifierClientsState();
}

class _ModifierClientsState extends State<ModifierClients> {
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController societeController = TextEditingController();
  TextEditingController adresseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClientDetails();
  }

  Future<void> fetchClientDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getClientDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final clientDetails = json.decode(response.body)['Client'];
      emailController.text = clientDetails['email'];
      telephoneController.text = clientDetails['telephone'];
      societeController.text = clientDetails['societe'];
      adresseController.text = clientDetails['adresse'];
    } else {
      // Handle error
    }
  }

  Future<void> updateClient() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateClient'),
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
            'assets/customer 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier le Client'),
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
                  updateClient();
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