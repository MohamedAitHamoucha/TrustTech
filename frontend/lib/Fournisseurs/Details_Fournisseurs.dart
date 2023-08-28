import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  final String nom;
  final String serverURL;

  DetailsPage({required this.nom, required this.serverURL});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic> fournisseurDetails = {};

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
      setState(() {
        fournisseurDetails = json.decode(response.body)['fournisseur'];
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
            'assets/delivery-box 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Détails Fournisseur'),
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
            child: DetailsList(fournisseurDetails: fournisseurDetails),
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatelessWidget {
  final Map<String, dynamic> fournisseurDetails;

  DetailsList({required this.fournisseurDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fournisseurDetails.length,
      itemBuilder: (context, index) {
        String label = fournisseurDetails.keys.elementAt(index);
        String value = fournisseurDetails[label].toString();

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