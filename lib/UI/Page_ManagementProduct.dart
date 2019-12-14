import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_my_store/UI/Page_CreateProduct.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class Page_ManagementProduct extends StatefulWidget{

  const Page_ManagementProduct({Key key, this.user}) : super(key: key);
  final FirebaseUser user;



  @override
  _PageManagementProduct createState() => _PageManagementProduct();

}
class _PageManagementProduct extends State<Page_ManagementProduct>{
  FireStoreUser storeUser = new FireStoreUser();
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản Lý Hàng Hóa"),
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
                  onPressed: _onAddProductOnTap,
                  child: Text(
                    "Thêm Hàng Hóa",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.redAccent,

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:92),
              child: new StreamBuilder(
                stream: Firestore.instance.collection('Stores').document(widget.user.uid).collection('product').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting: return new Text('Loading...');
                    default:
                      return new ListView(
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                          return new Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.view_compact),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(document['name']),
                                subtitle: Text('Giá: ${document['price']} \nSố Lượng: ${document['quantity']}'),
                              ),
                            ),
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Archive',
                                color: Colors.green,
                                icon: Icons.archive,
                                onTap: (){},
                              ),

                            ],
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.redAccent,
                                icon: Icons.delete,
                                onTap: (){
                                  print("xóa ${document['name']}");
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      );
                  }
                },
              ),
            )
          ],
        )
      ),
    );
  }
  _onAddProductOnTap(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_CreateProduct(user: widget.user)));

  }
  _onLongPressTileEdit(){

  }

}