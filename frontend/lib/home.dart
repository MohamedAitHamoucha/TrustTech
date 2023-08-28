import 'package:flutter/material.dart';
import 'admin.dart';
import 'Fournisseurs/Gérer_les_Fournisseurs.dart';
import 'Clients/Gerer_les_Clients.dart';

class MyHomeApp extends StatelessWidget {
  final String username;
  final String userType;

  MyHomeApp({required this.username, required this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 0, 230, 1),
          actions: [
            userType == 'Chef de projet'
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Logout') {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'Logout', child: Text('Logout')),
                    ],
                  )
                : userType == 'Admin'
                    ? PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Logout') {
                            Navigator.pushReplacementNamed(context, '/');
                          } else if (value == 'New Account') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAdminApp(),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'Logout', child: Text('Logout')),
                          PopupMenuItem(
                              value: 'New Account', child: Text('New Account')),
                        ],
                      )
                    : SizedBox.shrink(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: Color.fromRGBO(255, 0, 230, 1),
                      height: 150.0,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 65, left: 20),
                              child: Text(
                                username,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 3, left: 20),
                              child: Text(
                                userType,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55.0,
                    left: 310.0,
                    child: Image.asset('assets/user 1.png'),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 127),
                        child: Image.asset('assets/bubble.png'),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonWithImageAndText('assets/collaboration 1.png',
                      'Gérer les\nCollaborateurs', context),
                  _buildButtonWithImageAndText(
                      'assets/project-management 1.png',
                      'Gérer les\nProjets',
                      context),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonWithImageAndText(
                      'assets/customer 1.png', 'Gérer les\nClients', context),
                  _buildButtonWithImageAndText('assets/delivery-box 1.png',
                      'Gérer les\nFournisseurs', context),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonWithImageAndText(
                      'assets/equipment 1.png', 'Gérer le\nMateriel', context),
                  _buildButtonWithImageAndText(
                      'assets/bill 1.png', 'Gerer les\nFacteures', context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithImageAndText(
      String imagePath, String buttonText, BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.black),
          ),
          padding: EdgeInsets.all(10.0),
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        onPressed: () {
          if (buttonText == 'Gérer les\nFournisseurs') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyFournisseurApp(),
              ),
            );
          }else if (buttonText == 'Gérer les\nClients'){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyClientApp(),
              ),
            );
          }
           else {
            print('Button pressed: $buttonText');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 60,
              height: 60,
            ),
            SizedBox(height: 15),
            Text(
              buttonText,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
