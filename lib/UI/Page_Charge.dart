import 'package:bot_toast/bot_toast.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
import 'package:flutter_app_my_store/UI/Page_ChargeContinuity.dart';
import 'package:flutter_app_my_store/UI/Page_ManagementProduct.dart';
import 'package:flutter_app_my_store/UI/Page_Print.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



import 'Page_Home.dart';


class Page_Charge extends StatefulWidget{

  const Page_Charge({Key key, this.user}) : super(key: key);
  final FirebaseUser user;



  @override
  _PageChanrge createState() => _PageChanrge();

}
class _PageChanrge extends State<Page_Charge> {
  String _ip;


  @override
  void initState() {

    super.initState();
  }

  var _colors = [
    Colors.blue,
    Colors.green,

  ];
  var _nameTag = [
    "Tính tiền liên tục",
    "Tính tiền số lượng ",

  ];
  var _icon = [
  ];

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: new Container(
            child: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Home(user: widget.user)));
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text("Tính Tiền"),
        ),
        body: Container(
          height: _size.height,
          width: _size.width,
          child: Stack(
                children: <Widget>[
                  Container(

                      child: MenuCharge()

                  ),


                ],
              ),
            )

      );
  }
  Widget MenuCharge() {
    return GridView.builder(

        itemCount: _nameTag.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                MenuChargeOnTap(index);
              },
              child: Card(
                color: _colors[index],
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Image.asset("ic_store.png", height: 70.0, width: 70.0,),

                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(_nameTag[index], style: new TextStyle(
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), textAlign: TextAlign.center,),
                    )
                  ],
                ),
              )
          );
        }
    );
  }
  void MenuChargeOnTap(int index) {
    switch (index) {
      case 0 :
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_ChargeContinuity(user: widget.user,isChargeDone: false,)));

        }
        break;
      case 1 :
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Charge(user: widget.user)));

        }
        break;
      case 2 :
        {


        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }
}