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
            'assets/delivery-box 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Supprimer Fournisseur'),
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
                decoration: InputDecoration(labelText: 'nom'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'email'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'telephone'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'societe'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'adresse'),
              ),
              
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the button press for submitting the form
                },
                child: Text('Supprimer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
