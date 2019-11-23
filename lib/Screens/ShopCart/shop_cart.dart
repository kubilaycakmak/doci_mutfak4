import 'dart:async';

import 'package:doci_mutfak4/Connection/api_calls.dart';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Model/user.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Profile/profile.dart';
import 'package:doci_mutfak4/Validation/val.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final _countController = TextEditingController();
  User user;
  var user1;
  bool internet = true;
  bool switcha;
  Timer t;

  void _showToast(BuildContext context, String desc) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(milliseconds: 200),
        backgroundColor: Colors.black45,
        content: Text(
          desc,
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getKey();
  }

   @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double finalPrice = 0;
      setState(() {
        for (var item in listItems) {
          finalPrice += item.price * item.itemCount;
        }
      });
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(0, 40, 77,1),
        elevation: 0,
      ),
      floatingActionButton:SizedBox(
      height: SizeConfig.blockSizeVertical*22,
      child: Column(
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "btnTutar",
              backgroundColor: Colors.white70,
              onPressed: null,
              label: Text(
                  "Tutar: " + finalPrice.toInt().toString() + " TL",
                  style: TextStyle(fontSize: 15,color: Colors.black),
                ),
            ),
            SizedBox(height: 10,),
            FloatingActionButton.extended(
              heroTag: "btnEmpty",
              backgroundColor: Color.fromRGBO(0, 40, 77,1),
              label: Text('Sepeti Boşalt'),
              onPressed: (){
                setState(() {
                  if(listItems.length != 0){
                    listItems.clear();
                    _showToast(context,
                        "Sepet Boşaltıldı!");
                  }else{
                    _showToast(context,
                        "Sepet zaten boş!");
                }
                });
              },
            ),
            SizedBox(height: 10,),
            FloatingActionButton.extended(
              heroTag: "btnAccept",
              label: Text('Sepeti Onayla'),
              backgroundColor: Color.fromRGBO(0, 40, 77,1),
              onPressed: (){
                      if(key != ''){
                        if(inside == false){
                           listItems.length != 0 ?
                           sendOrderToFinishPage()
                               :
                           Alert(
                             style: alertStyle,
                             title: 'Sepet Boş',
                             desc: 'Boş sepet onaylanamaz',
                             buttons: [
                               DialogButton(
                                 color: Color.fromRGBO(0, 40, 77,1),
                                 onPressed: () => Navigator.pop(context,false),
                                 child: Text('Tamam', style: TextStyle(color: Colors.white),),
                               ),
                             ], context: context,
                           ).show();
                        }else{
                          return Alert(
                            style: alertStyle,
                            title: 'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                            buttons: [
                              DialogButton(
                                color: Color.fromRGBO(0, 40, 77,1),
                                onPressed: () => Navigator.pop(context,false),
                                child: Text('Tamam', style: TextStyle(color: Colors.white),),
                              ),
                              DialogButton(
                                color: Color.fromRGBO(0, 40, 77,1),
                                onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                              ),
                            ], context: context,
                          ).show();
                        }
                      }else if(keyShared != ''){
                        postRequestAuto(context, username, password);
                        postItselfAuto(keyShared);
                        Navigator.of(context).pushReplacementNamed('/endcart');
                      }
                      else{
                          return Alert(
                            style: alertStyle,
                              title: 'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                              buttons: [
                                DialogButton(
                                  color: Color.fromRGBO(0, 40, 77,1),
                                  onPressed: () => Navigator.pop(context,false),
                                  child: Text('Tamam', style: TextStyle(color: Colors.white),),
                                ),
                                DialogButton(
                                  color: Color.fromRGBO(0, 40, 77,1),
                                  onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                  child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                                ),
                              ], context: context,
                            ).show();
                      }
                  },
            ),
          ]),
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              movementDuration: Duration(milliseconds: 10),
              background: Container(
                alignment: Alignment.center,
                child: Text(
                  ' Ürün sepetten çıkartıldı. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.red,
              ),
              resizeDuration: Duration(milliseconds: 10),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  listItems[index].itemCount = 0;
                  listItems.removeAt(index);
                });
              },
              key: new ValueKey(listItems[index]),
              child: ExpansionTile(
                title: Row(
                  children: <Widget>[
                    Text(
                      listItems[index].itemCount.toString(),
                      style: TextStyle(
                          color: Color.fromRGBO(0, 40, 77,1), fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      listItems[index].name,
                      style: TextStyle(fontSize: 19),
                    )
                  ],
                ),
                      trailing: Text(
                    ((listItems[index].price) * (listItems[index].itemCount))
                            .toInt()
                            .toString() +
                        ' TL'),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      elevation: 0,
                      minWidth: 10,
                      color: Color.fromRGBO(0, 40, 77,1),
                      onPressed: (){
                        setState(() {
                          listItems[index].itemCount = 0;
                          listItems.removeAt(index);
                        });
                      },
                      child: Icon(Icons.delete, color: Colors.white,),
                    ),
                    MaterialButton(
                      elevation: 0,
                      minWidth: 10,
                      color: Color.fromRGBO(0, 40, 77,1),
                      onPressed: (){
                        setState(() {
                          listItems[index].itemCount++;
                        });
                      },
                      child: Icon(Icons.add_circle, color: Colors.white,),
                    ),
                    MaterialButton(
                      elevation: 0,
                      minWidth: 10,
                      color: Color.fromRGBO(0, 40, 77,1),
                      onPressed: (){
                        setState(() {
                          if(listItems[index].itemCount == 1){
                            listItems[index].itemCount = 1;
                          }else {
                            listItems[index].itemCount--;
                          }
                        });
                      },
                      child: Icon(Icons.remove_circle, color: Colors.white,),
                    ),
                  ],
                )
              ],
              ),
            );
          },
        ),
      ),

    );
  }
  sendOrderToFinishPage(){
    onLoad(context,'Lüften Bekleyiniz..');
      t = new Timer(Duration(milliseconds: 500), (){
      t.cancel();
      Navigator.of(context).pushReplacementNamed('/endcart');
    }
  );
  }
  var alertStyle = AlertStyle(
    isCloseButton: false,
    isOverlayTapDismiss: false,
    backgroundColor: Colors.white,
    animationDuration: Duration(milliseconds: 500),
    animationType: AnimationType.grow,
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );
}

