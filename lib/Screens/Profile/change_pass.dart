import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _currentPass = TextEditingController();
  var _newPass = TextEditingController();
  var user;

  Future<http.Response> changePasswordRequest() async {
    var response = await http.put(
        Uri.encodeFull(
            'http://68.183.222.16:8080/api/userAccount/changePassword/?currentPassword='
            '${_currentPass.text}&newPassword=${_newPass.text}'),
        headers: {
          "authorization": key,
        });
    setState(() {
      user = json.decode(response.body);
    });
    if (response.statusCode == 201) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title:
                    SelectableText('Şifreniz başarılı bir şekilde değişmiştir'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/home'),
                    child: Text('Ana Sayfa'),
                  ),
                ],
              ));
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Şifre Yenileme'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(width / 20.5),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _currentPass,
                    decoration: InputDecoration(
                      labelText: "Şu anki kullandığınız şifre",
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  TextFormField(
                    controller: _newPass,
                    decoration: InputDecoration(
                      labelText: "Yeni şifre",
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(top: width / 20),
                    trailing: MaterialButton(
                      elevation: 0,
                      // ignore: missing_return
                      onPressed: () {
                        changePasswordRequest();
                      },
                      child: Text(
                        'Onayla',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlueAccent,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
