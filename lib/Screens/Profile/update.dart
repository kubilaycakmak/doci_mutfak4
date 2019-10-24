import 'package:doci_mutfak4/Screens/Account/login_register.dart' as prefix0;
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:flutter/material.dart';



class Update extends StatefulWidget {
  Update({Key key}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  var name = TextEditingController(text: userInformations[0].name);
  var lastname = TextEditingController(text: userInformations[0].lastname);
  var phonenumber = TextEditingController(text: userInformations[0].phoneNumber);
  var address = TextEditingController(text: userInformations[0].address);

  var _check = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bilgileri Guncelle'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info),
              subtitle: Text('Bilgilerini guncellemek icin asagidaki uygun alanlara yeni bilgilerinizi giriniz, Girmediginiz alanlardaki bilgiler eskisi gibi kalacaktir.'),
            ),
            Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[

                      TextFormField(
                        enabled: _check,
                        onChanged: (val){
                          if(val == 'asd'){
                            print('aq');
                            setState(() {
                              _check = false;
                            });
                          }
                        },
                        controller: name,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),

                      TextFormField(
                        onChanged: (val){

                        },
                        controller: lastname,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "E-posta veya Kullanici adi bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),

                      TextFormField(
                        controller: phonenumber,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "E-posta veya Kullanici adi bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      
                      TextFormField(
                        controller: address,
                        maxLines: 3,
                        maxLength: 100,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        validator: (val){
                          if (val.length == 0) {
                            return "E-posta veya Kullanici adi bos olamaz!";
                          }
                          else{
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        trailing: MaterialButton(
                          onPressed: (){
                        }, child: Text('Guncelle'),color: Colors.lightBlueAccent,),
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