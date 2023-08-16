import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  String _getServerURL() {
    return Constants.baseServerUrl;
  }

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Username and password are required.';
      });
      return;
    }

    var serverURL = _getServerURL();
    var apiEndpoint = '/api/login';

    var url = Uri.parse('$serverURL$apiEndpoint');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": username,
        "mot_de_passe": password,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print('Decoded response body: $responseBody');

      if (responseBody.containsKey('user')) {
        String userType = responseBody['user']['type'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomeApp(
              username: username,
              userType: userType,
            ),
          ),
        );
      } else {
        setState(() {
          _message =
              'Login failed. Response does not contain user information.';
        });
      }
    } else {
      setState(() {
        _message = 'Login failed. Please check your credentials.';
      });
    }
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
                    'Se Connecter',
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
                    'Veuillez vous connecter pour continuer',
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
                    onPressed: _login,
                    child: Text(
                      'Se Connecter',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.startsWith('Login successful')
                        ? Colors.green
                        : Colors.red,
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
