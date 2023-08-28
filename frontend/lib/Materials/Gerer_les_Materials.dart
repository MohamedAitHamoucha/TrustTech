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
        title: Text('Gérer le Materials'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle search button press
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Options')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('Item 1')),
                DataCell(Text('1')),
                DataCell(Text('\$10.00')),
                DataCell(buildOptionsButton()),
              ]),
              DataRow(cells: [
                DataCell(Text('Item 2')),
                DataCell(Text('2')),
                DataCell(Text('\$20.00')),
                DataCell(buildOptionsButton()),
              ]),
              // Add more rows as needed
            ],
          ),
          Center(
          ),
        ],
      ),
    );
  }

  Widget buildOptionsButton() {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.details),
            title: Text('Details'),
            onTap: () {
              // Handle details option
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Add'),
            onTap: () {
              // Handle add option
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () {
              // Handle delete option
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.update),
            title: Text('Update'),
            onTap: () {
              // Handle update option
            },
          ),
        ),
      ],
    );
  }
}