User currentUser;

class EndOfTheShoppingCart extends StatefulWidget {

  String validatePhoneNumber(String value){
  Pattern cellphone = r'^((?!(0))[0-9]{7,11})$';
  RegExp regexPhone = new RegExp(cellphone);
  if(!regexPhone.hasMatch(value))
    return 'Ev telefonu ise 7, Cep telefonu ise 11 haneli olmalidir.';
  else
    return null;
}

  @override
  _EndOfTheShoppingCartState createState() => _EndOfTheShoppingCartState();
}
class _EndOfTheShoppingCartState extends State<EndOfTheShoppingCart> {
  var keyShared;
  bool noUser;
  bool validate = false;
  final _formKey = new GlobalKey<FormState>();
  final _addressController =new TextEditingController(text: listItems[0].address == null ? userInformations[0].address : listItems[0].address);
  final _phoneController =
  new TextEditingController(text: userInformations[0].phoneNumber);
  var note = TextEditingController();
  int selectedPayment;
  Timer t;

    getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
    if(key == ''){
      postItselfAuto(keyShared);
      postRequestAuto(context, username, password);
    }
  } 

  @override
  void initState() {
    super.initState();
    setState(() {
      this.getKey();
    });
    selectedPayment = 1;
  }

  setSelectedPayment(int val) {
    setState(() {
      selectedPayment = val;
    });
  }


  @override
  Widget build(BuildContext context) {
      double finalPrice = 0;
      setState(() {
        for (var item in listItems) {
          finalPrice += item.price * item.itemCount;
        }
      });
      return WillPopScope(
        // ignore: missing_return
          onWillPop: () {
            Navigator.of(context).pushReplacementNamed('/home');
            print('aq');
          },
          child: Scaffold(
      appBar: AppBar(
                backgroundColor: Color.fromRGBO(0, 40, 77,1),
                title: Text('Siparişi Onayla | Bitir'),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/home'),
                ),
              ),
      body: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Aşağıdaki bilgiler doğru ise değişiklik yapmadan ilerleyiniz.',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.2,
                                color: Colors.black45),
                          ),
                        ),
                      Divider(thickness: 2,),
                      Form(
                        key: _formKey,
                        autovalidate: validate,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('Teslimat Adresi'),
                                subtitle: TextFormField(
                                  autovalidate: true,
                                  validator: (val){
                                    if(val == ''){
                                      return 'Adres kısmı boş olamaz';
                                    }
                                  },
                                  maxLines: 2,
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    helperText: 'Başarılı ve hızlı bir teslimat için, Adresinizi açık ve anlaşılır bir şekilde giriniz.',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none
                                    )
                                  ),
                                )),
                                Divider(thickness: 2,),
                              ListTile(
                                title: Text('Telefon Numarası'),
                                subtitle: TextFormField(
                                  autovalidate: true,
                                  validator: validatePhoneNumber,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    helperText: 'Başında sıfır olmadan Ev ise 7, Cep ise 10 haneli olmalıdır',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide.none))))
                            ],
                          ),
                        ),
                      ),
                        Divider(thickness: 2,),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Odeme yontemleri', textAlign: TextAlign.center,),
                      ),
                      Divider(thickness: 2,),
                       Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            RadioListTile(
                              title: Text('Nakit'),
                              value: 1,
                              groupValue: selectedPayment,
                              activeColor: Color.fromRGBO(0, 40, 77,1),
                              onChanged: setSelectedPayment,
                            ),
                            RadioListTile(
                              title: Text('Kredi Karti'),
                              value: 2,
                              groupValue: selectedPayment,
                              activeColor: Color.fromRGBO(0, 40, 77,1),
                              onChanged: setSelectedPayment,
                            ),
                            RadioListTile(
                              title: Text('Sodexo'),
                              value: 3,
                              groupValue: selectedPayment,
                              activeColor: Color.fromRGBO(0, 40, 77,1),
                              onChanged: setSelectedPayment,
                            ),
                          ],
                        ),
                        Divider(thickness: 2,),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text('Siparis Ozeti', textAlign: TextAlign.center,),
                      ),
                      Divider(thickness: 2,),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: listItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                listItems[index].name,
                                style: TextStyle(fontSize: 13),
                              ),
                              trailing: Text(
                                ((listItems[index].price) *
                                    (listItems[index].itemCount))
                                    .toInt()
                                    .toString() +
                                    ' TL',
                                style: TextStyle(fontSize: 12),
                              ),
                              leading: InkWell(
                                child: Text(
                                  listItems[index].itemCount.toString(),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        ),
                        Divider(thickness: 2,),
                 Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Tutar : ' + finalPrice.toInt().toString() + ' TL',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Divider(thickness: 2,),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                          child: TextFormField(
                            maxLines: 2,
                            controller: note,
                            decoration: InputDecoration(
                              labelText: "Mesajınız",
                              hintText: "Boş bırakabilirsiniz",
                              hintMaxLines: 100,
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Divider(thickness: 2,),
                    ],
                  )),
          bottomNavigationBar: SingleChildScrollView(child: CupertinoButton(
            borderRadius: BorderRadius.circular(0),
            pressedOpacity: 0.2,
            color: Color.fromRGBO(0, 40, 77,1),
            // ignore: missing_return
            onPressed: (){
              if(key != ''){
                if(inside == false){
                  if(internet == true){
                    listItems.length != 0 ?
                      sendOrderSmallFucntion(context)
                        :
                    showDialog(
                        context: context,
                        builder: (context)=>AlertDialog(
                          title: Text('Sepet Boş'),
                          content: Text('Boş sepet onaylanamaz'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: ()=> Navigator.pop(context,false),
                              child: Text('Tamam', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    return Alert(
                      style: AlertStyle(
                                  animationDuration: Duration(milliseconds: 500),
                                  animationType: AnimationType.grow,
                                ),
                    title: 'İnternet Hatası',
                    desc:
                        'Sipariş verebilmeniz için, İnternet bağlantınız olması gerekmektedir.',
                    buttons: [
                      DialogButton(
                        color: Color.fromRGBO(0, 40, 77,1),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Tamam', style: TextStyle(color: Colors.white),),
                      ),
                    ],
                    context: context,
                  ).show();
                }
                }else{
                 return Alert(
                   style: AlertStyle(
                    animationDuration: Duration(milliseconds: 500),
                    animationType: AnimationType.grow,
                  ),
                  title: 'Kullanıcı bulunamadı',
                  desc:
                      'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                  buttons: [
                    DialogButton(
                      color: Color.fromRGBO(0, 40, 77,1),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Tamam', style: TextStyle(color: Colors.white),),
                    ),
                    DialogButton(
                      color: Color.fromRGBO(0, 40, 77,1),
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/login'),
                      child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                  context: context,
                ).show();
              }
              }else{
                return Alert(
                  style: AlertStyle(
                                  animationDuration: Duration(milliseconds: 500),
                                  animationType: AnimationType.grow,
                                ),
                title: 'Kullanıcı bulunamadı',
                desc:
                    'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                buttons: [
                  DialogButton(
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Tamam', style: TextStyle(color: Colors.white),),
                  ),
                  DialogButton(
                    color: Color.fromRGBO(0, 40, 77,1),
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                  ),
                ],
                context: context,
              ).show();
            }
                },
            child: Text('Siparişi Tamamla',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),
            ),
            padding: EdgeInsets.all(25),
            ),)
        ));
  }
  sendOrderSmallFucntion(BuildContext context){
  onLoad(context,'Sipariş Gönderiliyor..');
  t = new Timer(Duration(milliseconds: 2500), (){
      sendOrderFunc(context, selectedPayment, _addressController, _phoneController, note);
      t.cancel();
      Navigator.pop(context);
    }
  );
}

}


