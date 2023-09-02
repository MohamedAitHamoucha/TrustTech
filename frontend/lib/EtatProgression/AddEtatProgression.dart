import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAddEtatProgressiontApp extends StatelessWidget {
  final String serverURL;

  MyAddEtatProgressiontApp({required this.serverURL});

  TextEditingController libelleController = TextEditingController();
  TextEditingController ordreController = TextEditingController();

  Future<void> addEtatProgression(BuildContext context) async {
    final response = await http.post(
      Uri.parse('$serverURL/api/addEtatProgression'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'libelle': libelleController.text,
        'ordre': ordreController.text,
      }),
    );

    if (response.statusCode == 201) {
      // EtatProgression added successfully
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
            'assets/etat.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter EtatProgression'),
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
                controller: libelleController,
                decoration: InputDecoration(labelText: 'Libelle'),
              ),
              TextField(
                controller: ordreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Ordre'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addEtatProgression(context);
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
