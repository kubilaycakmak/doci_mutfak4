import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profilim'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0, bottom: 20),
          child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 20),
                color: Colors.lightBlueAccent,
            ),
            Container(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.black38,
                child: Text('A')
              ),
              color: Colors.black45,
            ),
            Center(
              child: Column(
                children: <Widget>[
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}