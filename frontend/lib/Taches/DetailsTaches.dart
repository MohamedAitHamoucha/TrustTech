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
  Map<String, dynamic> tachetDetails = {};

  @override
  void initState() {
    super.initState();
    fetchTacheDetails();
  }

  Future<void> fetchTacheDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getTacheDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('tache')) {
        setState(() {
          tachetDetails = responseBody['tache'];
        });
      } else {
        // Handle error: The response body is not as expected
      }
    } else {
      // Handle error: The API response status code is not 200
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 0, 230, 1),
        leading: IconButton(
          icon: Image.asset(
            'assets/taches.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Details de Tache'),
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
            child: DetailsList(tachetDetails: tachetDetails),
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatelessWidget {
  final Map<String, dynamic> tachetDetails;

  DetailsList({required this.tachetDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tachetDetails.length,
      itemBuilder: (context, index) {
        String label = tachetDetails.keys.elementAt(index);
        String value = tachetDetails[label].toString();

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