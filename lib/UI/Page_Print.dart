import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:escposprinter/escposprinter.dart';
import 'package:flutter_app_my_store/UI/Page_ChargeContinuity.dart';


class Page_Print extends StatefulWidget {
  const Page_Print({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _PagePrint createState() => new _PagePrint();
}

class _PagePrint extends State<Page_Print> {
  List devices = [];
  bool connected = false;

  @override
  initState() {
    super.initState();
    _list();
  }

  _list() async {
    List returned;
    try {
      returned = await Escposprinter.getUSBDeviceList;
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
    setState((){
      devices = returned;
    });
  }

  _connect(int vendor, int product) async {
    bool returned;
    try {
      returned = await Escposprinter.connectPrinter(vendor, product);
    } on PlatformException {
      //response = 'Failed to get platform version.';
    }
    if(returned){
      setState((){
        connected = true;
      });
    }
  }
  String _printLine(int line){

  }
  String _printProduct({String txt1,String txt2,double txt3}){
    String _txt=txt1;

    for(int i=0;_txt.length < 20;i++){
      _txt="${_txt} ";
    }
    _txt="${_txt}${txt2}";
    for(int i=0;_txt.length < 25;i++){
      _txt = "${_txt} ";
    }
    _txt="${_txt}${txt3/1000}k";
    for(int i=0;_txt.length < 32;i++){
      _txt="${_txt} ";
    }
    return _txt;

  }
  String _printTProduct({int quantity,double price,double t}){
    String _txt="${quantity}x${price/1000}k =";
    for(int i=0;_txt.length < 11;i++){
      _txt="${_txt} ";
    }
    _txt =_txt+"${t/1000}k VND\n";
    return _txt;

  }
  String _printCenter(String txt){
    if(txt.length > 32){
      return "${txt}\n";
    }else{
      String _txt=txt;
      for(int i=0;i < (32 - txt.length)/2;i++){
        _txt = " ${_txt}";
      }
      return "${_txt}\n";
    }
  }

  _print() async {
    var now = new DateTime.now();
    String _printTxt="";
    double _sum=0;
    _printTxt = _printTxt + "\n\n";
    _printTxt = _printTxt + "${removeDiacritics(_printCenter(widget.user.displayName))}\n";
    _printTxt = _printTxt + "${removeDiacritics(_printCenter("Phieu tinh tien"))}";
    _printTxt = _printTxt + "\n";
    _printTxt = _printTxt + "Thoi gian: ${now.day}-${now.month}-${now.year}  ${now.hour}:${now.minute}\n";
    _printTxt = _printTxt + "Khach hang: khach le.\n";
    _printTxt = _printTxt + "Mat hang:           Sl:  Gia:\n";
    await Firestore.instance.collection('Stores').document(widget.user.uid).collection('currentBill').getDocuments()
        .then((QuerySnapshot docs)async{
      docs.documents.map((DocumentSnapshot document) async {
        _printTxt = _printTxt + _printCenter("--------------");
        _printTxt = _printTxt+"${_printProduct(
            txt1: removeDiacritics(document['product']['name']),
            txt2: removeDiacritics(document['quantity'].toString()),
            txt3: document['product']['price'])}\n${
            _printTProduct(
                price: document['product']['price'],
                t: document['product']['price'] * document['quantity'],
                quantity: document['quantity'])}";
      }).toList();

      docs.documents.map((DocumentSnapshot document){
        setState(() {
          _sum = _sum + (document['product']['price'] * document['quantity']);
        });
      }).toList();

    });
    _printTxt = _printTxt + "\nTong cong: ${_sum/1000}k VND\n\n";
    _printTxt = _printTxt + _printCenter("Cam on quy khach");
    _printTxt = _printTxt + "\n\n\n";
    await Escposprinter.printText(_printTxt);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('In hóa đơn'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  _list();
                }
            ),
            connected == true ? new IconButton(
                icon: new Icon(Icons.print),
                onPressed: () {
                  _print();
                }
            ) : new Container(),
          ],
        ),
        body: devices.length > 0 ?

        new Stack(
          children: <Widget>[
            new ListView(
              scrollDirection: Axis.vertical,
              children: _buildList(devices),
            ),
            new Container(
              margin: EdgeInsets.only(top: 100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Page_ChargeContinuity(user: widget.user,isChargeDone: true)));
                    },
                    child: Text(
                      "Đã in xong!",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Colors.redAccent,

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
            )
          ],
        )
            : new Container(
          margin: EdgeInsets.only(top: 100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Page_ChargeContinuity(user: widget.user,isChargeDone: true)));
                },
                child: Text(
                  "Đã in xong!",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Colors.redAccent,

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildList(List devices){
    return devices.map((device) => new ListTile(
      onTap: () {
        _connect(int.parse(device['vendorid']), int.parse(device['productid']));
      },
      leading: new Icon(Icons.usb),
      title: new Text(device['manufacturer'] + " " + device['product']),
      subtitle: new Text(device['vendorid'] + " " + device['productid']),
    )).toList();
  }
}