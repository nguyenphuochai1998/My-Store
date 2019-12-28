import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';
import 'package:flutter_app_my_store/UI/Dialog/Error_Dialog.dart';

import 'package:flutter_app_my_store/UI/Dialog/yesNo_Dialog.dart';
import 'package:flutter_app_my_store/UI/Page_%20ChargeHistory.dart';
import 'package:flutter_app_my_store/UI/Page_About.dart';
import 'package:flutter_app_my_store/UI/Page_Login.dart';
import 'package:flutter_app_my_store/UI/Page_ManagementProduct.dart';


import 'Page_ChargeContinuity.dart';


class Page_Home extends StatefulWidget{

  const Page_Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;




  @override
  _PageHomeState createState() => _PageHomeState();

}
class _PageHomeState extends State<Page_Home>{

  var _colors =[
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.redAccent



  ];
  var _nameTag =[
    "Tính Tiền",
    "Quản Lý Hàng Hóa",
    "Lịch Sử Bán Hàng",
    "Thông tin App"


  ];
  List<String> _icon =[
    "ic_payment.png",
    "ic_product.png",
    "ic_history.png",
    "ic_about.png"


  ];
  FireAuth fireA = new FireAuth();
  double _total;



  @override
  Widget build(BuildContext context) {


    Size _size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();

    DateTime start = DateTime(now.year, now.month, now.day, 0, 0);
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(


          body: Container(
            height: _size.height,
            width: _size.width,
            child: Stack(
              children: <Widget>[
                Container(
                    width: _size.width,
                    height: _size.height/2.7,


                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                        color: Color(0xFF33B958)
                    ),
                    child: new ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                      child: Image(
                        image: AssetImage("backgroud_home.jpg"),
                        fit: BoxFit.cover,
                      ),
                    )
                ),
                new Column(
                  children: <Widget>[
                    SizedBox(
                      height: _size.height/7,
                    ),
                    Text(
                      "Xin Chào ${widget.user.displayName}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.lightGreenAccent,

                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic

                      ),
                    ),

                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.fromLTRB(2, 10, 0, 10),
                            child: StreamBuilder(
                                stream:  Firestore.instance.collection('Stores').document(widget.user.uid).collection('BillsHistory').where('time', isGreaterThanOrEqualTo: start,isLessThanOrEqualTo: end).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  double _sum = 0;
                                  snapshot.data.documents.map((DocumentSnapshot document){
                                    _sum = _sum + document['total'];
                                  }).toList();
                                  _total = _sum;


                                  return _sum != null ? Text("Doanh thu hôm nay: ${_sum}VNĐ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,)):
                                  Text("Doanh thu hôm nay: 0 VNĐ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white,));
                                }
                            )
                        )
                      ],
                    )

                  ],
                ),



                Container(
                    margin: EdgeInsets.only(top:_size.height/2.7),

                    child: MenuHome()

                ),
                Container(
                  margin: EdgeInsets.only(top: _size.height/3,),
                  alignment: Alignment.topRight,

                  child: FlatButton(
                    child: Image.asset("ic_logout.png", height: 50, width: 50,),
                    onPressed: (){

                      YesNoDialog.showNotificationDialog(
                        context: context,
                        msg: "bạn nuốn thoát?",
                        onClickOkButton: (){
                          fireA.auth.signOut().then((val){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Login()));
                          }).catchError((err){
                            ErrorDialog.showErrorDialog(
                                context: context,
                                msg: err

                            );
                          });
                        },
                        onClickNoButton: (){

                        },

                      );
                    },
                  )
                ),



              ],
            ),
          )

      ),
    );


  }

  Widget _BuildTagName({int parentIndex}){

    return Card(
      color: _colors[parentIndex],
      child: Column(
        children: <Widget>[
          Text(_nameTag[parentIndex])
        ],
      ),
    );
  }
  Widget MenuHome() {
    return GridView.builder(

        itemCount: _nameTag.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                MenuHomeOnTap(index);
              },
              child: Card(
                color: _colors[index],
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Image.asset(_icon[index], height: 70.0, width: 70.0,),

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
  void MenuHomeOnTap(int index) {
    switch (index) {
      case 0 :
        {
            // tinh tien
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_ChargeContinuity(user: widget.user,isChargeDone: false,)));
        }
        break;
      case 1 :
        {
          //quan ly hang hoa

          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_ManagementProduct(user: widget.user)));



        }
        break;
      case 2 :
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_ChargeHistory(user: widget.user)));


        }
        break;
      case 3 :
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_About(user: widget.user)));


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