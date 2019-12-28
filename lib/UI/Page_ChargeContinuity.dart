import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_my_store/UI/Dialog/Error_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/loading_dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
import 'package:flutter_app_my_store/UI/PageEditProduct.dart';
import 'package:flutter_app_my_store/UI/Page_CreateProduct.dart';
import 'package:flutter_app_my_store/UI/Page_Home.dart';
import 'package:flutter_app_my_store/UI/Page_Print.dart';
import 'package:flutter_app_my_store/UI/Page_SearchProduct.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'Dialog/yesNo_Dialog.dart';

class Page_ChargeContinuity extends StatefulWidget{

  const Page_ChargeContinuity({Key key, this.user,this.isChargeDone}) : super(key: key);
  final FirebaseUser user;
  final bool isChargeDone;



  @override
  _PageChargeContinuity createState() => _PageChargeContinuity();

}
class _PageChargeContinuity extends State<Page_ChargeContinuity>{
  String _barCode;
  FireStoreUser storeUser = new FireStoreUser();
  static String _bCode;
  double _total;
  @override
  void initState() {
    if(widget.isChargeDone == true){
      Future.delayed(Duration.zero,() {
        YesNoDialog.showNotificationDialog(context: context
            ,msg: "tính tiền"
            ,onClickOkButton: (){
              LoadingDialog.showLoadingDialog(context,"Đang tính tiền..");
              storeUser.ChangeBill(
                  userId: widget.user.uid,
                  total:_total,
                  onSuccess: (txt){
                    LoadingDialog.hideLoadingDialog(context);

                    NotificationDialog.showNotificationDialog(
                        msg: txt,
                        context: context,
                        onClickOkButton: (){
                          // delete this bill
                          storeUser.CancelBill(
                              userId: widget.user.uid,
                              onErr: (txt){

                              },
                              onSuccess: (txt){
                                print(txt);
                              }
                          );

                        }
                    );


                  },
                  onErr: (txt){
                    LoadingDialog.hideLoadingDialog(context);

                    ErrorDialog.showErrorDialog(
                        context: context,
                        msg: txt
                    );
                  }

              );



            }
            ,onClickNoButton: (){}
        );
      });
    }




    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_SearchProduct(user: widget.user)));
            },

          )
        ],
        leading: new Container(
          child: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Home(user: widget.user)));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text("Tính tiền liên tục"),
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Container(

            child: Text("Quét Mã",textAlign: TextAlign.center,

              style: TextStyle(fontWeight: FontWeight.bold))
        ) ,
        onPressed: _Scan,
      ),
      body: Container(
          width: _size.width,
          height: _size.height,
          child: Stack(
            children: <Widget>[

              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("Hóa Đơn",textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.blue)),
              ),
              Container(
                margin: EdgeInsets.only(top:37),
                height: 20,
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Mặt Hàng:",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.blue),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                  trailing:Container(
                    alignment: Alignment.center,
                      width: _size.width/3,
                      height: _size.height/10,
                    child: Text("Số Lượng:",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.blue),
                    ),
                  ),
                )
              ),

              Container(
                height: (_size.height/2),
                margin: EdgeInsets.only(top:80),
                // list product
                child: new StreamBuilder(
                  stream: Firestore.instance.collection('Stores').document(widget.user.uid).collection('currentBill').snapshots(),
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
                                  title: Text("${document['product']['name']}"),
                                  subtitle: Text("Giá:${document['product']['price']}VNĐ\nThành Tiền: ${document['product']['price'] * document['quantity']}VNĐ"),
                                  trailing: _QuantityBox(size: _size,quantity: document['quantity'],
                                  onMinus: (){
                                    print("---");
                                    if(document['quantity']>=2){
                                      storeUser.ChangeQuantityProductBill(userId: widget.user.uid,
                                          docId: document.documentID,
                                          quantityUpdate: document['quantity'] -1
                                      );
                                    }

                                  },
                                    onPlus: (){
                                      storeUser.ChangeQuantityProductBill(userId: widget.user.uid,
                                          docId: document.documentID,
                                          quantityUpdate: document['quantity'] +1
                                      );
                                    }
                                  ),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Xóa Mặt Hàng',
                                  color: Colors.redAccent,
                                  icon: Icons.delete,
                                  onTap: (){
                                    YesNoDialog.showNotificationDialog(
                                        msg: "Bạn muốn xóa mặt hàng này ?",
                                        context: context,
                                        onClickOkButton: (){
                                          storeUser.deleteProductBill(
                                              userId: widget.user.uid,
                                              docID: document.documentID,
                                              onS: (val){
                                                NotificationDialog.showNotificationDialog(
                                                    context: context,
                                                    msg: val
                                                );
                                              }
                                          );
                                        }
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
              Container(
                width: _size.width,
                margin: EdgeInsets.only(top:80+(_size.height/2)+3),
                child: StreamBuilder(
                  stream: Firestore.instance.collection('Stores').document(widget.user.uid).collection('currentBill').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    double _sum = 0;
                    snapshot.data.documents.map((DocumentSnapshot document){
                      _sum = _sum + (document['product']['price'] * document['quantity']);
                    }).toList();
                      _total = _sum;


                    return _sum != null ? Text("Tổng Cộng: ${_sum}VNĐ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue,)):
                    Text("Tổng Cộng: 0 VNĐ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue,));
                  }
                )
              ),
              Container(
                  margin: EdgeInsets.only(top:80+(_size.height/2)+3+50),
                child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: _size.width/2 -35,
                          height: 50,
                          child: RaisedButton(
                            onPressed: (){
                              YesNoDialog.showNotificationDialog(
                                context: context,
                                msg: "Bạn có muốn In?",
                                onClickNoButton: (){
                                  YesNoDialog.showNotificationDialog(context: context
                                      ,msg: "tính tiền"
                                      ,onClickOkButton: (){
                                        LoadingDialog.showLoadingDialog(context,"Đang tính tiền..");
                                        storeUser.ChangeBill(
                                            userId: widget.user.uid,
                                            total:_total,
                                            onSuccess: (txt){
                                              LoadingDialog.hideLoadingDialog(context);

                                              NotificationDialog.showNotificationDialog(
                                                  msg: txt,
                                                  context: context,
                                                  onClickOkButton: (){
                                                    // delete this bill
                                                    storeUser.CancelBill(
                                                        userId: widget.user.uid,
                                                        onErr: (txt){

                                                        },
                                                        onSuccess: (txt){
                                                          print(txt);
                                                        }
                                                    );

                                                  }
                                              );
                                            },
                                            onErr: (txt){
                                              LoadingDialog.hideLoadingDialog(context);

                                              ErrorDialog.showErrorDialog(
                                                  context: context,
                                                  msg: txt
                                              );
                                            }
                                        );
                                      }
                                      ,onClickNoButton: (){}
                                  );
                                },
                                onClickOkButton: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Print(user: widget.user)));
                                }
                              );
                            },
                            child: Text(
                              "Tính tiền",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            color: Colors.green,

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                )),
                          ),
                        ),
                        Container(
                          width: _size.width/2 -35,
                          height: 50,
                          child: RaisedButton(
                            onPressed: (){
                              YesNoDialog.showNotificationDialog(context: context
                                  ,msg: "Bạn Muốn Hủy Hóa Đơn!"
                                  ,onClickOkButton: (){
                                    LoadingDialog.showLoadingDialog(context, "Đang xóa hóa đơn");
                                    storeUser.CancelBill(
                                      userId: widget.user.uid,
                                      onErr: (txt){
                                        LoadingDialog.hideLoadingDialog(context);
                                        ErrorDialog.showErrorDialog(context: context,msg: txt);
                                      },
                                      onSuccess: (txt){
                                        LoadingDialog.hideLoadingDialog(context);
                                        NotificationDialog.showNotificationDialog(
                                          context: context,
                                          msg: txt
                                        );
                                      }
                                    );
                                  }
                                  ,onClickNoButton: (){}
                                  ,colorMsg: Colors.redAccent
                              );
                            },
                            child: Text(
                              "Hủy hóa đơn",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            color: Colors.redAccent,

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                          ),
                        ),
                      ],
                    )
                ),
              )
            ],
          )
      ),
    );
  }
  Widget _QuantityBox({Size size,int quantity,Function onPlus,Function onMinus}){
    return Container(

      width: size.width/3,
      height: size.height/10,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed:onMinus,
            icon: Container(
                padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                width: 60, child: Image.asset("ic_minus.png")),
          ),
          Text(quantity.toString()),
          IconButton(
            onPressed: onPlus,
            icon: Container(
                padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                width: 60, child: Image.asset("ic_plus.png")),
          ),

        ],
      ),
    );
  }
  Future _Scan() async {
    _barCode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT);
    storeUser.ChargeWithQrCode(userId: widget.user.uid,QrCode: _barCode,onErr: (msg){},onSuccess: (msg,data){

    });
  }



}