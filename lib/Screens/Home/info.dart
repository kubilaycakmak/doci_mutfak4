import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class Info extends StatefulWidget {
  Info({Key key}) : super(key: key);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String googleMapsApiKey = 'AIzaSyDPmrcF0KrfLKnTd-zDjj4IqNF3_sYGap8';
  Completer<GoogleMapController> _controller = Completer();
  final String isOpen = 'http://68.183.222.16:8080/api/time/isopen';
  bool isOpened = false;
    static final CameraPosition _dociMutfak = CameraPosition(
      target: LatLng(41.045497, 28.783106),
      zoom: 2.0);

  Future<String> storeOpenorNot() async{
    var response = await http.get(isOpen);
    var body = json.decode(response.body);
    print(body);
  }

  @override
  Widget build(BuildContext context) {
    print(storeOpenorNot());
    //AIzaSyDPmrcF0KrfLKnTd-zDjj4IqNF3_sYGap8
    return WillPopScope(
        // ignore: missing_return
        onWillPop: (){
          Navigator.of(context).pushReplacementNamed('/home');
          print('aq');
        },
      child : Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: null,
          label: Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.phone),
                SizedBox(width: 10,),
                Text('Bizi ara')
              ],
            ),
          ),
        ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: Text('Hakkımızda'),
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GoogleMap(
                  mapToolbarEnabled: true,
                  onTap: (val){
                    print('maps');
                  },
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _dociMutfak,
                  onMapCreated: (GoogleMapController controller){
                    _controller.complete(controller);
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.timeline),
                title: Text('Servis Saati'),
                subtitle: Text('09:00 - 23:00'),
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Durum'),
                subtitle: Text('asd'),
              ),
              ListTile(
                leading: Icon(Icons.timelapse),
                title: Text('Servis Süresi'),
                subtitle: Text('Max. 45 DK'),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}