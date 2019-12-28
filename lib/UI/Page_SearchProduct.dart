import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:flutter_app_my_store/UI/Dialog/Error_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Page_SearchProduct extends StatefulWidget{

  const Page_SearchProduct({Key key, this.user}) : super(key: key);
  final FirebaseUser user;




  @override
  _PageSearchProduct createState() => _PageSearchProduct();

}
class _PageSearchProduct extends State<Page_SearchProduct>{
  FireStoreUser storeUser = new FireStoreUser();
  final TextEditingController _searchController = TextEditingController();
  String _search ;
  @override
  void initState() {
    if(_searchController.text == ""){
      _search = "";
    }else{
      _search = _searchController.text;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tìm kiếm.."),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: _size.width ,

            child: TextField(
              controller: _searchController,
              onChanged: (txt){
                setState(() {
                  _search = txt;
                  print(_search);
                });

              },

              style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
              decoration: InputDecoration(
                  labelText: "Tên mặt hàng",
                  prefixIcon: Container(
                      padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                      width: 50, child: Icon(Icons.search)),
                  border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFFA8DBA8), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 65),
            width: _size.width ,
            height: _size.height ,

            child: new StreamBuilder(
              stream: Firestore.instance.collection('Stores').document(widget.user.uid).collection('product').orderBy("name", descending: false).startAt([_search]).endAt([_search+'\uf8ff']).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState){
                  case ConnectionState.waiting: return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return Slidable(
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
                              title: Text("${document['name']}"),

                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Chọn',
                              color: Colors.blue,
                              icon: Icons.check_circle_outline,
                              onTap: (){
                                storeUser.ChargeWithName(
                                  userId: widget.user.uid,
                                  onErr: (txt){
                                    ErrorDialog.showErrorDialog(
                                      context: context,
                                      msg: txt
                                    );
                                  },
                                  onSuccess: (txt){
                                    NotificationDialog.showNotificationDialog(
                                      context: context,
                                      msg: txt
                                    );
                                  },
                                  nameProduct: document['name']
                                );

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
    );
  }

}