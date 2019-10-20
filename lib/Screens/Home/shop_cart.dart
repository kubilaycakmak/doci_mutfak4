import 'package:doci_mutfak4/Screens/Home/menu.dart';
import 'package:doci_mutfak4/Screens/Home/profile.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


void _showToast(BuildContext context, String desc) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(desc),
        action: SnackBarAction(
            label: 'Gizle', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
class ShoppingCart extends StatefulWidget {
  ShoppingCart({Key key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    double _count = 0;

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
                  title: Text(listItems[index].itemCount.toString() + ' x ' + listItems[index].name),
                  subtitle: Text('Urunu sepetten cikartmak icin basili tutunuz!'),
                  trailing: Text(((listItems[index].price)*(listItems[index].itemCount)).toInt().toString() + ' TL'),
                  onLongPress: (){
                    _showToast(context, "Urun Sepetten Cikartildi!");
                    setState(() {
                      listItems.removeAt(index);
                    });
                  },
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("+"),
                      onPressed: (){
                        setState(() {
                          listItems[index].itemCount++; 
                        });
                      },
                ),
                    RaisedButton(
                      child: Text("-"),
                        onPressed: (){
                        setState(() {
                          if (listItems[index].itemCount != 1) {
                            listItems[index].itemCount--; 
                          }
                        });
                      },
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text("Tutar: "),
                  subtitle: Text(_count.toString() + " TL"),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  color: Colors.lightBlueAccent,
                  onPressed: (){
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
                  child: Text('Siparisi ver!',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
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