import 'package:bluff/screens/homescreen.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //if username and passoword doesn't match this is set to true
  bool incorrect = false;

  //for displaying message "Something went wrong"
  bool somethingWentWorng = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight = MediaQuery.of(context).size.height.roundToDouble();
    return Scaffold(
      body: Container(
        width: double.infinity,
        // color: Colors.amber,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(
                "Welcome,",
                style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              child: Text(
                "Login to your account",
                style: TextStyle(
                    fontSize: screenWidth * 0.07, color: Colors.grey[700]),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(top: 25),
                // color: Colors.redAccent,
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.08,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Username";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.08,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Password";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.05,
                        child: ElevatedButton(
                            onPressed: () => {
                                  if (_formKey.currentState.validate())
                                    {
                                      httpPost(usernameController.text,
                                          passwordController.text)
                                    }
                                },
                            child: Text("Submit")))
                  ],
                ),
              ),
            ),
            if (incorrect)
              Center(
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Username and password doesn't match.",
                      style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            if (somethingWentWorng)
              Center(
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Oops! something went wrong.",
                      style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
              ),
          ],
        ),
      ),
    );
  }

  void httpPost(String username, String password) async {
    var url = Uri.parse('http://localhost:3000/login');
    var response = await http
        .post(url, body: {'username': username, 'password': password});

    //successfull login
    if (response.statusCode == 200) {
      //go to next screen
      print("object");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }

    //incorrect username or password
    else if (response.statusCode == 401) {
      setState(() {
        incorrect = true;
        somethingWentWorng = false;
      });
    }

    //if something went wrong
    else {
      setState(() {
        somethingWentWorng = true;
        incorrect = false;
      });
    }
  }
}
