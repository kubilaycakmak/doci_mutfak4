import 'package:doci_mutfak4/Connection/api.dart';
import 'package:doci_mutfak4/Connection/api_calls.dart';
import 'package:doci_mutfak4/Model/question.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Model/user.dart';
import 'package:doci_mutfak4/Screens/Profile/profile.dart';
import 'package:doci_mutfak4/Validation/val.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

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

class LoginAndRegister extends StatefulWidget {
  @override
  _LoginAndRegisterState createState() => _LoginAndRegisterState();
}
class _LoginAndRegisterState extends State<LoginAndRegister> with TickerProviderStateMixin {

Questions currentQuestion;
Timer t;
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
String userNamevalidate = 'Dogrula';
 
var textStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600);

Future<List<Questions>> _fetchQuestion() async{
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
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _formKey;
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
              backgroundColor: Color.fromRGBO(0, 40, 77,1),
            ),
          ),
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              Container(
                color: Color.fromRGBO(0, 40, 77,1),
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
                              keyboardType: TextInputType.text,
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
                                    style: AlertStyle(
                                      animationDuration: Duration(milliseconds: 500),
                                      animationType: AnimationType.grow,  
                                    ),
                                    title: 'Kullanıcı adı ve ya şifre',
                                    desc: "Lütfen giriş yapabilmek için, boşlukları doldurunuz.",
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
                                  onLoad(context, 'Giriş Yapılıyor..');
                                  t = new Timer(Duration(milliseconds: 1500), (){
                                    postRequest(context, _usernameController.text, _passwordController.text, '/home');
                                    Navigator.pop(context,false);
                                    t.cancel();
                                  }
                                );
                                }
                              },
                              child: Text(
                                'Giriş Yap',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color.fromRGBO(0, 40, 77,1),
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
                        child: FormUI()
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
                              'Şartlar, Hizmetler ve Gizlilik Politikasını kabul ediyorum', style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*3.3),
                            ),
                          ),
                        ],
                      )),
                    ListTile(
                      title: MaterialButton(
                        onPressed: () {
                          //_submittable() ?  : null;
                          if (_formKey.currentState.validate()) {
                            if(isValid == true){
                              _formKey.currentState.save();
                              postRegisterRequest(
                                _username,
                                _password,
                                _name,
                                _lastname,
                                _phoneNumber,
                                _address,
                                _answer
                              );
                              Alert(
                                style: AlertStyle(
                                  animationDuration: Duration(milliseconds: 500),
                                  animationType: AnimationType.grow,
                                ),
                                context: context,
                                type: AlertType.success,
                                title: 'Başarıyla kayıt oldunuz!',
                                buttons: [
                                  DialogButton(
                                    color: Color.fromRGBO(0, 40, 77,1),
                                    onPressed: () {
                                       Navigator.of(context)
                                        .pushReplacementNamed('/login');
                                    },
                                    child: Text('Giriş sayfası',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ).show();
                            }else{
                              Alert(
                                style: AlertStyle(
                                  isCloseButton: false,
                                  animationDuration: Duration(milliseconds: 500),
                                  animationType: AnimationType.grow,
                                ),
                                context: context,
                                type: AlertType.warning,
                                title: 'Kullanıcı adı mevcut!',
                                buttons: [
                                  DialogButton(
                                    color: Color.fromRGBO(0, 40, 77,1),
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
                        child: Text('Yeni Üye', style: TextStyle(color: Colors.white)),
                        padding: EdgeInsets.all(20),
                        color: Color.fromRGBO(0, 40, 77,1),
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

  var alertStyle = AlertStyle(
    isCloseButton: false,
    titleStyle: TextStyle(fontSize: 14, color: Colors.black),
    backgroundColor: Colors.white,
  );

  Widget FormUI(){
    return new Column(
      children: <Widget>[
        TextFormField(
          controller: _username,
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Kullanıcı adı',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            prefix: IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
               return Alert(
                context: context,
                title: 'Kullanıcı adınız, boşluk olmadan büyük harf kücük harf rakamlar yada . - _ olusacak sekilde en az 3, en fazla 15 karakter olmalıdır.',
                buttons: [
                  DialogButton(
                    child: Text('Kapat',style: TextStyle(color: Colors.white),),
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: ()=> Navigator.pop(context,false),
                  )
                ],
                style: alertStyle,
              ).show();
            },
          ),
          ),
          autocorrect: true,
          onChanged: (val){
            userCheck(_username.text);
          },
          onSaved: (val){
            setState(() {
              if(_formKey.currentState.validate()){
                _username.text = val;
              }else{
                print('wrong');
              }
            });
          },
          validator: validateUsername,
        ),
        ButtonBar(
          children: <Widget>[
            Container(
              width: SizeConfig.blockSizeHorizontal * 54,
              child: Text('Lütfen ilk önce doğrulama ile kullanıcı adı kullanılabilirliğinizi denetleyiniz.'),
            ),
            FlatButton(
              onPressed: (){
                showCupertinoDialog(
                  context: context,
                  builder: (context){
                    if(isValid == false){
                      return CupertinoAlertDialog(
                        title: Text('Kullanıcı adı mevcut'),
                        content: Text('Lütfen başka bir kullanıcı adı giriniz.',style: TextStyle(fontSize: 16),),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: ()=>Navigator.of(context).pop(),
                            child: Text('Tamam'),
                          )
                        ],
                      );
                    }else{
                      if(_username.text != ''){
                        return CupertinoAlertDialog(
                          title: Text('Mükemmel!'),
                          content: Text('Bu kullanıcı adı ile devam edebilirsiniz.',style: TextStyle(fontSize: 16),),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: ()=>Navigator.of(context).pop(),
                              child: Text('Tamam'),
                            )
                          ],
                        );
                      }else{
                        return CupertinoAlertDialog(
                          title: Text('Kullanıcı adı giriniz.'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: ()=>Navigator.of(context).pop(),
                              child: Text('Tamam'),
                            )
                          ],
                        );
                      }
                    }
                  }
                );
              }, 
              child: Text('Doğrulama'),)
          ],
        ),
        TextFormField(
          controller: _password,
          style: TextStyle(fontSize: 20, color: Colors.black),
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Şifre',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            prefix: IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
               return Alert(
                context: context,
                title: 'Şifre en az 5 haneli ve sayılardan oluşmalıdır.',
                buttons: [
                  DialogButton(
                    child: Text('Kapat',style: TextStyle(color: Colors.white),),
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: ()=> Navigator.pop(context,false),
                  )
                ],
                style: alertStyle,
              ).show();
            },
          ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _password.text = val;
            });
          },
          validator: validatePassword,
        ),
        SizedBox(height: 20,),
        TextFormField(
          autovalidate: true,
          controller: _password2,
          obscureText: true,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Şifre tekrar',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            prefix: IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
               return Alert(
                context: context,
                title: 'Şifre en az 5 haneli ve sayılardan oluşmalıdır.',
                buttons: [
                  DialogButton(
                    child: Text('Kapat',style: TextStyle(color: Colors.white),),
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: ()=> Navigator.pop(context,false),
                  )
                ],
                style: alertStyle,
              ).show();
            },
          ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _password.text = val;
            });
          },
          validator: (val){
            if(val != _password.text){
              return 'Şifreler aynı değil';
            }
          },  
        ),
        SizedBox(height: 20,),
        TextFormField(
          controller: _name,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Ad',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _name.text = val;
            });
          },
          validator: nameValidator,
        ),
        SizedBox(height: 20,),
        TextFormField(
          controller: _lastname,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Soyad',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _lastname.text = val;
            });
          },
          validator: nameValidator,
        ),
        SizedBox(height: 20,),
        TextFormField(
          controller: _phoneNumber,
          keyboardType: TextInputType.phone,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            helperText: '(5xx)-xxx-xxxx',
            helperStyle: TextStyle(fontSize: 18),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Telefon Numarası',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            prefix: IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
               return Alert(
                context: context,
                title: 'Telefon numaranız Ev telefonuysa 7, Cep telefonuysa 11 haneli olmalıdır.',
                buttons: [
                  DialogButton(
                    child: Text('Kapat',style: TextStyle(color: Colors.white),),
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: ()=> Navigator.pop(context,false),
                  )
                ],
                style: alertStyle,
              ).show();
            },
          ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _phoneNumber.text = val;
            });
          },
          validator: validatePhoneNumber,
        ),
        SizedBox(height: 20,),
        TextFormField(
          controller: _address,
          textInputAction: TextInputAction.done,
          style: TextStyle(fontSize: 20, color: Colors.black),
          maxLines: 3,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Sipariş Adresi',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            prefix: IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
               return Alert(
                context: context,
                title: ' Sipariş adresi doğru ve detaylı olmalıdır. Lütfen adresinizi okunur ve detaylı bir şekilde giriniz.',
                buttons: [
                  DialogButton(
                    child: Text('Kapat',style: TextStyle(color: Colors.white),),
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: ()=> Navigator.pop(context,false),
                  )
                ],
                style: alertStyle,
              ).show();
            },
          ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _address.text = val;
            });
          },
          validator: (val){
            if(val == null || val == ''){
              return 'Adres boş bırakılamaz';
            }
          },
        ),
        SizedBox(height: 20,),
        
        Column(
          children: <Widget>[
            FutureBuilder<List<Questions>>(
              future: _fetchQuestion(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Questions>> snapshot) {
                if (!snapshot.hasData)
                  return CircularProgressIndicator();
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DropdownButton<Questions>(
                  style: TextStyle(fontSize: 17, color: Colors.black),
                  items: snapshot.data.map((question) =>
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
                ),
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

        SizedBox(height: 20,),
        TextFormField(
          controller: _answer,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            filled: true,
            fillColor: Colors.black12,
            labelText: 'Cevabınız',
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          autocorrect: true,
          onChanged: (val){
          },
          onSaved: (val){
            setState(() {
              _answer.text = val;
            });
          },
          validator: validateAnswer,
        ),
      ]);
  }
  // bool _submittable() {
  //   return _agreedToTOS;
  // }
  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  Timer t;
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
  t = new Timer(Duration(milliseconds: 1000), (){
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
    Alert(
      title: 'Kullanıcı adı ve ya cevabınız yanlış',
      context: context,
      desc: 'Şifrenizi değiştirmek için gerekli bilgileri doğru şekilde girmeniz gerekmektedir.',
      type: AlertType.warning,
      style: AlertStyle(
        animationDuration: Duration(milliseconds: 500),
        animationType: AnimationType.grow
      ),
      buttons: [
        DialogButton(
          color: Color.fromRGBO(0, 40, 77,1),
          onPressed: ()=> Navigator.pop(context,false),
          child: Text('Tamam', style: TextStyle(color: Colors.white),),
        )
      ]
    ).show();
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
          style: AlertStyle(
            animationDuration: Duration(milliseconds: 500),
            animationType: AnimationType.grow,
          ),
          context: context,
          title: 'Bu kullanıcı bulunamadı.',
          buttons: [
            DialogButton(
              color: Color.fromRGBO(0, 40, 77,1),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
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
    return WillPopScope(
      onWillPop: (){
          return Navigator.of(context).pushReplacementNamed('/home');
        },
        child: Scaffold(
          appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 40, 77,1),
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
                  Text('Soru : $_question', style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 20,
                    
                  ),),
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
                      }, child: Text('Onayla', style: TextStyle(color: Colors.white),),color: Color.fromRGBO(0, 40, 77,1),),
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
                      }, child: Text('Onayla', style: TextStyle(color: Colors.white),),color: Color.fromRGBO(0, 40, 77,1),),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    ));
  }
}


