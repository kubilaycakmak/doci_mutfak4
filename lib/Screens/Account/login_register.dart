import 'package:connectivity/connectivity.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

TabController tabController;
final _formKey = new GlobalKey<FormState>();
bool _validate = false;
String username;
var authKey;
String key;
int statusCode;
bool internet = true;
bool isLoggedIn;
var user;
List<User> userInformations = new List();
List<User> getList() {
  return userInformations;
}
var usernameAuto;
var passwordAuto;
var keyAuto;
var statusForgetPass;
int setQuestion;
String currentQuest;
int statusValidator;
bool lock;
List num;

String validateUsername(String value) {
  Pattern pattern = r'^[a-zA-Z][a-zA-Z0-9._-]{3,15}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Kullanici ismini duzeltiniz!';
  else
    return null;
}

String validatePassword(String value) {
  Pattern pattern = r'^[a-zA-Z0-9._-]{5,15}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Sifrenizi duzeltiniz';
  else
    return null;
}

String validateAnswer(String value) {
  Pattern pattern = r'^[a-zA-Z0-9.-]{2,15}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Cevabinizi duzeltiniz';
  else
    return null;
}

String validatePhoneNumber(String value) {
  Pattern cellphone = r'^((?!(0))[0-9]{7,11})$';
  RegExp regexPhone = new RegExp(cellphone);
  if (!regexPhone.hasMatch(value))
    return 'Ev telefonu ise 7, Cep telefonu ise 11 haneli olmalidir.';
  else
    return null;
}

class LoginAndRegister extends StatefulWidget {
  @override
  _LoginAndRegisterState createState() => _LoginAndRegisterState();
}

