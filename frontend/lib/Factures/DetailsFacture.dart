import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsPageFacture extends StatefulWidget {
  final String reference;
  final String serverURL;

  DetailsPageFacture({required this.reference, required this.serverURL});

  @override
  _DetailsPageFactureState createState() => _DetailsPageFactureState();
}

class _DetailsPageFactureState extends State<DetailsPageFacture> {
  Map<String, dynamic> facturesDetails = {};

  @override
  void initState() {
    super.initState();
    fetchFacturesDetails();
  }

  Future<void> fetchFacturesDetails() async {
    final response = await http.get(
      Uri.parse('${widget.serverURL}/api/getFactureDetails?reference=${widget.reference}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        facturesDetails = json.decode(response.body)['facture'];
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
            'assets/bill 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Détails Factures'),
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
            child: DetailsList(facturesDetails: facturesDetails),
          ),
        ),
      ),
    );
  }
}

class DetailsList extends StatelessWidget {
  final Map<String, dynamic> facturesDetails;

  DetailsList({required this.facturesDetails});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: facturesDetails.length,
      itemBuilder: (context, index) {
        String label = facturesDetails.keys.elementAt(index);
        String value = facturesDetails[label].toString();

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