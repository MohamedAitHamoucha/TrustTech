// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddTypeProjetApp extends StatelessWidget {
  final String serverURL;

  MyAddTypeProjetApp({required this.serverURL});

  TextEditingController typeController = TextEditingController();

  Future<void> addTypeProjet(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$serverURL/api/addTypeProjet'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': typeController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
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
            'assets/typeprojet.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter un Type de Projet'),
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
                controller: typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addTypeProjet(context);
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