import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _durum = 'Kapali';
    var _now = new DateTime.now();
    var _startTime = 09.00;
    var _endTime = 23.00;
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Hakkimizda'),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.timeline),
                title: Text('Servis Saati'),
                subtitle: Text('09:00 - 23:00'),
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Durum'),
                subtitle: _now.hour < _startTime || _now.hour > _endTime ? Text('Kapali', style: TextStyle(color: Colors.green),) : Text('Acik', style: TextStyle(color: Colors.red),),
              ),
              ListTile(
                leading: Icon(Icons.timelapse),
                title: Text('Servis Suresi'),
                subtitle: Text('45 DK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}