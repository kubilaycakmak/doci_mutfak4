import 'package:connectivity/connectivity.dart';
import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Account/user.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final _countController = TextEditingController();
  User user;
  var _messageController = TextEditingController();
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
                itemBuilder: (context, index){
                  return Dismissible(
                    movementDuration: Duration(seconds: 2),
                    background: Container(child: Text(' Ürün sepetten çıkartıldı. ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20), ), color: Colors.lightBlueAccent,),
                    resizeDuration: null,
                    onDismissed: (DismissDirection direction){
                      setState(() {
                        listItems[index].itemCount = 0;
                        listItems.removeAt(index);
                      });
                    },
                    key: new ValueKey(listItems[index]),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(listItems[index].itemCount.toString(), style: TextStyle(color: Colors.lightBlueAccent, fontSize: 20),),
                          SizedBox(width: 10,),
                          Text(listItems[index].name, style: TextStyle(fontSize: 19),)
                        ],
                      ),
                      trailing: Text(((listItems[index].price)*(listItems[index].itemCount)).toInt().toString() + ' TL'),
                      onTap: (){
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (context)=>AlertDialog(
                                title: Column(
                                  children: <Widget>[
                                    CupertinoButton(
                                      child: Text('Adet Güncelle'),
                                      onPressed: (){
                                        Navigator.pop(context,false);
                                        showDialog(
                                            context: context,
                                            builder: (context)=>AlertDialog(
                                              elevation: 0,
                                              content: NumberPicker.integer(
                                                initialValue: listItems[index].itemCount,
                                                minValue: 1,
                                                maxValue: 10,
                                                onChanged: (val){
                                                  setState(() {
                                                    listItems[index].itemCount = val;
                                                  });
                                                }
                                              ),
                                              actions: <Widget>[
                                                CupertinoButton(
                                                  child: Text('Tamam'),
                                                  onPressed: (){
                                                    Navigator.pop(context,false);
                                                  },
                                                )
                                              ],
                                            )
                                        );
                                      },
                                    ),
                                    CupertinoButton(
                                      child: Text('Sepetten Çıkar'),
                                      onPressed: (){
                                        setState(() {
                                          listItems[index].itemCount = 0;
                                          listItems.removeAt(index);
                                          Navigator.pop(context,false);
                                        });
                                      },
                                    ),
                                    CupertinoButton(
                                      child: Text('Geri'),
                                      onPressed: ()=>Navigator.pop(context,false),
                                    )
                                  ],
                                ),
                              )
                          );
                          Alert(
                            style: alertStyle,
                            title: '',
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context,false),
                                child: Text('Tamam'),
                              ),
                              DialogButton(
                                onPressed: () => Navigator.pop(context,false),
                                child: Text('Tamam'),
                              ),
                              DialogButton(
                                onPressed: () => Navigator.pop(context,false),
                                child: Text('Tamam'),
                              ),
                            ],
                            context: context,
                          ).show();

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
                  title: Text("Tutar: ", style: TextStyle(fontSize: 20),),
                  subtitle: Text(_count.toInt().toString() + " TL", style: TextStyle(fontSize: 30),),
                ),
              ),
              Expanded(
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(0),
                  pressedOpacity: 0.2,
                  color: Colors.lightBlueAccent,
                  // ignore: missing_return
                  onPressed: (){
                      if(key != ''){
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
                                 child: Text('Tamam'),
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
                                 child: Text('Tamam'),
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
                                child: Text('Tamam'),
                              ),
                              DialogButton(
                                onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                child: Text('Üye girişi'),
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
                                  child: Text('Tamam'),
                                ),
                                DialogButton(
                                  onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                                  child: Text('Üye girişi'),
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
  _checkInternetConnectivity() async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      internet = false;
      return Alert(
          context:context,
          style: alertStyle,
          type: AlertType.error,
          desc: 'Şu an herhangi bir internet bağlantınız bulunmamaktadır. Uygulamayı kullanabilmeniz için internet '
              'bağlantısı gereklidir.',
          title: '',
          buttons: [
            DialogButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam', style: TextStyle(color: Colors.white),),
            ),
          ]
      ).show();
    }
    internet = true;
  }
}

