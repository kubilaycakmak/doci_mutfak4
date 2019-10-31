import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';

bool validate = false;

class Update extends StatefulWidget {
  Update({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  var name = TextEditingController(text: userInformations[0].name);
  var lastName = TextEditingController(text: userInformations[0].lastname);
  var phoneNumber =
      TextEditingController(text: userInformations[0].phoneNumber);
  var address = TextEditingController(text: userInformations[0].address);
  final String updateUrl = 'http://68.183.222.16:8080/api/user/update';
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';

  Future<http.Response> postItself() async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": key,
    });
    setState(() {
      user = json.decode(response.body);
    });
    var userInfo = new User(
        id: user["value"]["id"],
        name: user["value"]["name"],
        lastname: user["value"]["lastname"],
        phoneNumber: user["value"]["phoneNumber"],
        address: user["value"]["address"],
        created: user["value"]["created"]);
    userInformations.clear();
    userInformations.add(userInfo);
    return response;
  }

  String validatePhoneNumberUpdate(String value) {
    Pattern cellphone = r'^((?!(0))[0-9]{7,11})$';
    RegExp regexPhone = new RegExp(cellphone);
    if (!regexPhone.hasMatch(value))
      return 'Ev telefonu ise 7, Cep telefonu ise 11 haneli olmalidir.';
    else {
      validate = true;
      return null;
    }
  }

  Future<http.Response> postUpdate() async {
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
    } else {
      print('guncelleme de hata!');
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
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Bilgileri Güncelle'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: width / 20, top: width / 90, right: width / 50),
              child: InkWell(
                child: Text(
                  'Güncellemek istediğiniz bilgileri aşağıdaki '
                  'uygun alanlardan değiştirebilir, boş bıraktığınız alanlar ise eski halinde kalacaktır.',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            ),
            Form(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        labelText: 'Ad',
                        fillColor: Colors.black,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    TextFormField(
                      onChanged: (val) {},
                      controller: lastName,
                      decoration: InputDecoration(
                        labelText: 'Soyad',
                        fillColor: Colors.black,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    TextFormField(
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        labelText: 'Telefon Numarası',
                        fillColor: Colors.black,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                      validator: validatePhoneNumberUpdate,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    TextFormField(
                      controller: address,
                      maxLines: 4,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: 'Adres',
                        fillColor: Colors.black,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 20),
                      trailing: MaterialButton(
                        elevation: 0,
                        onPressed: () {
                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: 'Bilgilerin Guncellendi!',
                            buttons: [
                              DialogButton(
                                onPressed: () {
                                  setState(() {
                                    postUpdate();
                                  });
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                },
                                child: Text('Ana Ekrana don'),
                              ),
                            ],
                          ).show();
                        },
                        child: Text(
                          'Güncelle',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.lightBlueAccent,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
