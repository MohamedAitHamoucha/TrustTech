import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ModifierEtatProgressions extends StatefulWidget {
  final String libelle;
  final String serverURL;

  ModifierEtatProgressions({required this.libelle, required this.serverURL});

  @override
  _ModifierEtatProgressionsState createState() => _ModifierEtatProgressionsState();
}

class _ModifierEtatProgressionsState extends State<ModifierEtatProgressions> {
  TextEditingController ordreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEtatProgressionDetails();
  }

  Future<void> fetchEtatProgressionDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getEtatProgressionDetails?libelle=${widget.libelle}'),
    );

    if (response.statusCode == 200) {
      final etatprogressionDetails = json.decode(response.body)['etatProgression'];
      ordreController.text = etatprogressionDetails['ordre'].toString();
    } else {
      // Handle error
    }
  }

  Future<void> updateEtatProgression() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateEtatProgression'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'libelle': widget.libelle,
        'ordre': ordreController.text,
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
            'assets/etat.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text("Modifier l'Etat de Progression"),
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
                controller: ordreController,
                decoration: InputDecoration(labelText: 'ordre'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateEtatProgression();
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