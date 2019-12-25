import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';
import 'package:flutter_app_my_store/UI/Dialog/Error_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/yesNo_Dialog.dart';
import 'package:flutter_app_my_store/UI/Page_%20ChargeHistory.dart';
import 'package:flutter_app_my_store/UI/Page_Charge.dart';
import 'package:flutter_app_my_store/UI/Page_Login.dart';
import 'package:flutter_app_my_store/UI/Page_ManagementProduct.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


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
    "Sổ Nợ"

  ];
  var _icon =[

  ];
  FireAuth fireA = new FireAuth();



  @override
  Widget build(BuildContext context) {


    Size _size = MediaQuery.of(context).size;

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
                    height: _size.height/3,


                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                        color: Color(0xFF33B958)
                    ),
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: _size.height/16,
                        ),
                        Text(
                          "Xin Chào ${widget.user.displayName}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFffffff),

                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic

                          ),
                        ),

                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(2, 10, 0, 10),
                              child: Text(
                                "Doanh Thu Hôm Nay: 0Đ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFffffff),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700

                                ),
                              ),
                            )
                          ],
                        )

                      ],
                    )

                ),
                Container(
                    margin: EdgeInsets.only(top:_size.height/3),

                    child: MenuHome()

                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.topRight,
                  child: IconButton(icon: Icon(Icons.lock_outline), onPressed: (){
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

                  }),
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
  void MenuHomeOnTap(int index) {
    switch (index) {
      case 0 :
        {
            // tinh tien
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Charge(user: widget.user)));
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


        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }

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



}