class _LoginAndRegisterState extends State<LoginAndRegister>
    with TickerProviderStateMixin {
  Questions currentQuestion;
  final String loginCheckUrl =
      'http://68.183.222.16:8080/api/userAccount/login';
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  final String securityQuestions =
      'http://68.183.222.16:8080/api/securityQuestion/all';
  final String registerCheck =
      'http://68.183.222.16:8080/api/userAccount/create';
  final String changePass =
      'http://68.183.222.16:8080/api/userAccount/changePassword ';
  final String sendOrder = 'http://68.183.222.16:8080/api/order/create';
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _lastname = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _address = TextEditingController();
  final _answer = TextEditingController();
  

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');

    if (userId != null) {
      setState(() {
        inside = false;
        usernameAuto = userId;
      });
      return;
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);

    setState(() {
      usernameAuto = '';
      keyAuto = null;
      passwordAuto = '';
      inside = true;
    });
  }

  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('password', _passwordController.text);
    setState(() {
      usernameAuto = _usernameController.text;
      passwordAuto = _passwordController.text;
      keyAuto = key;
      inside = false;
    });
    _usernameController.clear();
  }

   @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  Future<http.Response> postRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };
    var body = json.encode(data);
    print('======================' + body);
    var response = await http.post(loginCheckUrl,
        headers: {"Content-Type": "application/json"}, body: body);
    setState(() {
      authKey = json.decode(response.body);
    });
    key = authKey["authorization"];
    prefs.setString('authorization', key);
    print(statusCode);
    if (response.statusCode == 200) {
      if (key != '') {
        inside = false;
        Navigator.of(context).pushReplacementNamed('/home');
        postItself();
      } else {
        inside = true;
        Alert(
          context: context,
          title: 'Kullanıcı adı ve ya Şifreniz yanlıştır',
          desc: 'Şifrenizi unuttuysanız, Şifremi unuttum ile sıfırlayabilirsiniz.',
          buttons: [
            DialogButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
        ).show();
      }
    }
    return response;
  }


  Future<List<Questions>> _fetchQuestions() async {
    var response = await http.get(securityQuestions);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Questions> listQuestions = items.map<Questions>((json) {
        return Questions.fromJson(json);
      }).toList();

      return listQuestions;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  Future<http.Response> postRegisterRequest() async {
    Map data = {
      "username": _username.text,
      "password": _password.text,
      "user": {
        "name": _name.text,
        "lastname": _lastname.text,
        "phoneNumber": _phoneNumber.text,
        "address": _address.text
      },
      "securityQuestion": {"id": currentQuestion.id},
      "answer": _answer.text
    };
    var body = json.encode(data);
    print(body);
    var response = await http.post(registerCheck,
        headers: {"Content-Type": "application/json"}, body: body);
    statusValidator = response.statusCode;
    return response;
  }

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
    userInformations.add(userInfo);
    return response;
  }

  bool remember = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    tabController = new TabController(length: 2, vsync: this);
    var tabBarItem = new TabBar(
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
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: "Kullanıcı Adı",
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
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
                              labelText: "Şifre",
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.lightBlueAccent),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "RobotoMono",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: <Widget>[
                              Text('Otomatik Giris'),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),
                              CupertinoSwitch(
                                onChanged: (val){
                                  if(val){
                                    setState(() {
                                      remember = true;
                                      loginUser();
                                    });
                                  }else{
                                    setState(() {
                                      remember = false;
                                      logout();
                                    });
                                  }
                                },
                                value: remember,
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal * 24,),
                              MaterialButton(
                                onPressed: () {
                                  if(!internet){
                                    _checkInternetConnectivity();
                                  }else{
                                    postRequest();
                                    loginUser();
                                  }
                                },
                                child: Text(
                                  'Giriş Yap',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.lightBlueAccent,
                              ),
                            ],
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
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      enabled: false,
                      subtitle: Text(
                          'Başarılı bir kayıt için yıldızlı alanları eksiksiz doldurunuz!'),
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
                                labelText: "* Kullanıcı Adı",
                                //helperText: 'Kullanıcı Adı ".(Nokta), -(Çizgi) veya _(alttan tire) \n içerebilir ve en az 3 en cok 15 karakterden oluşmalıdır!"',
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
                              leading: Icon(Icons.info_outline),
                              subtitle: Text(
                                'Lütfen telefon numarınızı "0" olmadan giriniz!',
                                style: TextStyle(fontSize: 12.5),
                              ),
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
                                        });
                                      },
                                      isExpanded: true,
                                      elevation: 20,
                                      hint: Text('Lütfen bir soru seçiniz'),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                currentQuestion != null
                                    ? Text(
                                        currentQuestion.question,
                                        style: TextStyle(fontSize: 20),
                                      )
                                    : Text('Soru yok')
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
                    ListTile(
                      enabled: false,
                      contentPadding:
                          EdgeInsets.only(top: 0, left: 5, right: 5),
                      subtitle: Text(
                        'Kullanıcı sözleşmesini ve Gizlilik Politikasını okudum ve kabul ediyorum.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    ListTile(
                      title: MaterialButton(
                        onPressed: () {
                          postRegisterRequest();
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
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

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      internet = false;
      return Alert(
          context: context,
          type: AlertType.error,
          desc:
              'Şu an herhangi bir internet bağlantınız bulunmamaktadır. Uygulamayı kullanabilmeniz için internet '
              'bağlantısı gereklidir.',
          title: '',
          buttons: [
            DialogButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tamam',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]).show();
    }
    internet = true;
  }
}

class Questions {
  int id;
  String question;

  Questions({this.id, this.question});

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(id: json['id'], question: json['question']);
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _forgetUsername = TextEditingController();
  final _forgetAnswer = TextEditingController();
  var newPass;

  Future<http.Response> forgetPassRequest() async {
    var response = await http.put(Uri.encodeFull(
        'http://68.183.222.16:8080/api/userAccount/resetPassword/?username='
        '${_forgetUsername.text}&securityQuestionAnswer=${_forgetAnswer.text}'));
    setState(() {
      user = json.decode(response.body);
    });
    newPass = user['password'];
    if (response.statusCode == 201) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: SelectableText('Yeni Şifreniz: \n\n$newPass'),
                content: Text('Üstüne basılı tutarak kopyalayabilirsiniz'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: Text('Giriş Sayfası'),
                  ),
                ],
              ));
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Şifremi unuttum'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _forgetUsername,
                    decoration: InputDecoration(
                      labelText: "Kullanici Adi",
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
                    controller: _forgetAnswer,
                    decoration: InputDecoration(
                      labelText: "Güvenlik sorusu cevabınız",
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
                    contentPadding: EdgeInsets.only(top: 20),
                    trailing: MaterialButton(
                      // ignore: missing_return
                      onPressed: () {
                        forgetPassRequest();
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
