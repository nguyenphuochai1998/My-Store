import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
class YesNoDialog{
  static void showNotificationDialog({BuildContext context,String msg,Function onClickOkButton,Function onClickNoButton,Color colorMsg}){
    showDialog(context: context,builder:
    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.1,
        width: 280,
        height: 150,
        title: Text(
          "Thông Báo!",
          style: TextStyle(fontWeight: FontWeight.bold,color: colorMsg),
          textScaleFactor: 1.2,

        ),
        descriptionPadding:
        EdgeInsets.only(left: 17.5, right: 17.5, bottom: 15.0),
        description: Text(
            msg
            ,
          style: TextStyle(color: colorMsg),
        ),
        // Needed for the button design
        contentList: [
          Container(
            width: 244,
            height: 45.0,
            child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 122,
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          onClickOkButton();
                        },
                        child: Text(
                          "Đồng ý",
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
                      width: 122,
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          onClickNoButton();
                        },
                        child: Text(
                          "Hủy",
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
          ),
        ]).show(context)
    );
  }
}