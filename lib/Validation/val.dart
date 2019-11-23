  
import 'dart:async';
import 'package:flutter/material.dart';
Timer t;
bool isValid;
  
  String validateUsername(String value){
  Pattern pattern = r'^[a-zA-Z][a-zA-Z0-9._-]{3,15}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Kullanıcı ismini düzeltiniz!';
  else if(isValid == false)
    return 'Bu kullanıcı zaten mevcut!';
  else
    return null;
}

  String validatePassword(String value){
    Pattern pattern = r'^[a-zA-Z0-9._-]{5,15}$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value))
      return 'Şifrenizi düzeltiniz';
    else
      return null;
  }
  String validateAnswer(String value){
  Pattern pattern = r'^[a-zA-Z0-9 .-]{2,15}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Cevabınızı düzeltiniz';
  else
    return null;
  }
  String validatePhoneNumber(String value){
    Pattern cellphone = r'^((?!(0))[0-9]{7,10})$';
    RegExp regexPhone = new RegExp(cellphone);
    if(!regexPhone.hasMatch(value))
      return 'Ev telefonu ise 7, Cep telefonu ise 10 haneli olmalidir.';
    else
      return null;
  }

  String nameValidator(String value){
  Pattern pattern = r'^[a-zA-Z0-9. ğüşöçİĞÜŞÖÇ]{2,20}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Adınızı düzeltiniz';
  else
    return null;
}

  void onLoad(BuildContext context, String text) {
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
                backgroundColor: Colors.yellow,
              ),
              SizedBox(height: 5,),
              Text(text, style: TextStyle(color: Colors.white),)
            ],
          ),
        );
      },
    );
}