class EndOfTheShoppingCart extends StatefulWidget {
  @override
  _EndOfTheShoppingCartState createState() => _EndOfTheShoppingCartState();
}

class _EndOfTheShoppingCartState extends State<EndOfTheShoppingCart> {
  final String getUserItself = 'http://68.183.222.16:8080/api/user/itself';
  final _addressController = new TextEditingController(text: userInformations[0].address);
  final _phoneController = new TextEditingController(text: userInformations[0].phoneNumber);

  @override
  Widget build(BuildContext context) {
    double finalPrice = 0;

    setState(() {
      for(var item in listItems){
        finalPrice += item.price * item.itemCount;
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Siparişi Onayla | Bitir'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=> Navigator.of(context).pushReplacementNamed('/home'),),
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
                child: Text('Aşağıdaki bilgiler doğru ise değişiklik yapmadan ilerleyiniz.', style: TextStyle(fontSize: 14, letterSpacing: 1.2,color: Colors.black45),),),
            ),
            Card(
              margin: EdgeInsets.all(5),
              elevation: 3,
              child: ListTile(
                title: Text('Teslimat Adresi'),
                subtitle: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                  ),
                )
              ),
            ),
            Card(
              margin: EdgeInsets.all(5),
              elevation: 3,
              child: ListTile(
                title: Text('Telefon Numarası'),
                subtitle: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                  ),
                )
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
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(listItems[index].name, style: TextStyle(fontSize: 13),),
                    trailing: Text(((listItems[index].price)*(listItems[index].itemCount)).toInt().toString() + ' TL', style: TextStyle(fontSize: 12),),
                    leading: InkWell(
                      child: Text(listItems[index].itemCount.toString(), style: TextStyle(fontSize: 12),),
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
                child: Text('Tutar : ' + finalPrice.toInt().toString() + ' TL', style: TextStyle(fontSize: 20, letterSpacing: 1.2, ),),
              ),
            )
          ],
        )
      ),
      bottomNavigationBar: CupertinoButton(
            borderRadius: BorderRadius.circular(0),
            pressedOpacity: 0.2,
            color: Colors.lightBlueAccent,
            // ignore: missing_return
            onPressed: (){
              if(key != ''){
                if(inside == false){
                  if(internet == true){
                    listItems.length != 0 ?
                    //ISLEM BURADA
                    print('object')
                        :
                    showDialog(
                        context: context,
                        builder: (context)=>AlertDialog(
                          title: Text('Sepet Boş'),
                          content: Text('Boş sepet onaylanamaz'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: ()=> Navigator.pop(context,false),
                              child: Text('Tamam'),
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    return showDialog(
                        context: context,
                        builder: (context)=>AlertDialog(
                          title: Text('Sipariş verebilmeniz için, İnternet bağlantınız olması gerekmektedir.'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: ()=> Navigator.pop(context,false),
                              child: Text('Tamam'),
                            ),
                          ],
                        )
                    );
                  }
                }else{
                  return showDialog(
                      context: context,
                      builder: (context)=>AlertDialog(
                        title: Text('Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: ()=> Navigator.pop(context,false),
                            child: Text('Tamam'),
                          ),
                          FlatButton(
                            onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                            child: Text('Üye girişi'),
                          )
                        ],
                      )
                  );
                }
              }else{
                return showDialog(
                    context: context,
                    builder: (context)=>AlertDialog(
                      title: Text('Siparişi başarılı bir şekilde verebilmeniz için, üye girişi yapmalısınız.'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: ()=> Navigator.pop(context,false),
                          child: Text('Tamam'),
                        ),
                        FlatButton(
                          onPressed: ()=> Navigator.of(context).pushReplacementNamed('/login'),
                          child: Text('Üye girişi'),
                        )
                      ],
                    )
                );
              }
            },
            child: Text('Siparişi Tamamla',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white
              ),
            ),
            padding: EdgeInsets.all(25),
            )
        );
  }
}
void _addressBottomSheet(context){
  showBottomSheet(context: context, builder: (BuildContext context){
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
