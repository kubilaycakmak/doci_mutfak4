import 'package:doci_mutfak4/Screens/Account/login_register.dart';
import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
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
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index){
            return Column(
              children: <Widget>[
                ListTile(
                  leading: InkWell(
                    child: Icon(Icons.delete_outline, size: 40, color: Colors.black,),
                      onTap: (){
                        setState(() {
                            listItems[index].itemCount = 0;
                            listItems.removeAt(index);
                        });
                      },
                  ),
                  title: Text(listItems[index].itemCount.toString() + ' x ' + listItems[index].name,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  subtitle: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          child: Icon(Icons.add, size: 30,),
                          onTap: (){
                            setState(() {
                              listItems[index].itemCount++;
                            });
                          },
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          child: Icon(Icons.remove, size: 30,),
                          onTap: (){
                            setState(() {
                              if (listItems[index].itemCount != 1) {
                                listItems[index].itemCount--;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                trailing: Text(((listItems[index].price)*(listItems[index].itemCount)).toInt().toString() + ' TL'),
                ),
              ],
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
                  onPressed: (){
                    print(key);
                    if (inside == false) {
                      print('Siparis verildi');
                      return Alert(
                        style: alertStyle,
                        context:context, 
                        type: AlertType.success,
                        title: 'Siparisi Basariyla verdin!',
                        desc: 'Siparisini kaydedebilir, bir sonraki siparisi daha hizli verebilirsin!',
                        buttons: [
                          DialogButton(
                            onPressed: null,
                            child: Text('Kaydet'),
                          ),
                          DialogButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Tamam'),
                          ),
                        ],
                      ).show(); 
                    } else {
                      return Alert(
                        style: alertStyle,
                        context:context, 
                        type: AlertType.warning,
                        desc: 'Siparis vermek icin sag alt menuden giris veya kayit olman gerekli!',
                        title: '',
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Tamam', style: TextStyle(color: Colors.white),),
                          ),
                        ]
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
}
var alertStyle = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: true,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(fontWeight: FontWeight.w400),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.lightBlueAccent,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.black,
      ),
);