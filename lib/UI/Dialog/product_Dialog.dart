import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
class ProductDialog{
  static void showProductDialog({BuildContext context,List list,Function onClickOkButton,Size size}){
    showDialog(context: context,builder:
    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.1,
        width: size.width - 30,
        height: size.height - 50,
        title: Text(
          "Danh sách mặt hàng",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.greenAccent),
          textScaleFactor: 1.2,

        ),
        descriptionPadding:
        EdgeInsets.only(left: 17.5, right: 17.5, bottom: 15.0),

        // Needed for the button design
        contentList: [
          Stack(
            children: <Widget>[
              Container(
                  width: size.width - 30,
                  height: size.height - 250,

                  child: new ListView.builder
                    (
                      itemCount: list.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return new Text(list[Index]["product"]["name"]);
                      }
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: size.height - 200),
                width: size.width - 30,
                height: 45.0,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClickOkButton();
                  },
                  child: Text("Okay",
                    textScaleFactor: 1.3,
                  ),),
              ),
            ],
          )
        ]).show(context)
    );
  }
}