import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DetailsPage(),
  ));
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 0, 230, 1),
        leading: IconButton(
          icon: Image.asset(
            'assets/project-management 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Détails Projets'),
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
            child: DetailsTable(),
          ),
        ),
      ),
    );
  }
}

class DetailsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
      },
      children: [
        buildTableRow("ID", "123"),
        buildTableRow("titre", "tit"),
        buildTableRow("budget", "102245DH"),
        buildTableRow("date_debut", "10/02/2023"),
        buildTableRow("date_fin_estimee", "10/02/2024"),
        buildTableRow("date_fin", "10/05/2024"),
        buildTableRow("etat_progression	", "proge"),
        buildTableRow("type_projet	", "type11"),
        buildTableRow("client	", "Client11"),
        buildTableRow("chef_projet	", "chef_projet11"),

      ],
    );
  }

  TableRow buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
