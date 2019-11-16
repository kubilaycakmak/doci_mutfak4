import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:doci_mutfak4/Model/size_config.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
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
  final String loginCheckUrl = 'http://68.183.222.16:8080/api/userAccount/login';
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  bool noUser;
  bool internet = true;
  var keyShared;
  bool switcha;

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }


    Future<http.Response> postItselfAuto(String keyJson) async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": keyJson.toString(),
    });
    print(response.body);
    if(response.statusCode == 200){
        noUser = false;
        var user = json.decode(response.body);
        var userInfo = User.fromJson(user);
        userInformations.add(userInfo);  
        return response;
      }else{
        //Navigator.of(context).pushReplacementNamed('/login');
        setState(() {
          noUser = true;
        });
        print(noUser);
        throw Exception('postItselfAuto');
    }
    
  }    
    getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
    if(key == ''){
      postItselfAuto(keyShared);
      postRequestAuto(username, password);
    }
  } 

      Future<http.Response> postRequestAuto(String username, String password) async {
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
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else {
        }
      }
    return response;
  }

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
    this.getKey();
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
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      floatingActionButton:SizedBox(
      height: 50,
      width: SizeConfig.blockSizeHorizontal*100,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              backgroundColor: Colors.lightBlueAccent,
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
          ]),
      ),
      body: Container(
        child: ListView.builder(
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
                          color: Colors.lightBlueAccent, fontSize: 20),
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
                      color: Colors.lightBlueAccent,
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
                      color: Colors.lightBlueAccent,
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
                      color: Colors.lightBlueAccent,
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
      bottomNavigationBar: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text(
                  "Tutar: ",
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                  finalPrice.toInt().toString() + " TL",
                  style: TextStyle(fontSize: 18),
                ),
                ),
              )
            ),
              Expanded(
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(0),
                  pressedOpacity: 0.8,
                  color: Colors.lightBlueAccent,
                  // ignore: missing_return
                  onPressed: (){
                      if(keyShared != ''){
                        if(inside == false){
                         if(internet == true){
                           listItems.length != 0 ?
                           Navigator.of(context).pushReplacementNamed('/endcart')
                               :
                           Alert(
                             style: alertStyle,
                             title: 'Sepet Boş',
                             desc: 'Boş sepet onaylanamaz',
                             buttons: [
                               DialogButton(
                                 onPressed: () => Navigator.pop(context,false),
                                 child: Text('Tamam', style: TextStyle(color: Colors.white),),
                               ),
                             ], context: context,
                           ).show();
                         }
                         else{
                           return Alert(
                             style: alertStyle,
                             title: 'Sipariş verebilmeniz için, İnternet bağlantınız olması gerekmektedir.',
                             buttons: [
                               DialogButton(
                                 onPressed: () => Navigator.pop(context,false),
                                 child: Text('Tamam', style: TextStyle(color: Colors.white),),
                               ),
                             ], context: context,
                           ).show();
                         }
                        }else{
                          return Alert(
                            style: alertStyle,
                            title: 'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context,false),
                                child: Text('Tamam', style: TextStyle(color: Colors.white),),
                              ),
                              DialogButton(
                                onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                              ),
                            ], context: context,
                          ).show();
                        }
                      }else{
                          return Alert(
                            style: alertStyle,
                              title: 'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                              buttons: [
                                DialogButton(
                                  onPressed: () => Navigator.pop(context,false),
                                  child: Text('Tamam', style: TextStyle(color: Colors.white),),
                                ),
                                DialogButton(
                                  onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                  child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                                ),
                              ], context: context,
                            ).show();
                      }
                  },
                  child: Text('Sepeti Onayla',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),
                  padding: EdgeInsets.all(25),
                ),
              )
            ],
          ),
      ),
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
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  var keyShared;
  bool noUser;
  final _addressController =new TextEditingController(text: listItems[0].address == null ? userInformations[0].address : listItems[0].address);
  final _phoneController =
  new TextEditingController(text: userInformations[0].phoneNumber);
  final String orderCreate = 'http://68.183.222.16:8080/api/order/create';
  final String paymentMethodsUrl =
      'http://68.183.222.16:8080/api/paymentmethod/all';
  var note = TextEditingController();

  Future<http.Response> postItselfAuto(String keyJson) async {
    var response = await http.get(Uri.encodeFull(getUserItself), headers: {
      "authorization": keyJson.toString(),
    });
    print(response.body);
    if(response.statusCode == 200){
        noUser = false;
        var user = json.decode(response.body);
        var userInfo = User.fromJson(user);
        userInformations.add(userInfo);  
        return response;
      }else{
        //Navigator.of(context).pushReplacementNamed('/login');
        setState(() {
          noUser = true;
        });
        print(noUser);
        throw Exception('postItselfAuto');
    }
    
  }    
    getKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keyShared = prefs.getString('LastKey');
    username = prefs.getString('LastUsername');
    password = prefs.getString('LastPassword');
    if(key == ''){
      postItselfAuto(keyShared);
      postRequestAuto(username, password);
    }
  } 

      Future<http.Response> postRequestAuto(String username, String password) async {
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
            Navigator.of(context).pushReplacementNamed('/home');
          });
        } else {
        }
      }
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

  int selectedPayment;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.getKey();
      this.postItself();
    });
    selectedPayment = 1;
  }

  setSelectedPayment(int val) {
    setState(() {
      selectedPayment = val;
    });
  }

    Future<http.Response> _sendOrders() async {
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
    var body = JSON.jsonEncode(or.toJson());
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
        postRequestAuto(username, password);
        postItselfAuto(keyShared);
      }else{
        setState(() {
        return Alert(
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
              onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
          context: context,
        ).show();
      });
      throw Exception('Failed to fetch sendOrders');
      }
      
    }
    else {
      setState(() {
        return Alert(
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
              onPressed: () => Navigator.pop(context,true),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
          context: context,
        ).show();
      });
      throw Exception('Failed to fetch sendOrders');
    } 
    return response;
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
                backgroundColor: Colors.lightBlueAccent,
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
                      ListTile(
                        title: Text('Teslimat Adresi'),
                        subtitle: TextFormField(
                          maxLines: 2,
                          controller: _addressController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none
                            )
                          ),
                        )),
                        Divider(thickness: 2,),
                      ListTile(
                        title: Text('Telefon Numarası'),
                        subtitle: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          controller: _phoneController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none
                            )
                          ),
                        )),
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
                              activeColor: Colors.lightBlueAccent,
                              onChanged: setSelectedPayment,
                            ),
                            RadioListTile(
                              title: Text('Kredi Karti'),
                              value: 2,
                              groupValue: selectedPayment,
                              activeColor: Colors.lightBlueAccent,
                              onChanged: setSelectedPayment,
                            ),
                            RadioListTile(
                              title: Text('Sodexo'),
                              value: 3,
                              groupValue: selectedPayment,
                              activeColor: Colors.lightBlueAccent,
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
            color: Colors.lightBlueAccent,
            // ignore: missing_return
            onPressed: (){
              if(key != ''){
                if(inside == false){
                  if(internet == true){
                    listItems.length != 0 ?
                    //_sendOrders()
                    _onLoading()
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
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Tamam', style: TextStyle(color: Colors.white),),
                    ),
                    DialogButton(
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
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Tamam', style: TextStyle(color: Colors.white),),
                  ),
                  DialogButton(
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
    _sendOrders();
  });
}
}

//@JsonSerializable()
class Order{
  var product;
  String note;
  Map payment;
  String address;
  String phoneNumber;

  Order(this.product, this.note, this.payment, this.address, this.phoneNumber);

  Map<String, dynamic> toJson() =>
      {
        'products': product,
        'note': note,
        'paymentMethod':payment,
        'address':address,
        'phoneNumber':phoneNumber
      };
}
