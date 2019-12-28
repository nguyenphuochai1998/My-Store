import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';
import 'package:flutter_app_my_store/UI/Dialog/Error_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/loading_dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/notification_Dialog.dart';
class ResetPassDialog{

  static void showResetPassDialog({BuildContext context,Function(String) onClickOkButton,Function onClickNoButton}){
    final TextEditingController _emailController = TextEditingController();
    showDialog(context: context,builder:
    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.1,
        width: 280,
        height: 280,
        title: Text(
          "Quên mật khẩu !",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),
          textScaleFactor: 1.2,

        ),
        // Needed for the button design
        contentList: [
          TextField(
            controller: _emailController,

            style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
            decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Container(
                    padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                    width: 50, child: Image.asset("ic_user.png")),
                border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(0xFFA8DBA8), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)))),
          ),

          Container(
            width: 244,
            height: 150,
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
                          onClickOkButton(_emailController.text);
                        },
                        child: Text(
                          "Lấy MK",
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