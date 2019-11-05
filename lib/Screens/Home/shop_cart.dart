import 'dart:convert' as JSON;
import 'dart:convert';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final _countController = new TextEditingController();
  User user;
  bool internet = true;

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    double finalPrice = 0;
      setState(() {
        for (var item in listItems) {
          finalPrice += item.price * item.itemCount;
        }
      });
    SizeConfig().init(context);
    //double _count = 0;
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
            ),
            Expanded(
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(0),
                pressedOpacity: 0.8,
                color: Colors.lightBlueAccent,
                // ignore: missing_return
                onPressed: () {
                  if (key != '') {
                    if (inside == false) {
                      if (internet == true) {
                        listItems.length != 0
                            ? Navigator.of(context)
                                .pushReplacementNamed('/endcart')
                            : Alert(
                                style: alertStyle,
                                title: 'Sepet Boş',
                                desc: 'Boş sepet onaylanamaz',
                                buttons: [
                                  DialogButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Tamam', style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                                context: context,
                              ).show();
                      } else {
                        return Alert(
                          style: alertStyle,
                          title:
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
                    } else {
                      return Alert(
                        style: alertStyle,
                        title:
                            'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Tamam', style: TextStyle(color: Colors.white),),
                          ),
                          DialogButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed('/login'),
                            child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                          ),
                        ],
                        context: context,
                      ).show();
                    }
                  } else {
                    return Alert(
                      style: alertStyle,
                      title:
                          'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                      buttons: [
                        DialogButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Tamam', style: TextStyle(color: Colors.white),),
                        ),
                        DialogButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed('/login'),
                          child: Text('Üye girişi', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                      context: context,
                    ).show();
                  }
                },
                child: Text(
                  'Sepeti Onayla',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
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
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    backgroundColor: Colors.white,
    animationDuration: Duration(milliseconds: 400),
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
  @override
  _EndOfTheShoppingCartState createState() => _EndOfTheShoppingCartState();
}

class _EndOfTheShoppingCartState extends State<EndOfTheShoppingCart> {
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  final _addressController =
  new TextEditingController(text: userInformations[0].address);
  final _phoneController =
  new TextEditingController(text: userInformations[0].phoneNumber);
  final String orderCreate = 'http://68.183.222.16:8080/api/order/create';
  final String paymentMethodsUrl =
      'http://68.183.222.16:8080/api/paymentmethod/all';
  var note = TextEditingController();


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
      postItself();
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
    Order or = Order(listId, note.text, payment,_addressController.text);
    print(or);
    print(or.toJson());
    var body = JSON.jsonEncode(or.toJson());
    print(body);
    var response = await http.post(Uri.encodeFull(orderCreate),
        headers: {
          "content-type" : "application/json",
          "accept": "application/json",
          "authorization": key,
        },
        body: body);
    print(response.body);
    if (response.statusCode == 201) {
        listItems.clear();
         Alert(
          type: AlertType.success,
          title: 'Siparişiniz Verildi',
          desc:
          'Menünüz hazırlanıyor, Bizi seçtiğiniz için teşekkür ederiz!',
          buttons: [
            DialogButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ],
          context: context,
        ).show();

    } else {
      setState(() {
        return Alert(
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
                centerTitle: true,
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
                      Card(
                        margin: EdgeInsets.all(5),
                        elevation: 0.2,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Aşağıdaki bilgiler doğru ise değişiklik yapmadan ilerleyiniz.',
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.2,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.all(5),
                        elevation: 1,
                        child: ListTile(
                            title: Text('Teslimat Adresi'),
                            subtitle: TextFormField(
                              maxLines: 3,
                              controller: _addressController,
                              decoration: InputDecoration(),
                            )),
                      ),
                      Card(
                        margin: EdgeInsets.all(5),
                        elevation: 1,
                        child: ListTile(
                            title: Text('Telefon Numarası'),
                            subtitle: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(),
                            )),
                      ),
                      Card(
                        margin: EdgeInsets.all(5),
                        elevation: 1,
                        child: Column(
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
                      ),
                      Card(
                        margin: EdgeInsets.all(5),
                        elevation: 1,
                        child: ListView.builder(
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
                      ),
                      Card(
                        elevation: 1,
                        margin: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Tutar : ' + finalPrice.toInt().toString() + ' TL',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 1,
                        margin: EdgeInsets.all(5),
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, bottom: 0),
                          child: TextFormField(
                            maxLines: 10,
                            controller: note,
                            decoration: InputDecoration(
                              labelText: "Mesajınız",
                              hintText: "Boş bırakabilirsiniz",
                              hintMaxLines: 100,
                              fillColor: Colors.white,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors
                                    .lightBlueAccent),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              bottomNavigationBar: CupertinoButton(
                borderRadius: BorderRadius.circular(0),
                pressedOpacity: 0.2,
                color: Colors.lightBlueAccent,
                // ignore: missing_return
                onPressed: () {
            if (key != '') {
              if (inside == false) {
                if (internet == true) {
                  listItems.length != 0
                      ? _sendOrders()
                      : showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Sepet Boş'),
                                content: Text('Boş sepet onaylanamaz'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text('Tamam'),
                                  ),
                                ],
                              ));
                } else {
                  return Alert(
                    title: 'İnternet Hatası',
                    desc:
                        'Sipariş verebilmeniz için, İnternet bağlantınız olması gerekmektedir.',
                    buttons: [
                      DialogButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Tamam'),
                      ),
                    ],
                    context: context,
                  ).show();
                }
              } else {
                return Alert(
                  title: 'Kullanıcı bulunamadı',
                  desc:
                      'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                  buttons: [
                    DialogButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Tamam'),
                    ),
                    DialogButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/login'),
                      child: Text('Üye girişi'),
                    ),
                  ],
                  context: context,
                ).show();
              }
            } else {
              return Alert(
                title: 'Kullanıcı bulunamadı',
                desc:
                    'Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.',
                buttons: [
                  DialogButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Tamam'),
                  ),
                  DialogButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: Text('Üye girişi'),
                  ),
                ],
                context: context,
              ).show();
            }
                },
                child: Text(
                  'Siparişi Tamamla',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                padding: EdgeInsets.all(25),
              )));
    }
  }

@JsonSerializable()
class Order{
  var product;
  String note;
  Map payment;
  String address;

  Order(this.product, this.note, this.payment, this.address);

  Map<String, dynamic> toJson() =>
      {
        'products': product,
        'note': note,
        'paymentMethod':payment,
        'address':address,
      };
}