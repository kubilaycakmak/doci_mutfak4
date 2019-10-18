/*import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:doci_mutfak4/Data/json_user.dart';


class LoginWithRestfulApi extends StatefulWidget {
  LoginWithRestfulApi({Key key}) : super(key: key);

  _LoginWithRestfulApiState createState() => _LoginWithRestfulApiState();
}

class _LoginWithRestfulApiState extends State<LoginWithRestfulApi> {
  static var uri = "http://68.183.222.16:8080/api/userAccount/login";

    TextEditingController _emailController = TextEditingController();
    bool _isLoading = false;
    TextEditingController _passwordController = TextEditingController();
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    Future<dynamic> _loginUser(String email, String password) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );

      Response response = await dio.post('/users/login',
          data: {"email": email, "password": password}, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 401) {
        throw Exception("Incorrect Email/Password");
      } else
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('GIRIS YAP'),
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pushReplacementNamed(context, "/splash"),
      ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30, left: 20,right: 20),
        child: Center(
        child: _isLoading
        ? CircularProgressIndicator()
        : Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 0, right: 0),
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.only(right: 20),
                    child: Text('Sifremi unuttum'),
                    onPressed: null,
                  ),
                  ButtonTheme(
                    child: RaisedButton(
                      onPressed: () async {
                      setState(() => _isLoading = true);
                      var res = await _loginUser(
                          _emailController.text, _passwordController.text);
                      setState(() => _isLoading = false);

                      JsonUser user = JsonUser.fromJson(res);
                      if (user != null) {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new LoginScreen(
                            user: user,
                          );
                        }));
                      } else {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Wrong email or")));
                      }
                      },
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.00),
                        side: BorderSide(color: Colors.deepOrange)
                      ),
                      color: Colors.deepOrange,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text(
                        'GIRIS YAP',
                        style: TextStyle(fontSize: 20)
                ),
              ),
            ),
          ),
                  
                ],
              )
            ),
            
          ],
        ),
      ),
      )
    );
  }
}
class LoginScreen extends StatelessWidget {
  LoginScreen({@required this.user});

  final JsonUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Center(
        child: user != null
            ? Text("Logged IN \n \n Email: ${user.email} ")
            : Text("Yore not Logged IN"),
      ),
    );
  }
}*/