import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyAdminApp());
}

class MyAdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RegisterScreen(),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedUserRole = 'Admin'; // Default value

  Future<void> _register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String userType = _selectedUserRole;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password are required.')),
      );
      return;
    }

    try {
      var serverURL = _getServerURL();
      var apiEndpoint = '/api/register';

      var url = Uri.parse('$serverURL$apiEndpoint');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nom": username,
          "type": userType,
          "mot_de_passe": password,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registration failed')),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  String _getServerURL() {
    return 'https://b809-105-158-110-218.ngrok-free.app';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20.0,
          top: 30.0,
          child: Image.asset(
            'assets/TrustTechLogo.png',
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: -30.0,
          right: 0.0,
          child: Container(
            child: Image.asset(
              'assets/circle.PNG',
              width: 150.0,
              height: 200.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 27.0),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 33.0),
                  child: Text(
                    'Veuillez vous inscrire pour continuer',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 340,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Nom d'utilisateur",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 340,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: DropdownButton<String>(
                  value: _selectedUserRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUserRole = newValue!;
                    });
                  },
                  items: <String>['Admin', 'Chef de projet']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  underline: Container(),
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 340,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 33.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 0, 230, 1),
                      minimumSize: Size(170, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _register,
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: Image.asset('assets/down.png'),
        ),
      ],
    );
  }
}
