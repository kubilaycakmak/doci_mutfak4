// import 'package:connectivity/connectivity.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

TabController tabController;
final _formKey = new GlobalKey<FormState>();
bool _validate = false;
String username;
String password;
var authKey;
String key;
var isSelected;
int statusCode;
bool internet = true;
var user;
List<User> userInformations = new List();
List<User> getList(){
  return userInformations;
}

var usernameAuto;
var passwordAuto;
var statusForgetPass;
int setQuestion;
String currentQuest;
int statusValidator;
bool lock;
List num;



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

  Questions currentQuestion;
  final String loginCheckUrl = 'http://68.183.222.16:8080/api/userAccount/login';
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  final String securityQuestions = 'http://68.183.222.16:8080/api/securityQuestion/all';
  final String registerCheck = 'http://68.183.222.16:8080/api/userAccount/create';
  final String changePass = 'http://68.183.222.16:8080/api/userAccount/changePassword ';
  final String sendOrder = 'http://68.183.222.16:8080/api/order/create';
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  final _name = TextEditingController();
  final _lastname = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _address = TextEditingController();
  final _answer = TextEditingController();
  bool isTrue;
  bool _agreedToTOS = true;
  bool remember = false;
  var keyShared;


  Future<http.Response> postRequest() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };
    var body = json.encode(data);
    var response = await http.post(loginCheckUrl,headers: {"Content-Type": "application/json"}, body: body);
    statusCode = response.statusCode;
    if (response.statusCode == 200) {
      authKey = json.decode(response.body);
      key = authKey["authorization"];
      await preferences.setString('LastKey', key);
      await preferences.setString('LastUsername', _usernameController.text);
      await preferences.setString('LastPassword', _passwordController.text);
      print(' From Shared ' + preferences.getString('LastKey'));
      if (key != '') {
        inside = false;
        Navigator.of(context).pushReplacementNamed('/home');
        postItself();
      }else{
        print('alamadik');
        Alert(
          type: AlertType.warning,
          title: 'Kullanıcı adı ve ya Şifre yanlış',
          desc: "Şifrenizi unuttuysanız, şifremi unuttum'a tıklayarak şifrenizi yenileyebilirsiniz.",
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context,false),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
            DialogButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/forget'),
              child: Text('Şifremi unuttum', style: TextStyle(color: Colors.white),),
            ),
          ], context: context,
        ).show();
      }
    }else if(response.statusCode == 401){
      setState(() {
        key = null;
        print('key yok aga');
      });
    }
    print(response.body);
    return response;
  }

 Future<http.Response> postRequesAuto(String username, String password) async {
      Map data = {
        'username': username,
        'password': password
      };
      var body = json.encode(data);
      var response = await http.post('http://68.183.222.16:8080/api/userAccount/login', headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode == 200) {
        authKey = json.decode(response.body);
        key = authKey["authorization"];
        if (key != '') {
          setState(() {
            inside = false;
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else {
          inside = true;
        }
      }
    return response;
  }

  Future<List<Questions>> _fetchQuestions() async{
    var response = await http.get(securityQuestions);
    if(response.statusCode == 200){
      final items = json.decode(response.body).cast<Map<String,dynamic>>();
      List<Questions> listQuestions = items.map<Questions>((json){
        return Questions.fromJson(json);
      }).toList();

      return listQuestions;
    }
    else{
      throw Exception('Failed to load internet');
    }
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

  getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
  } 

  Future<http.Response> postItself() async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": key,
    });

    if(response.statusCode == 200){
      user = json.decode(response.body);
        var userInfo = User.fromJson(user);
        userInformations.add(userInfo);  
        return response;
    }else{
      throw Exception('postItself');
    }
  }

    Future<http.Response> postItselfAuto(String keyJson) async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": keyJson.toString(),
    });
    print(response.body);
    if(response.statusCode == 200){
        user = json.decode(response.body);
        var userInfo = User.fromJson(user);
        userInformations.add(userInfo);  
        return response;
      }else{
        throw Exception('postItselfAuto');
    }
  }

    @override
  void initState() { 
    super.initState();
    getKey();
    print(keyShared);
    if(keyShared != null){
      setState(() {
        postRequesAuto(username, password);
        postItselfAuto(key);
      });
    }else{
      setState(() {
        print('hahaha');
      });
    }
  }
  var textStyle = TextStyle(
    fontSize: 12.0,
    color: Colors.white,
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.w600);

