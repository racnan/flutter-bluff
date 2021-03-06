import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import './roomScreen.dart';

import '../widgets/customButton.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //if username and passoword doesn't match this is set to true
  var incorrect = false;

  //for displaying message "Something went wrong"
  var somethingWentWrong = false;

  // for displaying the message "Already logged in"
  var alreadyLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight = MediaQuery.of(context).size.height.roundToDouble();
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        // color: Colors.amber,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "स्वागतम,",
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
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            )),
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
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Password";
                          }
                          return null;
                        },
                      ),
                    ),
                    CustomButtom(
                      onPressed: () => {
                        if (_formKey.currentState.validate())
                          {
                            httpPost(usernameController.text,
                                passwordController.text)
                          }
                      },
                      text: "Submit",
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.05,
                    )
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
            if (somethingWentWrong)
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
            if (alreadyLoggedIn)
              Center(
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Already logged in.",
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
    var url = Uri.parse('http://192.168.1.38:3000/login');
    var response = await http
        .post(url, body: {'username': username, 'password': password});

    //successfull login
    if (response.statusCode == 200) {
      //go to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoomScreen(
                  username: username,
                )),
      );
    }

    // already logged in
    else if (response.statusCode == 409) {
      setState(() {
        alreadyLoggedIn = true;
        incorrect = false;
        somethingWentWrong = false;
      });
    }

    //incorrect username or password
    else if (response.statusCode == 401) {
      setState(() {
        incorrect = true;
        alreadyLoggedIn = false;
        somethingWentWrong = false;
      });
    }

    //if something went wrong
    else {
      setState(() {
        incorrect = false;
        alreadyLoggedIn = false;
        somethingWentWrong = true;
      });
    }
  }
}
