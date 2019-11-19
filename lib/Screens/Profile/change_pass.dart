import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


String validatePassword(String value){
  Pattern pattern = r'^[a-zA-Z0-9._-]{5,15}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Şifrenizi düzeltiniz';
  else
    return null;
}

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _currentPass = TextEditingController();
  var _newPass = TextEditingController();
  var user;
  bool _validate = false;
  final _formKey = new GlobalKey<FormState>();

  Future<http.Response> changePasswordRequest() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.put(Uri.encodeFull(
        'http://68.183.222.16:8080/api/userAccount/changePassword/?currentPassword='
            '${_currentPass.text}&newPassword=${_newPass.text}'),
        headers: {
          "authorization": key,
        }
    );
    setState(() {
      user = json.decode(response.body);
    });
    print('status code ' + response.statusCode.toString());
    if(response.statusCode == 201){
      Alert(
        context: context,
        type: AlertType.success,
        title: 'Şifreniz başarılı bir şekilde değişmiştir',
        buttons: [
          DialogButton(
            color: Color.fromRGBO(0, 40, 77,1),
            child: Text('Tamam', style: TextStyle(color: Colors.white),),
            onPressed: (){
              prefs.setString('LastPassword', _newPass.text);
              Navigator.of(context).pushReplacementNamed('/home');
            },
          )
        ]
      ).show();
    }else if(response.statusCode == 400){
      Alert(
        context: context,
        type: AlertType.warning,
        title: 'Eski şifre',
        desc: 'Eski şifreniz yanlış',
        buttons: [
          DialogButton(
            color: Color.fromRGBO(0, 40, 77,1),
            child: Text('Tamam', style: TextStyle(color: Colors.white),),
            onPressed: ()=> Navigator.of(context).pushReplacementNamed('/home'),
          )
        ]
      ).show();
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          Navigator.of(context).pushReplacementNamed('/home');
        },
        child: Scaffold(
      appBar: AppBar(
        title: Text('Şifre Yenileme'),
        backgroundColor: Color.fromRGBO(0, 40, 77,1),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=>Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    autovalidate: _validate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: validatePassword,
                          controller: _currentPass,
                          autocorrect: false,
                          decoration: InputDecoration(
                          labelText: "Şu anki kullandığınız şifre",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(0, 40, 77,1)
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: _newPass,
                        validator: validatePassword,
                        decoration: InputDecoration(
                        labelText: "Yeni şifre",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 40, 77,1)
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 20),
                    trailing: MaterialButton(
                      // ignore: missing_return
                      onPressed: (){
                        if (_formKey.currentState.validate()) {
                            _onLoading();
                          }
                      }, child: Text('Onayla', style: TextStyle(color: Colors.white),),color: Color.fromRGBO(0, 40, 77,1),),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black38,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color.fromRGBO(0, 40, 77,1),
            width: 2
          )
        ),
        title: Column(
          children: <Widget>[
            CircularProgressIndicator(
            ),
            SizedBox(height: 5,),
            Text('İşleminiz Sürüyor...', style: TextStyle(color: Colors.white),)
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(milliseconds: 2000), () {
    Navigator.pop(context); //pop dialog
    changePasswordRequest();
  });
}
}
