import 'dart:convert';
import 'package:doci_mutfak4/Model/order.dart';
import 'package:doci_mutfak4/Model/user.dart';
import 'package:doci_mutfak4/Routes.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Profile/profile.dart';
import 'package:doci_mutfak4/Screens/Profile/update.dart';
import 'package:doci_mutfak4/Validation/val.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
var keyShared;

Future<http.Response> postUpdate(BuildContext context) async {
  Map data = {
    "name": name.text,
    "lastname": lastName.text,
    "phoneNumber": phoneNumber.text,
    "address": address.text
  };

  var body = json.encode(data);
  var response = await http.put(updateUrl,
      headers: {"authorization": key, "Content-Type": "application/json"},
      body: body);
  if (response.statusCode == 201) {
    print('data guncellendi');
    Alert(
      context: context,
      type: AlertType.success,
      title: 'Bilgilerin Güncellendi!',
      desc: 'Bir sonraki girişinde bilgilerin güncellenmiş olacak',
      buttons: [
        DialogButton(
          color: Color.fromRGBO(0, 40, 77,1),
          onPressed: () {
            postItself(context, '/home');
          },
          child: Text('Ana Ekrana don', style: TextStyle(color: Colors.white),),
        ),
      ],
    ).show();
  } else {
    Alert(
      context: context,
      type: AlertType.warning,
      title: 'Bilgilerinde Hata!',
      desc: 'Bilgilerinde bir hata var, Lütfen tekrar kontrol et!',
      buttons: [
        DialogButton(
          color: Color.fromRGBO(0, 40, 77,1),
          onPressed: () {
            postItself(context, '/back');
          },
          child: Text('Tamam', style: TextStyle(color: Colors.white),),
        ),
      ],
    ).show();
  }
  return response;
}

Future<http.Response> postItself(BuildContext context, String route) async {
    getKey();
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": keyShared.toString(),
    });
    if(response.statusCode == 200){
      print('200');
      user = json.decode(response.body);  
      var userInfo = new User(
        id: user["value"]["id"],
        name: user["value"]["name"],
        lastname: user["value"]["lastname"],
        phoneNumber: user["value"]["phoneNumber"],
        address: user["value"]["address"],
        created: user["value"]["created"]);
      userInformations.clear();
      userInformations.add(userInfo);
      Navigator.of(context).pushReplacementNamed(route);
    }else if(response.statusCode == 401){
      print('401');
      print(route);
      postRequest(context, username, password, route);
      //postRequestAuto(context, username, password);
    }
    return response;
  }

  Future<http.Response> postItselfAuto(String keyShared) async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": keyShared.toString(),
    });
    if(response.statusCode == 200){
      user = json.decode(response.body);
      var userInfo = User.fromJson(user);
      userInformations.add(userInfo);
      return response;
    }else{
      throw Exception('postItselfAuto');
    }
  }

  Future<bool> userCheck(String username) async{
    var response = await http.get(userCheckUrl);
    var body = json.decode(response.body);
    if(body == false){
      print('bu kullanici var');
        isValid = false;
    }else{
      print('kullanici alinabilir');
        isValid = true;
    }
    return isValid;
  }

  Future<bool> postRequest(
      BuildContext context,
      String username,
      String password,
      String route
      ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {
      'username': username.toString(),
      'password': password.toString()
    };
    var body = json.encode(data);
    var response = await http.post(loginCheckUrl,headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      authKey = json.decode(response.body);
      key = authKey["authorization"];
      preferences.setString('LastKey', key);
      preferences.setString('LastUsername', username);
      preferences.setString('LastPassword', password);
      keyShared = preferences.getString('LastKey');
      username = preferences.getString('LastUsername');
      password = preferences.getString('LastPassword');
      print(preferences.getString('LastKey'));
      print(preferences.getString('LastUsername'));
      print(preferences.getString('LastPassword'));
      if (key != '') {
        inside = false;
        //Navigator.of(context).pushReplacementNamed(route);
        postItself(context, route);
      }else{
        inside = true;
        if(username != null && password !=null){
          Alert(
            style: AlertStyle(
              animationDuration: Duration(milliseconds: 500),
              animationType: AnimationType.grow,
            ),
            type: AlertType.warning,
            title: 'Kullanıcı adı ve ya Şifre yanlış',
            desc: "Şifrenizi unuttuysanız, şifremi unuttum'a tıklayarak şifrenizi yenileyebilirsiniz.",
            buttons: [
              DialogButton(
                color: Color.fromRGBO(0, 40, 77,1),
                onPressed: () => Navigator.pop(context,false),
                child: Text('Tamam', style: TextStyle(color: Colors.white),),
              ),
              DialogButton(
                color: Color.fromRGBO(0, 40, 77,1),
                onPressed: () => Navigator.of(context).pushReplacementNamed('/forget'),
                child: Text('Şifremi unuttum', style: TextStyle(color: Colors.white),),
              ),
            ], context: context,
          ).show();
        }else{
          print('username yok');
        }
      }
    }else if(response.statusCode == 401 || response.statusCode == 400 || response.statusCode == 500){
        key = null;
        // Alert(
        //   style: AlertStyle(
        //     animationDuration: Duration(milliseconds: 500),
        //     animationType: AnimationType.grow,
        //   ),
        //   context: context,
        //   title: 'Server Hatasi',
        //   desc: 'Serverimiz suan da bakimdadir, lutfen daha sonra tekrar deneyiniz.',
        //   buttons: [
        //   ]
        // ).show();
    }
    username = null;
    password = null;
    keyShared = null;
    //Navigator.of(context).pushReplacementNamed('/login');
    return inside;
  }

 Future<http.Response> postRequestAuto(BuildContext context, String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map data = {
    'username': username,
    'password': password
  };
  var body = json.encode(data);
  var response = await http.post(loginCheckUrl, headers: {"Content-Type": "application/json"}, body: body);

  if (response.statusCode == 200) {
    print('200 post');
    var authKey = json.decode(response.body);
    prefs.setString('LastKey', authKey["authorization"]);
    inside = false;
  }
  else if(response.statusCode == 405 || response.statusCode == 401 || response.statusCode == 500){
      print('400 post');
      print('error on postRequestAuto');
      inside = true;
  }
  return response;
}

  Future<http.Response> postRegisterRequest(
    TextEditingController _username,
    TextEditingController _password,
    TextEditingController _name,
    TextEditingController _lastname,
    TextEditingController _phoneNumber,
    TextEditingController _address,
    TextEditingController _answer
    ) async{
    Map data =
      {
        "username": _username.text,
        "password": _password.text,
        "user": {
        "name": _name.text,
            "lastname": _lastname.text,
            "phoneNumber": _phoneNumber.text,
            "address": _address.text
        },
        "securityQuestion": {
          "id": setQuestion
        },
        "answer": _answer.text
    };

    var body = json.encode(data);
    print(data);
    var response = await http.post(registerCheck,
      headers: {
        "Content-Type":"application/json"
      },
      body: body
    );
      statusValidator = response.statusCode;
      return response;
  }

