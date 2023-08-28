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
            'assets/equipment 1.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle the onPressed event if needed
          },
        ),
        title: Text('Ajouter Material'),
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
                decoration: InputDecoration(labelText: 'reference'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'quantite'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'prix_achat'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'categorie'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'ressource'),
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
