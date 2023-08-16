import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
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
        title: Text('Ajouter Projets'),
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
                decoration: InputDecoration(labelText: 'ID'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'titre'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'budget'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'date_debut'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'date_fin_estimee'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'date_fin'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'etat_progression'),
              ),TextField(
                decoration: InputDecoration(labelText: 'type_projet'),
              ),TextField(
                decoration: InputDecoration(labelText: 'client'),
              ),TextField(
                decoration: InputDecoration(labelText: 'chef_projet'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the button press for submitting the form
                },
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
