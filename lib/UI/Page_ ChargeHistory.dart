
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/product_Dialog.dart';
import 'package:flutter_app_my_store/UI/Page_Home.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Page_ChargeHistory extends StatefulWidget{

  const Page_ChargeHistory({Key key, this.user}) : super(key: key);
  final FirebaseUser user;



  @override
  _PageChargeHistory createState() => _PageChargeHistory();

}
class _PageChargeHistory extends State<Page_ChargeHistory>{

  @override
  void initState() {
    super.initState();
    if(pick == null){
      pick = DateTime.now();
    }

    print(pick);

  }
  static DateTime pick=DateTime.now();
  static List _listProduct;


  bool _isBottomshow = false;



  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    DateTime start = DateTime(pick.year, pick.month, pick.day, 0, 0);
    DateTime end = DateTime(pick.year, pick.month, pick.day, 23, 59, 59);
    var _countBill = 0;


    Size _size = MediaQuery.of(context).size;


    return MaterialApp(
      home: Scaffold(
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
          title: Text("Lịch sử bán hàng"),
        ),
        body: Container(
          width: _size.width,
          height: _size.height,
          child: Stack(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: ()  {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1998, 10, 1),
                          maxTime: DateTime(now.year, now.month,now.day), onChanged: (date) {
                          }, onConfirm: (date) {
                            setState(() {
                              pick = date;
                              start = DateTime(pick.year, pick.month, pick.day, 0, 0);
                              end = DateTime(pick.year, pick.month, pick.day, 23, 59, 59);
                            });
                            print(start);
                          }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    child: Text(
                      "Chọn ngày muốn xem",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Colors.redAccent,

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
              Container(
                height: 20,
                width: _size.width,
                margin: EdgeInsets.only(top:80),
                alignment: Alignment.center,
                child: Text("Danh sách hóa đơn ngày ${pick.day} tháng ${pick.month} năm ${pick.year}"),
              ),
              Container(
                height: (_size.height-100),
                margin: EdgeInsets.only(top:100),
                // list product
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('Stores').document(widget.user.uid).collection('BillsHistory').where('time', isGreaterThanOrEqualTo: start,isLessThanOrEqualTo: end).orderBy("time", descending: false).snapshots(),
                  builder: (BuildContext contextList, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState){
                      case ConnectionState.waiting: return new Text('Loading...');
                      default:
                        return new ListView(
                          children: snapshot.data.documents.map((DocumentSnapshot document) {
                            var _time = document['time'] as Timestamp;
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                color: Colors.white,
                                child: ListTile(
                                  onLongPress: (){
                                    print("chon");
                                    var _list = document['bill'] as List;
                                    ProductDialog.showProductDialog(
                                      context: context,
                                      size: _size,
                                      onClickOkButton: (){},
                                      list: _list
                                    );



                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(Icons.view_compact),
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Text("${_time.toDate().day}/${_time.toDate().month}/${_time.toDate().year} - ${_time.toDate().hour} giờ ${_time.toDate().minute} phút"),
                                  subtitle: Text("Tong cong:${document['total'] }VNĐ"),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Xóa Hóa Đơn',
                                  color: Colors.redAccent,
                                  icon: Icons.delete,
                                  onTap: (){

                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        );

                    }
                  },
                ),
              ),
            ],
          ),

        ),

      ),
    );
  }


}