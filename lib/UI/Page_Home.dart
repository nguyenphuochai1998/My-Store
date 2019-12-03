import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';

class Page_Home extends StatefulWidget{

  const Page_Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;



  @override
  _PageHomeState createState() => _PageHomeState();

}
class _PageHomeState extends State<Page_Home>{


  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
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
                        fontFamily: 'Poppins',
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
            )

          ],
        ),
      )

    );
  }

}