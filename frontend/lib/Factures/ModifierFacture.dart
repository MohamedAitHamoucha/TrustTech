import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ModifierFacture extends StatefulWidget {
  final String reference;
  final String serverURL;

  ModifierFacture({required this.reference, required this.serverURL});

  @override
  _ModifierFactureState createState() => _ModifierFactureState();
}

class _ModifierFactureState extends State<ModifierFacture> {
  TextEditingController titreController = TextEditingController();
  TextEditingController montantController = TextEditingController();
  TextEditingController dateemissionController = TextEditingController();
  TextEditingController dateecheanceController = TextEditingController();

  String? selectedProjet;

  List<dynamic> projets = [];

  @override
  void initState() {
    super.initState();
    fetchProjets();
    fetchFactureDetails();
  }

  Future<void> fetchFactureDetails() async {
    final response = await http.get(
      Uri.parse(
          '${widget.serverURL}/api/getFactureDetails?reference=${widget.reference}'),
    );

    if (response.statusCode == 200) {
      final factureDetails = json.decode(response.body)['facture'];
      titreController.text = factureDetails['titre'];
      montantController.text = factureDetails['montant'].toString();
      dateemissionController.text = factureDetails['date_emission'];
      dateecheanceController.text = factureDetails['date_echeance'];
      selectedProjet = factureDetails['projet'].toString();

      // Parse date fields as DateTime objects
      final dateFormat = DateFormat('yyyy-MM-dd');
      if (factureDetails['date_emission'] != null) {
        dateemissionController.text =
            dateFormat.format(DateTime.parse(factureDetails['date_emission']));
      }
      if (factureDetails['date_echeance'] != null) {
        dateecheanceController.text =
            dateFormat.format(DateTime.parse(factureDetails['date_echeance']));
      }
    } else {
      // Handle error
    }
  }

  Future<void> fetchProjets() async {
    final response =
        await http.get(Uri.parse('${widget.serverURL}/api/getAllProjets'));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('projets')) {
        setState(() {
          projets = responseBody['projets'];
          if (projets.isNotEmpty) {
            selectedProjet = projets[0]['id'].toString();
          }
        });
      }
    } else {
      // Handle error
    }
  }

  Future<void> updateFacture() async {
    final response = await http.put(
      Uri.parse('${widget.serverURL}/api/updateFacture'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'reference': widget.reference,
        'titre': titreController.text,
        'montant': montantController.text,
        'date_emission': dateemissionController.text,
        'date_echeance': dateecheanceController.text,
        'projet': selectedProjet,
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
            'assets/bill 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Modifier la Facture'),
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
                controller: montantController,
                decoration: InputDecoration(labelText: 'Montant'),
              ),
              buildDateField(
                controller: dateemissionController,
                labelText: 'Date Emission',
              ),
              buildDateField(
                controller: dateecheanceController,
                labelText: 'Date Echeance',
              ),
              DropdownButton<String>(
                value: selectedProjet,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedProjet = newValue;
                  });
                },
                items: projets.map<DropdownMenuItem<String>>((projet) {
                  return DropdownMenuItem<String>(
                    key: Key(projet['id'].toString()), // Provide a unique key
                    value: projet['id'].toString(),
                    child: Text(projet['titre']),
                  );
                }).toList(),
                hint: Text('Sélectionner un Projet'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateFacture();
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
