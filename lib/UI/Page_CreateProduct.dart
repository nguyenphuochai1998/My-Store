import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:flutter_app_my_store/UI/Dialog/Error_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
import 'package:flutter_app_my_store/UI/Page_ManagementProduct.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:easy_dialog/easy_dialog.dart';


class Page_CreateProduct extends StatefulWidget{

  const Page_CreateProduct({Key key, this.user}) : super(key: key);
  final FirebaseUser user;



  @override
  _PageCreateProduct createState() => _PageCreateProduct();

}
class _PageCreateProduct extends State<Page_CreateProduct>{
  FireStoreUser storeUser = new FireStoreUser();
  String _counter;
  final TextEditingController _nameProductController = TextEditingController();
  final TextEditingController _qrCodeProductController = TextEditingController();
  final TextEditingController _quantityProductController = TextEditingController();
  final TextEditingController _priceProductController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(

          title: Text("Tạo Mặt Hàng Mới"),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _nameProductController,

                style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
                decoration: InputDecoration(
                    labelText: "Tên Mặt Hàng:",
                    errorText: _nameProductController.text.isEmpty ? "*Không được để trống !": null,
                    prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                        width: 50, child: Image.asset("ic_user.png")),
                    border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFFA8DBA8), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0, 20,0),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _priceProductController,

                style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
                decoration: InputDecoration(
                    labelText: "Giá:",
                    errorText: _priceProductController.text.isEmpty ? "*Không được để trống !": null,
                    prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                        width: 50, child: Image.asset("ic_user.png")),
                    border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFFA8DBA8), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _quantityProductController,

                style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
                decoration: InputDecoration(
                    labelText: "Số Lượng:",
                    errorText: _quantityProductController.text.isEmpty ? "*Không được để trống !": null,
                    prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                        width: 50, child: Image.asset("ic_user.png")),
                    border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFFA8DBA8), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
            ),
            new Container(
              width:_size.width,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,0, 20,0),
                      child: TextField(
                        controller: _qrCodeProductController,

                        style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
                        decoration: InputDecoration(
                            labelText: "QrCode:",
                            prefixIcon: Container(
                                padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                width: 50, child: Image.asset("ic_user.png")),
                            border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFA8DBA8), width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0, 20,0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: RaisedButton(
                          onPressed: ScanQr,
                          child: Text(
                            "Quét mã Qr",
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
              ),

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,20, 20,0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: RaisedButton(
                  onPressed:(){
                    _onCreateProduct(
                        onSuccess: (txt){
                          NotificationDialog.showNotificationDialog(context: context,
                          msg: txt,
                            onClickOkButton: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_ManagementProduct(user: widget.user)));
                            }
                          );
                        },
                      onErr: (txt){
                        ErrorDialog.showErrorDialog(msg: txt,context: context);

                      }
                    );
                  },
                  child: Text(
                    "Tạo Mặt hàng",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.blue,

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                ),
              ),
            ),
          ],
        )
    );


  }

  _onCreateProduct({Function(String) onSuccess,Function(String) onErr}){
    storeUser.addProduct(userId: widget.user.uid,
        name: _nameProductController.text,
        quantity: int.parse(_quantityProductController.text),
        price: double.parse(_priceProductController.text),
        qrCode: _qrCodeProductController.text,
        onErr: (txt){
          onErr(txt);

        },
        onSuccess: (txt){
          onSuccess(txt);

        }

    );
  }
  Future ScanQr() async {
    _counter = await FlutterBarcodeScanner.scanBarcode("#ff6666", "hủy", true,ScanMode.DEFAULT);
    setState(() {
      _qrCodeProductController.text = _counter;
    });
  }


}