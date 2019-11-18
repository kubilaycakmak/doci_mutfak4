import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';

String nameValidator(String value){
  Pattern pattern = r'^[a-zA-Z0-9. ğüşöçİĞÜŞÖÇ]{5,20}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Adınızı düzeltiniz';
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

String statusValidatorUpdate;
bool validate = false;
class Update extends StatefulWidget {
  Update({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formKey = new GlobalKey<FormState>();
  var name = TextEditingController(text: userInformations[0].name);
  var lastName = TextEditingController(text: userInformations[0].lastname);
  var phoneNumber = TextEditingController(text: userInformations[0].phoneNumber);
  var address = TextEditingController(text: userInformations[0].address);
  final String updateUrl = 'http://68.183.222.16:8080/api/user/update';
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';

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
            color: Colors.lightBlueAccent,
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
    postUpdate();
      postItself();
  });
}


  Future<http.Response> postItself() async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": key,
    });
    if(response.statusCode == 200){
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
    }
    return response;
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
      Alert(
        context: context,
        type: AlertType.success,
        title: 'Bilgilerin Güncellendi!',
        desc: 'Bir sonraki girişinde bilgilerin güncellenmiş olacak',
        buttons: [
          DialogButton(
            onPressed: () {
                postItself();
                Navigator.of(context)
                  .pushReplacementNamed('/home');
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
            onPressed: () {
                postItself();
                Navigator.pop(context,false);
            },
            child: Text('Tamam', style: TextStyle(color: Colors.white),),
          ),
        ],
      ).show();
    }
    return response;
  }

  @override
  void initState() { 
    super.initState();
    this.postItself();
  }

  @override
  Widget build(BuildContext context) {
    print(userInformations[0].name);
    return WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          Navigator.of(context).pushReplacementNamed('/home');
          print('aq');
        },
        child: Scaffold(
      appBar: AppBar(
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
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: InkWell(
                child: Text(
                  'Güncellemek istediğiniz bilgileri aşağıdaki '
                  'uygun alanlardan değiştirebilir, boş bıraktığınız alanlar ise eski halinde kalacaktır.',
                  style: TextStyle(color: Colors.black38),
                ),
              ),
            ),
            Form(
              key: _formKey,
              autovalidate: validate,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autovalidate: true,
                      validator: nameValidator,
                      controller: name,
                      decoration: InputDecoration(
                        helperText: 'Adınız boşluk içeremez',
                        labelText: 'Ad',
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                    TextFormField(
                      controller: lastName,
                      autovalidate: true,
                      validator: nameValidator,
                      decoration: InputDecoration(
                        labelText: 'Soyad',
                        helperText: 'Soyadınız boşluk içeremez',
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                    TextFormField(
                      controller: phoneNumber,
                      autovalidate: true,
                      decoration: InputDecoration(
                        labelText: 'Telefon numarası',
                        helperText: 'Başında sıfır olmadan Ev ise 7, Cep ise 10 haneli olmalıdır',
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                          ),
                        ),
                      ),
                      validator: validatePhoneNumber,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    TextFormField(
                      autovalidate: true,
                      controller: address,
                      maxLines: 2,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: 'Adres',
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(height: 10,),
                    ListTile(
                      trailing: CupertinoButton(
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            _onLoading();
                          }
                        }, child: Text('Güncelle', style: TextStyle(color: Colors.white),)
                        ,color: Colors.lightBlueAccent
                      )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}