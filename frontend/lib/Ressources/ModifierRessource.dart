import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifierRessource extends StatefulWidget {
  final String type;
  final String serverURL;

  ModifierRessource({required this.type, required this.serverURL});

  @override
  _ModifierRessourceState createState() => _ModifierRessourceState();
}

class _ModifierRessourceState extends State<ModifierRessource> {
  TextEditingController uniteController = TextEditingController();
  String selectedFournisseur = ''; // To store the selected fournisseur

  List<dynamic> fournisseurs = []; // Store the list of fournisseurs

  @override
  void initState() {
    super.initState();
    fetchRessourceDetails();
    fetchFournisseurs();
  }

  Future<void> fetchRessourceDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getResourceDetails?type=${widget.type}'),
    );

    if (response.statusCode == 200) {
      final resourceDetails = json.decode(response.body)['resource'];
      uniteController.text = resourceDetails['unite'];
      selectedFournisseur = resourceDetails['fournisseur'].toString();
    } else {
      // Handle error
    }
  }

  Future<void> fetchFournisseurs() async {
    final response = await http.get(Uri.parse('${widget.serverURL}/api/getAllFournisseurs'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('fournisseurs')) {
        setState(() {
          fournisseurs = responseBody['fournisseurs'];
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> updateRessource() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateResource'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': widget.type,
        'unite': uniteController.text,
        'fournisseur': selectedFournisseur,
      }),
    );

    if (response.statusCode == 200) {
      // Ressource updated successfully
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
            'assets/ressources.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier la Ressource'),
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
                controller: uniteController,
                decoration: InputDecoration(labelText: 'Unité'),
              ),
              DropdownButton<String>(
                value: selectedFournisseur,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFournisseur = newValue!;
                  });
                },
                items: fournisseurs.map<DropdownMenuItem<String>>((fournisseur) {
                  return DropdownMenuItem<String>(
                    key: Key(fournisseur['id'].toString()), // Provide a unique key
                    value: fournisseur['id'].toString(),
                    child: Text(fournisseur['nom']),
                  );
                }).toList(),
                hint: Text('Sélectionner un fournisseur'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateRessource();
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