import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsCategorie extends StatefulWidget {
  final String nom;
  final String serverURL;

  DetailsCategorie({required this.nom, required this.serverURL});

  @override
  _DetailsCategorieState createState() => _DetailsCategorieState();
}

class _DetailsCategorieState extends State<DetailsCategorie> {
  Map<String, dynamic> categorieDetails = {};

  @override
  void initState() {
    super.initState();
    fetchCategorieDetails();
  }

  Future<void> fetchCategorieDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getCategorieDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        categorieDetails = json.decode(response.body)['category'];
      });
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
            'assets/categories.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Détails Catégorie'),
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
          child: Center(
            child: DetailsList(categorieDetails: categorieDetails),
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatelessWidget {
  final Map<String, dynamic> categorieDetails;

  DetailsList({required this.categorieDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categorieDetails.length,
      itemBuilder: (context, index) {
        String label = categorieDetails.keys.elementAt(index);
        String value = categorieDetails[label].toString();

        return ListTile(
          title: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(value),
        );
      },
    );
  }
}