logout() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('LastKey', '');
  prefs.setString('LastUsername', '');
  prefs.setString('LastPassword', '');
}

getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
  } 


    Future<http.Response> sendOrderFunc(
      BuildContext context, 
      int selectedPayment,
      TextEditingController _addressController,
      TextEditingController _phoneController,
      TextEditingController note,
      ) async {
    Map payment = {
      'id': selectedPayment
    };
    var id;
    List listId= new List();
    for(int i=0;i<listItems.length;i++){
       id = {
        'dociProduct': {
          'id': listItems[i].id
        },
        'quantity': listItems[i].itemCount
      };
       listId.add(id);
    }
    Order or = Order(listId, note.text, payment,_addressController.text, _phoneController.text);
    var body = json.encode(or.toJson());
    var response = await http.post(Uri.encodeFull(orderCreate),
        headers: {
          "content-type" : "application/json",
          "accept": "application/json",
          "authorization": key,
        },
        body: body);
        print(body);

    if (response.statusCode == 201) {
        print(' Response Body : ' + response.body);
        listItems.clear();
         Alert(
          type: AlertType.success,
          title: 'Siparişiniz Onaylandı',
          desc:'Sepetinizdeki ürünler hazırlanıyor, kısa bir süre içerisinde siparişinizi teslim edeceğiz.',
          buttons: [
            DialogButton(
              color: Color.fromRGBO(0, 40, 77,1),
              onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
          context: context,
          style: AlertStyle(
            animationDuration: Duration(milliseconds: 500),
            animationType: AnimationType.grow,
            isCloseButton: false,
            isOverlayTapDismiss: false,
          )
        ).show();

    } else if(response.statusCode == 401){
      if(username != null && password !=null ){
        postRequestAuto(context, username, password);
        postItselfAuto(keyShared);
      }else{
         Alert(
          style: AlertStyle(
            animationDuration: Duration(milliseconds: 500),
            animationType: AnimationType.grow,
          ),
          type: AlertType.error,
          title: 'Hata',
          desc:
          'Lütfen sipariş verebilmek için giriş yapınız.',
          buttons: [
            DialogButton(
              color: Color.fromRGBO(0, 40, 77,1),
              onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
          context: context,
        ).show();
      throw Exception('Failed to fetch sendOrders');
      }
    }
    else {
         Alert(
          style: AlertStyle(
            animationDuration: Duration(milliseconds: 500),
            animationType: AnimationType.grow,
          ),
          type: AlertType.error,
          title: 'Hata',
          desc:
          'Lütfen sipariş verirken boş alanları doğru bir şekilde doldurunuz.',
          buttons: [
            DialogButton(
              color: Color.fromRGBO(0, 40, 77,1),
              onPressed: () => Navigator.pop(context,true),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
          context: context,
        ).show();
      throw Exception('Failed to fetch sendOrders');
    } 
    return response;
  }
