import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:doci_mutfak4/Model/payment.dart';
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

class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  var _countOfIndex = new TextEditingController();
  final _countController = new TextEditingController();
  User user;
  var _messageController = new TextEditingController();
  bool internet = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _count = 0;
    double sideLength = 50;
    setState(() {
      for (var item in listItems) {
        _count = _count + item.price * item.itemCount;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              movementDuration: Duration(seconds: 2),
              background: Container(
                child: Text(
                  ' Ürün sepetten çıkartıldı. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.lightBlueAccent,
              ),
              resizeDuration: null,
              onDismissed: (DismissDirection direction) {
                setState(() {
                  listItems[index].itemCount = 0;
                  listItems.removeAt(index);
                });
              },
              key: new ValueKey(listItems[index]),
              child: ListTile(
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
                onTap: () {
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: Colors.lightBlueAccent,
                              elevation: 0,
                              titlePadding: EdgeInsets.all(0),
                              title: Column(
                                children: <Widget>[
                                  CupertinoButton(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.lightBlueAccent,
                                    child: Text('Adet Güncelle'),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Adet Giriniz',
                                                  textAlign: TextAlign.center,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                elevation: 0,
                                                content: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 100, right: 100),
                                                    width: 20,
                                                    child: TextFormField(
                                                      controller: _countOfIndex,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(),
                                                    )),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Tamam'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                ],
                                              ));
                                    },
                                  ),
                                  CupertinoButton(
                                    color: Colors.lightBlueAccent,
                                    child: Text('Sepetten Çıkar'),
                                    onPressed: () {
                                      setState(() {
                                        listItems[index].itemCount = 0;
                                        listItems.removeAt(index);
                                        Navigator.pop(context, false);
                                      });
                                    },
                                  ),
                                  CupertinoButton(
                                    color: Colors.lightBlueAccent,
                                    child: Text('Geri'),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  )
                                ],
                              ),
                            ));
                  });
                },
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
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  _count.toInt().toString() + " TL",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Expanded(
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(0),
                pressedOpacity: 0.2,
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
                                    child: Text('Tamam'),
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
                              child: Text('Tamam'),
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
                            child: Text('Tamam'),
                          ),
                          DialogButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed('/login'),
                            child: Text('Üye girişi'),
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
                          child: Text('Tamam'),
                        ),
                        DialogButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed('/login'),
                          child: Text('Üye girişi'),
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
  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      internet = false;
      return Alert(
          context: context,
          style: alertStyle,
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

PaymentMethods currentPayment;
User currentUser;

class EndOfTheShoppingCart extends StatefulWidget {
  @override
  _EndOfTheShoppingCartState createState() => _EndOfTheShoppingCartState();
}

class _EndOfTheShoppingCartState extends State<EndOfTheShoppingCart> {
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  final _addressController =
      new TextEditingController(text: currentUser.address);
  final _phoneController =
      new TextEditingController(text: currentUser.phoneNumber);
  final String orderCreate = 'http://68.183.222.16:8080/api/order/create';
  final String paymentMethodsUrl =
      'http://68.183.222.16:8080/api/paymentmethod/all';
  var note = TextEditingController();
  Future<http.Response> _sendOrders() async {
    Map data = {
      "products": [
        for (int i = 0; i < listItems.length; i++)
          {
            {
              "dociProduct": {"id": listItems[i].id},
              "quantity": listItems[i].quantity,
            },
          }
      ],
      "note": note.text,
      "paymentMethod": {
        "id": currentPayment.id,
      }
    };

    var body = jsonEncode(data);
    var response = await http.post(orderCreate,
        headers: {
          "content-Type": "application/json",
          "authorization": key,
        },
        body: body);

    if (response.statusCode == 201) {
      print('Order sended succusfully');
    } else {
      throw Exception('Failed to fetch sendOrders');
    }
    return response;
  }

  Future<List<PaymentMethods>> _paymentMethods() async {
    print(listItems.length);
    var response = await http.get(paymentMethodsUrl);
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<PaymentMethods> listPayments = items.map<PaymentMethods>((json) {
        return PaymentMethods.fromJson(json);
      }).toList();
      return listPayments;
    } else {
      throw Exception('Failed to load paymentMethods');
    }
  }

  @override
  Widget build(BuildContext context) {
    double finalPrice = 0;
    setState(() {
      for (var item in listItems) {
        finalPrice += item.price * item.itemCount;
      }
    });
    return Scaffold(
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
            color: Colors.grey[100],
            child: ListView(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(5),
                  elevation: 3,
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
                  elevation: 3,
                  child: ListTile(
                      title: Text('Teslimat Adresi'),
                      subtitle: TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(),
                      )),
                ),
                Card(
                  margin: EdgeInsets.all(5),
                  elevation: 3,
                  child: ListTile(
                      title: Text('Telefon Numarası'),
                      subtitle: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(),
                      )),
                ),
                Card(
                  margin: EdgeInsets.all(5),
                  elevation: 3,
                  child: FutureBuilder<List<PaymentMethods>>(
                    future: _paymentMethods(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PaymentMethods>> snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return DropdownButton<PaymentMethods>(
                        items: snapshot.data
                            .map((payments) => DropdownMenuItem<PaymentMethods>(
                                  child: Text(payments.name),
                                  value: payments,
                                ))
                            .toList(),
                        onChanged: (PaymentMethods paymentMethods) {
                          setState(() {
                            currentPayment = paymentMethods;
                            print(currentPayment.name);
                          });
                        },
                        hint: Text('Lütfen bir'),
                        isDense: false,
                        underline: Container(),
                      );
                    },
                  ),
                ),
                Container(
                  child: Card(
                    margin: EdgeInsets.all(5),
                    elevation: 3,
                    child: currentPayment != null
                        ? Text(
                            currentPayment.name,
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          )
                        : Text('Soru yok'),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(5),
                  elevation: 3,
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
                  elevation: 3,
                  margin: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Tutar : ' + finalPrice.toInt().toString() + ' TL',
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(5),
                  child: TextFormField(
                    controller: note,
                    decoration: InputDecoration(
                      labelText: "Mesajınız",
                      hintMaxLines: 100,
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "Poppins",
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
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          padding: EdgeInsets.all(25),
        ));
  }
}

void _addressBottomSheet(context) {
  showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text('Address'),
              )
            ],
          ),
        );
      });
}