void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ) ,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            SizedBox(width: 10,),
            new Text("  Giriş Yapılıyor ",style: TextStyle(color: Colors.white),),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(milliseconds: 2000), () {
    Navigator.pop(context); //pop dialog
      postRequest();
  });
}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    tabController = new TabController(length: 2, vsync: this);
    var tabBarItem = new TabBar(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.white24, width: SizeConfig.blockSizeHorizontal*2, style: BorderStyle.solid),
        insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
      ),
      unselectedLabelColor: Colors.white54,
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelStyle: textStyle.copyWith(
      fontSize: 20.0,
      color: Color(0xFFc9c9c9),
      fontWeight: FontWeight.w700),
      labelStyle: textStyle.copyWith(
      fontSize: 20.0,
      color: Color(0xFFc9c9c9),
      fontWeight: FontWeight.w700),
      tabs: <Widget>[
        Tab(
          child: Text('Giriş Yap'),
        ),
        Tab(
          child: Text('Yeni Üye'),
        )
      ],
      controller: tabController,
      indicatorColor: Colors.transparent,
      isScrollable: false,
      labelColor: Colors.white,
    );
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          Navigator.of(context).pushReplacementNamed('/splash');
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              elevation: 0,
              bottom: tabBarItem,
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              Container(
                color: Colors.lightBlueAccent,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Card(
                        elevation: 12,
                        borderOnForeground: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "Kullanıcı Adı",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: "Şifre",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "RobotoMono",
                              ),
                            ),
                            SizedBox(height: 20,),
                            SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),
                            CupertinoButton(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*20),
                              onPressed: () {
                                if(_usernameController.text == '' || _passwordController.text == ''){
                                  inside = true;
                                  print('yanlis giris');
                                  Alert(
                                    type: AlertType.warning,
                                    title: 'Kullanıcı adı ve ya şifre boş',
                                    desc: "Lütfen giriş yapabilmek için, boşlukları doldurunuz.",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () => Navigator.pop(context,false),
                                        child: Text('Tamam', style: TextStyle(color: Colors.white),),
                                      ),
                                      DialogButton(
                                        onPressed: () => Navigator.of(context).pushReplacementNamed('/forget'),
                                        child: Text('Şifremi unuttum', style: TextStyle(color: Colors.white),),
                                      ),
                                    ], context: context,
                                  ).show();
                                }else{
                                  _onLoading();
                                }
                              },
                              child: Text(
                                'Giriş Yap',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.lightBlueAccent,
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical*2,),
                            FlatButton(
                              onPressed: () => Navigator.of(context)
                                  .pushReplacementNamed('/forget'),
                              child: Text(
                                'Şifremi unuttum',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                          )
                          ),
                      )
                    ),
                  ],
                ),
              ),
              Container(
                child: ListView(
                  children: <Widget>[
                    Form(
                      autovalidate: _validate,
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Kullanıcı adınız, boşluk olmadan büyük harf kücük harf rakamlar yada . - _ olusacak sekilde en az 3, en fazla 15 karakter olmalıdır.',),
                                ],
                              )
                            ),
                            TextFormField(
                              controller: _username,
                              decoration: InputDecoration(
                                labelText: "* Kullanıcı Adı",
                                fillColor: Colors.white,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              validator: validateUsername,
                              onSaved: (String val) {
                                username = val;
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                            ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Şifre en az 5 haneli ve sayılardan oluşmalıdır.',),
                                ],
                              )
                            ),
                            TextFormField(
                              controller: _password,
                              decoration: InputDecoration(
                                labelText: "* Şifre",
                                fillColor: Colors.white,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              validator: validatePassword,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                            TextFormField(
                              controller: _password2,
                              decoration: InputDecoration(
                                labelText: "* Şifre tekrar",
                                fillColor: Colors.white,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
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
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Lütfen adınızı giriniz!";
                                } else {
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
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Lütfen soyadınızı giriniz";
                                } else {
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Lütfen telefon numarınızı "0" olmadan giriniz',),
                                  SizedBox(height: 5,),
                                  Text('Telefon numaranız Ev telefonuysa 7, Cep telefonuysa 11 haneli olmalıdır.',),
                                ],
                              )
                            ),
                            TextFormField(
                              controller: _phoneNumber,
                              validator: validatePhoneNumber,
                              decoration: InputDecoration(
                                labelText: "* Telefon numarası",
                                fillColor: Colors.white,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(),
                            ),
                            TextFormField(
                              controller: _address,
                              decoration: InputDecoration(
                                labelText: "* Adres bilgisi",
                                fillColor: Colors.white,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: <Widget>[
                                FutureBuilder<List<Questions>>(
                                  future: _fetchQuestions(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Questions>> snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();
                                    return DropdownButton<Questions>(
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                      items: snapshot.data
                                          .map((question) =>
                                              DropdownMenuItem<Questions>(
                                                child: Text(question.question),
                                                value: question,
                                              ))
                                          .toList(),
                                      onChanged: (Questions questions) {
                                        setState(() {
                                          currentQuestion = questions;
                                          setQuestion = questions.id;
                                        });
                                      },
                                      isExpanded: true,
                                      elevation: 20,
                                      hint: Text('Lütfen bir soru seçiniz'),
                                    );
                                  },
                                ),
                                currentQuestion != null
                                    ? Text(
                                        'Soru : ' + currentQuestion.question,
                                        style: TextStyle(fontSize: 20),
                                      )
                                    : Text('')
                              ],
                            ),
                            TextFormField(
                              controller: _answer,
                              maxLength: null,
                              decoration: InputDecoration(
                                labelText: "* Cevap",
                                fillColor: Colors.white,
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightBlueAccent),
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
                      contentPadding:
                          EdgeInsets.only(top: 0, left: 5, right: 5),
                      subtitle: Text(
                          'Bilgilerinizi giriş yaptıktan sonra "Bilgilerimi düzenle" sayfasından düzenleyebilirsiniz.'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _agreedToTOS,
                            onChanged: _setAgreedToTOS,
                          ),
                          GestureDetector(
                            onTap: () => _setAgreedToTOS(!_agreedToTOS),
                            child: Text(
                              'Şartlar, Hizmetler ve Gizlilik Politikasını kabul ediyorum', style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*3),
                            ),
                          ),
                        ],
                      )),
                    ListTile(
                      title: MaterialButton(
                        onPressed: () {
                          //_submittable() ?  : null;
                          if (_formKey.currentState.validate()) {
                            if(_password.text == _password2.text){
                              _formKey.currentState.save();
                              postRegisterRequest();
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: 'Başarıyla kayıt oldunuz!',
                                buttons: [
                                  DialogButton(
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacementNamed('/login'),
                                    child: Text('Giriş sayfası',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ).show();
                            }else{
                              Alert(
                                context: context,
                                type: AlertType.warning,
                                title: 'Şifreler aynı değil',
                                buttons: [
                                  DialogButton(
                                    onPressed: () => Navigator.pop(context,false),
                                    child: Text('Tamam',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ).show();
                            }
                          } else {
                            setState(() {
                              _validate = true;
                            });
                          }
                        },
                        child: Text('Yeni Üye', style: TextStyle(color: Colors.white),),
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool _submittable() {
    return _agreedToTOS;
  }
  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
  // _checkInternetConnectivity() async{
  //   var result = await Connectivity().checkConnectivity();
  //   if(result == ConnectivityResult.none){
  //     internet = false;
  //     return Alert(
  //         context:context,
  //         type: AlertType.error,
  //         desc: 'Şu an herhangi bir internet bağlantınız bulunmamaktadır. Uygulamayı kullanabilmeniz için internet '
  //             'bağlantısı gereklidir.',
  //         title: '',
  //         buttons: [
  //           DialogButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('Tamam', style: TextStyle(color: Colors.white),),
  //           ),
  //         ]
  //     ).show();
  //   }
  //   internet = true;
  // }
}
class Questions{
  int id;
  String question;

  Questions({this.id, this.question});

  factory Questions.fromJson(Map<String, dynamic> json){
    return Questions(
      id: json['id'],
      question: json['question']
    );
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _forgetUsername = TextEditingController();
  final _forgetAnswer = TextEditingController();
  var _question;
  var newPass;
  bool isCorrectIntent = false;

  @override
  void initState() { 
    super.initState();
  }

  void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ) ,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            SizedBox(width: 10,),
            new Text(" Yükleniyor.. ",style: TextStyle(color: Colors.white),),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(milliseconds: 1500), () {
    Navigator.pop(context); //pop dialog
      getQuestion();
  });
}

  Future<http.Response> forgetPassRequest() async{
    var response = await http.put(Uri.encodeFull(
        'http://68.183.222.16:8080/api/userAccount/resetPassword/?username='
        '${_forgetUsername.text}&securityQuestionAnswer=${_forgetAnswer.text}'));
        print('request body' + response.body);

    if(response.statusCode == 201){
      user = json.decode(response.body);
      newPass = user['password'];
      isCorrectIntent = true;
        return showDialog(
          context: context,
          builder: (context)=>AlertDialog(
            title: SelectableText(
                'Yeni Şifreniz: \n\n$newPass'
            ),
            content: Text('Üstüne basılı tutarak kopyalayabilirsiniz'),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                child: Text('Giriş Sayfası'),
              ),
            ],
          )
        );
    }
    showDialog(
          context: context,
          builder: (context)=>AlertDialog(
            title: Text('Kullanıcı adı ve ya cevabınız yanlış'),
            content: Text('Şifrenizi değiştirmek için gerekli bilgileri doğru şekilde girmeniz gerekmektedir.'),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context,false),
                child: Text('Tamam', style: TextStyle(color: Colors.black),),
              ),
            ],
          )
        );
    return response;
  }

  Future<String> getQuestion() async{
    var response = await http.get('http://68.183.222.16:8080/api/userAccount/securityQuestion/?username=${_forgetUsername.text}');
    print(response.statusCode);
    if(response.statusCode == 200){
      setState(() {

        var body = json.decode(response.body);
        _question = body['question'].toString();
      });
    }
    else if(response.statusCode == 204){
      setState(() {
        _question = null;
        Alert(
          context: context,
          title: 'Bu kullanıcı bulunamadı.',
          buttons: [
            DialogButton(child: Text('Tamam', style: TextStyle(color: Colors.white),),
            onPressed: ()=>Navigator.pop(context,false),
            )
          ]
        ).show();
      });
    }
    return _question;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Şifremi unuttum'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: ()=> Navigator.of(context).pushReplacementNamed('/home'),),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: 
                _question != null ?
                <Widget>[
                  SizedBox(height: 20,),
                  Text('Soru : $_question'),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _forgetAnswer,
                    decoration: InputDecoration(
                      labelText: "Cevap",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 20),
                    trailing: MaterialButton(
                      // ignore: missing_return
                      onPressed: (){
                          forgetPassRequest();
                      }, child: Text('Onayla', style: TextStyle(color: Colors.white),),color: Colors.lightBlueAccent,),
                  )
                ] 
                :
                <Widget>[
                  TextFormField(
                    controller: _forgetUsername,
                    decoration: InputDecoration(
                      labelText: "Kullanıcı Adı",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(top: 20),
                    trailing: MaterialButton(
                      // ignore: missing_return
                      onPressed: (){
                          _onLoading();
                      }, child: Text('Onayla', style: TextStyle(color: Colors.white),),color: Colors.lightBlueAccent,),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}


