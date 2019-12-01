import 'package:doci_mutfak4/Connection/api_calls.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Validation/val.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';

var name = TextEditingController(text: userInformations[0].name);
var lastName = TextEditingController(text: userInformations[0].lastname);
var phoneNumber = TextEditingController(text: userInformations[0].phoneNumber);
var address = TextEditingController(text: userInformations[0].address);
String statusValidatorUpdate;
bool validate = false;

class Update extends StatefulWidget {
  Update({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userInformations[0].name);
    return WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          Navigator.of(context).pushReplacementNamed('/home');
        },
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 40, 77,1),
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
                              color: Color.fromRGBO(0, 40, 77,1),
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
                              color: Color.fromRGBO(0, 40, 77,1),
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
                              color: Color.fromRGBO(0, 40, 77,1),
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
                              color: Color.fromRGBO(0, 40, 77,1),
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
                            onLoad(context, 'Bilgileriniz Kaydediliyor..');
                              t = new Timer(Duration(milliseconds: 2000), (){
                                postUpdate(context);
                                t.cancel();
                                Navigator.pop(context);
                              }
                            );
                          }
                        }, child: Text('Güncelle', style: TextStyle(color: Colors.white),)
                        ,color: Color.fromRGBO(0, 40, 77,1),
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