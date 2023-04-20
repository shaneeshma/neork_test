import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neork_test/ListUserPage.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

final dio = Dio();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;
  String errText = '';
  void login() async {
    var map = new Map<String, dynamic>();
    map['email'] = _username;
    map['password'] = _password;

    http.Response response = await http.post(
      Uri.parse('http://sas.neork.io/api/login'),
      body: map,
    );
    var result = jsonDecode(response.body);
    if (result['status_code'] == 200) {
      setState(() => errText = "");
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('data', json.encode(result['data']));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListUserPage(data: result['data'])));
    } else if (result['status_code'] == 401) {
      print(result['status_code']);
      setState(() => errText = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 450,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    padding: EdgeInsets.fromLTRB(100, 20, 100, 30),
                    alignment: Alignment.center,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              setState(() => errText = "");
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() => errText = "");
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ])),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Row(children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.topLeft,
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(
                                    169, 103, 63, 0.6588235294117647),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(150),
                                ),
                              ))),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              errText),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: 300, height: 30),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      login();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: StadiumBorder(),
                                  ),
                                  child: Text('Login'),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: 300, height: 30),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      login();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: StadiumBorder(),
                                  ),
                                  child: Text('Register'),
                                )),
                          ),
                        ],
                      )),
                      // SizedBox(width: 50,),
                      Expanded(
                          child: Container(
                              alignment: Alignment.bottomRight,
                              width: 150,
                              height: 150,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('/images/image1.png'),
                                    fit: BoxFit.contain),
                              ))),
                    ]))
              ]),
        ),
      ),
    );
  }
}
