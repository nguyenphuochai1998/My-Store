
import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';

class ChangePassDialog{

  static void showChangePassDialog({BuildContext context,Function(String,String) onClickOkButton,Function onClickNoButton}){
    final TextEditingController _passController = TextEditingController();
    final TextEditingController _passAgainController = TextEditingController();
    showDialog(context: context,builder:
    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.1,
        width: 280,
        height: 350,
        title: Text(
          "Thay đổi mật khẩu !",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),
          textScaleFactor: 1.2,

        ),
        // Needed for the button design
        contentList: [
          TextField(
            controller: _passController,
            style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Mật Khẩu",
                errorText: _passController.text.length <0 ? "Phải nhập mật khẩu":null,
                prefixIcon: Container(
                    padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                    width: 50, child: Image.asset("ic_lock.png")),
                border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(0xFFA8DBA8), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)))),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passAgainController,
            style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Nhập Lại Mật Khẩu",
                errorText: _passController.text.length <0 ? "Phải nhập lại mật khẩu":null,
                prefixIcon: Container(
                    padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                    width: 50, child: Image.asset("ic_lock.png")),
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
                          onClickOkButton(_passController.text,_passAgainController.text);
                        },
                        child: Text(
                          "Đổi MK",
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