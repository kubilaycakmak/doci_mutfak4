import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

TabController tabController;
final _formKey = new GlobalKey<FormState>();
bool _validate = false;
String username;
var authKey;
String key;
int statusCode;
var user;
List<User> userInformations = new List();
List<User> getList(){
  return userInformations;
}
List questions;
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
String dropdownValue = 'One';
final _username = TextEditingController();
final _password = TextEditingController();
final _name = TextEditingController();
final _lastname = TextEditingController();
final _phoneNumber = TextEditingController();
final _address = TextEditingController();
final _securityQuestion = TextEditingController();
final _answer = TextEditingController();

int setQuestion;
String currentQuest;
int statusValidator;
bool lock;
List num;

class Helper{
  static Helper _instance;
  factory Helper() => _instance ??= new Helper._();

  Helper._();
}

String validateUsername(String value){
  Pattern pattern = r'^[a-zA-Z][a-zA-Z0-9._-]{3,15}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Kullanici ismini duzeltiniz!';
  else
    return null;
}

String validatePassword(String value){
  Pattern pattern = r'^[a-zA-Z0-9._-]{5,15}$';
  RegExp regex = new RegExp(pattern);
  if(!regex.hasMatch(value))
    return 'Sifrenizi duzeltiniz';
  else
    return null;
}
String validateAnswer(String value){
 Pattern pattern = r'^[a-zA-Z0-9.-]{2,15}$';
 RegExp regex = new RegExp(pattern);
 if(!regex.hasMatch(value))
   return 'Cevabinizi duzeltiniz';
 else
   return null;
}
String validatePhoneNumber(String value){
  Pattern cellphone = r'^((?!(0))[0-9]{7,11})$';
  RegExp regexPhone = new RegExp(cellphone);
  if(!regexPhone.hasMatch(value))
    return 'Ev telefonu ise 7, Cep telefonu ise 11 haneli olmalidir.';
  else
    return null;
}

class LoginAndRegister extends StatefulWidget {
  @override
  _LoginAndRegisterState createState() => _LoginAndRegisterState();
}

class _LoginAndRegisterState extends State<LoginAndRegister> with TickerProviderStateMixin {
  final String loginCheckUrl = 'http://68.183.222.16:8080/api/userAccount/login';
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  final String securityQuestions = 'http://68.183.222.16:8080/api/securityQuestion/all';
  final String registerCheck = 'http://68.183.222.16:8080/api/userAccount/create';
  Helper helper = new Helper();
  Future<http.Response> postRequest() async{
    Map data = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };
    var body = json.encode(data);

