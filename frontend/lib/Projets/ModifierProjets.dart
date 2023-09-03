import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ModifierProjet extends StatefulWidget {
  final String titre;
  final String serverURL;

  ModifierProjet({required this.titre, required this.serverURL});

  @override
  _ModifierProjetState createState() => _ModifierProjetState();
}

class _ModifierProjetState extends State<ModifierProjet> {
  TextEditingController budgetController = TextEditingController();
  TextEditingController datedebutController = TextEditingController();
  TextEditingController datefinestimeeController = TextEditingController();
  TextEditingController datefinController = TextEditingController();

  String? selectedEtatprogression;
  String? selectedTypeprojet;
  String? selectedClient;
  String? selectedChefprojet;

  List<dynamic> etatprogressions = [];
  List<dynamic> typeprojets = [];
  List<dynamic> clients = [];
  List<dynamic> chefprojets = [];

  @override
  void initState() {
    super.initState();
    fetchProjetDetails();
    fetchEtatprogressions();
    fetchTypeprojets();
    fetchClients();
    fetchChefprojets();
  }

  Future<void> fetchProjetDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getProjetDetails?titre=${widget.titre}'),
    );

    if (response.statusCode == 200) {
      final projetDetails = json.decode(response.body)['projet'];
      budgetController.text = projetDetails['budget'];
      datedebutController.text = projetDetails['date_debut'];
      datefinestimeeController.text = projetDetails['date_fin_estimee'];
      datefinController.text = projetDetails['date_fin'];
      selectedEtatprogression = projetDetails['etat_progression'].toString();
      selectedTypeprojet = projetDetails['type_projet'].toString();
      selectedClient = projetDetails['client'].toString();
      selectedChefprojet = projetDetails['chef_projet'].toString();

      // Parse date fields as DateTime objects
      final dateFormat = DateFormat('yyyy-MM-dd');
      if (projetDetails['date_debut'] != null) {
        datedebutController.text =
            dateFormat.format(DateTime.parse(projetDetails['date_debut']));
      }
      if (projetDetails['date_fin_estimee'] != null) {
        datefinestimeeController.text = dateFormat
            .format(DateTime.parse(projetDetails['date_fin_estimee']));
      }
      if (projetDetails['date_fin'] != null) {
        datefinController.text =
            dateFormat.format(DateTime.parse(projetDetails['date_fin']));
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchEtatprogressions() async {
    final response = await http
        .get(Uri.parse('${widget.serverURL}/api/getAllEtatProgression'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null &&
          responseBody.containsKey('etatProgressions')) {
        setState(() {
          etatprogressions = responseBody['etatProgressions'];
          if (etatprogressions.isNotEmpty) {
            selectedEtatprogression = etatprogressions[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchTypeprojets() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllTypeProjets'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('typeProjets')) {
        setState(() {
          typeprojets = responseBody['typeProjets'];
          if (typeprojets.isNotEmpty) {
            selectedTypeprojet = typeprojets[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchClients() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllClients'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('Clients')) {
        setState(() {
          clients = responseBody['Clients'];
          if (clients.isNotEmpty) {
            selectedClient = clients[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchChefprojets() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllUsers'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('users')) {
        setState(() {
          chefprojets = responseBody['users'];
          if (chefprojets.isNotEmpty) {
            selectedChefprojet = chefprojets[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> updateProjet() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateProjet'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'titre': widget.titre,
        'budget': budgetController.text,
        'date_debut': datedebutController.text,
        'date_fin_estimee': datefinestimeeController.text,
        'date_fin': datefinController.text,
        'etat_progression': selectedEtatprogression,
        'type_projet': selectedTypeprojet,
        'client': selectedClient,
        'chef_projet': selectedChefprojet,
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
            'assets/projet.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier le Projet'),
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
                controller: budgetController,
                decoration: InputDecoration(labelText: 'Budget'),
              ),
              buildDateField(
                controller: datedebutController,
                labelText: 'Date Debut',
              ),
              buildDateField(
                controller: datefinestimeeController,
                labelText: 'Date Fin Estimee',
              ),
              buildDateField(
                controller: datefinController,
                labelText: 'Date Fin',
              ),
              DropdownButton<String>(
                value: selectedEtatprogression,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEtatprogression = newValue;
                  });
                },
                items: etatprogressions
                    .map<DropdownMenuItem<String>>((etatprogression) {
                  return DropdownMenuItem<String>(
                    key: Key(etatprogression['id']
                        .toString()), // Provide a unique key
                    value: etatprogression['id'].toString(),
                    child: Text(etatprogression['libelle']),
                  );
                }).toList(),
                hint: Text('Sélectionner une Etat de Progression'),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedTypeprojet,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTypeprojet = newValue;
                  });
                },
                items: typeprojets.map<DropdownMenuItem<String>>((typeprojet) {
                  return DropdownMenuItem<String>(
                    key: Key(
                        typeprojet['id'].toString()), // Provide a unique key
                    value: typeprojet['id'].toString(),
                    child: Text(typeprojet['type']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Type de Projet'),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedClient,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClient = newValue;
                  });
                },
                items: clients.map<DropdownMenuItem<String>>((client) {
                  return DropdownMenuItem<String>(
                    key: Key(client['id'].toString()), // Provide a unique key
                    value: client['id'].toString(),
                    child: Text(client['nom']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Client'),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedChefprojet,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedChefprojet = newValue;
                  });
                },
                items: chefprojets.map<DropdownMenuItem<String>>((chefprojet) {
                  return DropdownMenuItem<String>(
                    key: Key(
                        chefprojet['id'].toString()), // Provide a unique key
                    value: chefprojet['id'].toString(),
                    child: Text(chefprojet['nom']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Chef de Projet'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateProjet();
                },
                child: Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Sélectionner une date',
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (selectedDate != null) {
              setState(() {
                controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
              });
            }
          },
        ),
      ),
    );
  }
}
