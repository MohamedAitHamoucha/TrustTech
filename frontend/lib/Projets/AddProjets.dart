import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MyAddProjetApp extends StatefulWidget {
  final String serverURL;

  MyAddProjetApp({required this.serverURL});

  @override
  _MyAddProjetAppState createState() => _MyAddProjetAppState();
}

class _MyAddProjetAppState extends State<MyAddProjetApp> {
  GlobalKey<_MyAddProjetAppState> scaffoldKey = GlobalKey();

  TextEditingController titreController = TextEditingController();
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

    fetchEtatprogressions();
    fetchTypeprojets();
    fetchClients();
    fetchChefprojets();
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

  Future<void> addProjet(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${widget.serverURL}/api/addProjet'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'titre': titreController.text,
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

    if (response.statusCode == 201) {
      Navigator.pop(context, true); // Pop the page with a success flag
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
        title: Text('Ajouter un Projet'),
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
                controller: titreController,
                decoration: InputDecoration(labelText: 'Titre'),
              ),
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
                  addProjet(context);
                },
                child: Text('Ajouter'),
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