    var response = await http.post(loginCheckUrl,
      headers: {
        "Content-Type":"application/json"
      },
      body: body
    );
    setState(() {
      authKey = json.decode(response.body);
    });
    key = authKey["authorization"];
    if(key!=''){
      inside = false;
      Navigator.of(context).pushReplacementNamed('/home');
      postItself();
    }else{
      inside = true;
      Alert(
        context:context, 
        title: 'Kullanici adi veya Sifreniz yanlistir',
        desc: 'Sifremi unuttum a tiklayarak sifrenizi sifirlayabilirsiniz!',
        buttons: [
          DialogButton(
            onPressed: null,
            child: Text('Sifremi unuttum'),
          ),
          DialogButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Tamam'),
          ),
        ],
      ).show(); 
    }
    return response;
  }

    Future<String> getQuestions() async{
    var response = await http.get(Uri.encodeFull(securityQuestions), headers: {
      "Accept": 'application/json'
    });
      var _extractData = json.decode(response.body);
      questions = _extractData;
      print(questions[0]['question']);
      print(questions.length);
      return questions.toString();
  }


  Future<http.Response> postRegisterRequest() async{
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
    var response = await http.post(registerCheck,
      headers: {
        "Content-Type":"application/json"
      },
      body: body
    );
      statusValidator = response.statusCode;
      return response;
  }

  Future<http.Response> postItself() async{
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
        created: user["value"]["created"]
        );
        userInformations.add(userInfo);

        return response;
  }

  @override
  Widget build(BuildContext context) {
    getQuestions();
    tabController = new TabController(length: 2, vsync: this);
    var tabBarItem = new TabBar(
      tabs: <Widget>[
        Tab(
          child: Text('Giris Yap'),
        ),
        Tab(
          child: Text('Yeni Uye'),
        )
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          bottom: tabBarItem,
          backgroundColor: Colors.lightBlueAccent,
        ),
        
        ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  enabled: false,
                  leading: Icon(Icons.info_outline),
                  subtitle: Text('Bu uygulama diger uygulamalardan bagimsiz olup kendi uyeliginizi kullanmaniz gerekmektedir.'),
                  ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Kullanici Adi veya E-Posta",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Sifre",
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightBlueAccent
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 20),
                        leading: FlatButton(onPressed: (){}, child: Text('Sifremi Unuttum!'),),
                        trailing: MaterialButton(
                          onPressed: (){
                              postRequest();
                              getQuestions();
                        }, child: Text('Giris Yap'),color: Colors.lightBlueAccent,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: ListView(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  enabled: false,
                  leading: Icon(Icons.info_outline),
                  subtitle: Text('Bu uygulama diger uygulamalardan bagimsiz olup kendi uyeliginizi olusturmaniz gerekmektedir.'),
                  ),
                  ListTile(
                  contentPadding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  enabled: false,
                  leading: Icon(Icons.info_outline),
                  subtitle: Text('Kayit olabilmeniz icin basindaki yildiz olan bos alanlari doldurmaniz gerekmektedir.'),
                  ),

                Form(
                  autovalidate: _validate,
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _username,
                          decoration: InputDecoration(
                            labelText: "* Kullanici adi",
                            //helperText: 'Kullanici adi ".(Nokta), -(cizgi) veya _(alttan tire) \n icerebilir ve en az 3 en cok 15 karakterden olusmalidir!"',
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent
                              ),
                            ),
                          ),
                          validator: validateUsername,
                          onSaved: (String val){
                            username = val;
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        TextFormField(
                          controller: _password,
                          decoration: InputDecoration(
                            labelText: "* Sifre",
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent
                              ),
                            ),
                          ),
                          validator: validatePassword,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: "* Ad",
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent
                              ),
                            ),
                          ),
                          validator: (val){
                            if (val.length == 0) {
                              return "Lutfen adinizi giriniz!";
                            }
                            else{
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        TextFormField(
                          controller: _lastname,
                          decoration: InputDecoration(
                            labelText: "* Soyad",
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent
                              ),
                            ),
                          ),
                          validator: (val){
                            if (val.length == 0) {
                              return "Lutfen soyadinizi giriniz!";
                            }
                            else{
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        ListTile(
                          enabled: false,
                          leading: Icon(Icons.info_outline),
                          subtitle: Text('Telefon numarasi alan kodu ve 0 icermemelidir!', style: TextStyle(fontSize: 12.5),),
                        ),
                        TextFormField(
                          controller: _phoneNumber,
                          validator: validatePhoneNumber,
                          decoration: InputDecoration(
                            labelText: "* Telefon numarasi",
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                          ),
                        ),
                        TextFormField(
                          controller: _address,
                          decoration: InputDecoration(
                            labelText: "* Siparis Adresi",
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
                        ExpansionTile(
                          title: currentQuest == null ? Text('* Lutfen Bir Soru Seciniz!') : Text('$currentQuest'),
                          children: <Widget>[
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: false,
                              itemCount: 6,
                              itemBuilder: (context, index){
                                return ListTile(
                                  title: Text('${questions[index]['question'].toString()}'),
                                  onTap: (){
                                    setState(() {
                                      currentQuest = questions[index]['question'].toString();
                                      setQuestion = questions[index]['id'];

                                    });
                                  },
                                );
                              },
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _answer,
                          maxLength: null,
                          decoration: InputDecoration(
                            labelText: "* Cevap",
                            fillColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent
                              ),
                            ),
                          ),
                          validator: validateAnswer,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ListTile(
                        enabled: false,
                        contentPadding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        subtitle: Text('Bilgilerinizi profilim sayfanizdan degistirebilirsiniz.'),
                        ),
                      ListTile(
                        enabled: false,
                        contentPadding: EdgeInsets.only(top: 0, left: 5, right: 5),
                        subtitle: Text('Kullanici Sozlesmesini ve Gizlilik Politikasini okudum ve kabul ediyorum.'),
                      ),
                      ListTile(
                        title: MaterialButton(onPressed: (){
                          postRegisterRequest();
                          /*if(statusValidator == 200){
                            inside = true;
                            Navigator.of(context).pushReplacementNamed('/login');
                          }*/
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Alert(
                                context:context,
                                type: AlertType.success,
                                title: 'Basariyla kayit oldun!',
                                buttons: [
                                  DialogButton(
                                    onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                    child: Text('Giris sayfasina git'),
                                  ),
                                  DialogButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Tamam'),
                                  ),
                                ],
                              ).show();
                            } else {
                              setState(() {
                                _validate = true;
                              });
                            }
                          }, child: Text('Yeni Uye'),color: Colors.lightBlueAccent,),
                      ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}