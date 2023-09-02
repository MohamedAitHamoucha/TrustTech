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
  Map<String, dynamic> collaborateurDetails = {};

  @override
  void initState() {
    super.initState();
    fetchCollaborateurDetails();
  }

  Future<void> fetchCollaborateurDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getCollaborateursDetails?nom=${widget.nom}'),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody != null && responseBody.containsKey('collaborateur')) {
        setState(() {
          collaborateurDetails = responseBody['collaborateur'];
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
            'assets/collaboration 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Details Collaborateur'),
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
            child: DetailsList(collaborateurDetails: collaborateurDetails),
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatelessWidget {
  final Map<String, dynamic> collaborateurDetails;

  DetailsList({required this.collaborateurDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: collaborateurDetails.length,
      itemBuilder: (context, index) {
        String label = collaborateurDetails.keys.elementAt(index);
        String value = collaborateurDetails[label].toString();

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
