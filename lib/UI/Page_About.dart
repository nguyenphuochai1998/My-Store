
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_my_store/FireBase/FireStore.dart';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';
import 'package:flutter_app_my_store/UI/Dialog/ChangePass_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/Report_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/yesNo_Dialog.dart';
import 'package:flutter_app_my_store/UI/Page_Home.dart';
import 'package:flutter_app_my_store/UI/Page_Login.dart';

import 'Dialog/Error_Dialog.dart';
import 'Dialog/loading_dialog.dart';
import 'Dialog/notification_Dialog.dart';

class Page_About extends StatefulWidget{
  const Page_About({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _PageAbout createState() => _PageAbout();

}
class _PageAbout extends State<Page_About>{
  FireAuth _fireAuth = new FireAuth();
  FireStoreUser storeUser = new FireStoreUser();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.topLeft,
                height: 60,
                width: _size.width,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.green,),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Home(user: widget.user)));
                  },
                ),
              ),
              Container(
                width: 150,
                height: 150,
                child:Image.asset("ic_store.png"),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                width: _size.width,
                child: Text("My Store",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                  ),
                ),

              ),
              Container(
                alignment: Alignment.topCenter,
                width: _size.width,
                child: Text("Version 1.0.0,build#1.0.0",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),

              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topCenter,
                width: _size.width,
                child: Text("© HAI NGUYEN-PHUOC,12-2019",
                  style: TextStyle(
                  fontSize: 17,
                  color: Colors.black26,
                  fontWeight: FontWeight.w400,
                ),
                ),

              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topCenter,
                width: _size.width,
                child: Text("Cảm ơn mọi người đã sử dụng ứng dụng này ❤",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.green,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),

              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.redAccent,
                    width: 1
                  )
                ),
                child: ListTile(
                  leading: Icon(Icons.error,color:  Colors.redAccent,),
                  title: Text("Báo cáo sự cố!",
                  style: TextStyle(
                    color:  Colors.redAccent
                  ),
                  ),
                  onTap: (){
                    LoadingDialog.showLoadingDialog(context, "Đang gửi ...");
                    ReportDialog.showReportDialog(
                      txtField: "Mô tả lỗi",
                      onClickNoButton: (){
                        LoadingDialog.hideLoadingDialog(context);
                      },
                      maxLine: 4,
                      txtMsg: "Báo cáo lỗi!",
                      context: context,
                      onClickOkButton: (txt){
                        storeUser.Report(
                          onSuccess: (txt){
                            LoadingDialog.hideLoadingDialog(context);
                            NotificationDialog.showNotificationDialog(
                                context: context,
                                msg: txt
                            );
                          },
                          onErr: (txt){
                            LoadingDialog.hideLoadingDialog(context);
                            ErrorDialog.showErrorDialog(
                                msg: txt,
                                context: context
                            );
                          },
                          userId: widget.user.uid,
                          reportTxt: txt,
                          userName: widget.user.displayName
                          );
                      }
                        );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.amber,
                        width: 1
                    )
                ),
                child: ListTile(
                  leading: Icon(Icons.lock_outline,color:  Colors.amber,),
                  title: Text("Đổi mật khẩu!",
                    style: TextStyle(
                        color:  Colors.amber
                    ),
                  ),
                  onTap: (){
                    ChangePassDialog.showChangePassDialog(
                      context: context,
                      onClickOkButton: (pass,passA){
                        LoadingDialog.showLoadingDialog(context, "đang đổi mật khẩu!");
                        if(pass.compareTo(passA) == 0 && passA.length >=6){
                          widget.user.updatePassword(passA).then((val){
                            LoadingDialog.hideLoadingDialog(context);
                            NotificationDialog.showNotificationDialog(
                              context: context,
                              msg: "Đổi mk thành công",
                              onClickOkButton: (){
                                _fireAuth.auth.signOut().then((val){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Login()));
                                });
                              }
                            );

                          }).catchError((err){
                            if(err.code.toString().compareTo("ERROR_REQUIRES_RECENT_LOGIN") == 0){
                              LoadingDialog.hideLoadingDialog(context);
                              print("phai dang nhap lai");
                              YesNoDialog.showNotificationDialog(
                                context: context,
                                msg: "Phải đăng nhập lại mới có thể đổi mật khẩu,bạn có muốn đăng nhập lại k?",
                                onClickOkButton: (){
                                  _fireAuth.auth.signOut().then((val){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Login()));
                                  });


                                }
                              );
                            }else{
                              print(err);
                              LoadingDialog.hideLoadingDialog(context);
                              ErrorDialog.showErrorDialog(
                                context: context,
                                msg: "lỗi khi đổi mật khẩu"
                              );
                            }
                          });
                        }else{
                          LoadingDialog.hideLoadingDialog(context);
                          ErrorDialog.showErrorDialog(
                            context: context,
                            msg: "mật khẩu và mật khẩu nhập lại phải trùng nhau!\n"
                                "mật khẩu phải có hơn 6 kí tự"
                          );
                        }
                      },
                      onClickNoButton: (){
                        LoadingDialog.hideLoadingDialog(context);
                      }

                    );
                    },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.green,
                        width: 1
                    )
                ),
                child: ListTile(
                  leading: Icon(Icons.supervised_user_circle,color:  Colors.green,),
                  title: Text("Thay đổi tên người dùng!",
                    style: TextStyle(
                        color:  Colors.green
                    ),
                  ),
                  onTap: (){

                    ReportDialog.showReportDialog(
                      context:context,
                      maxLine: 1,
                      txtField: "Tên mới:",
                      txtMsg: "Đổi tên người dùng: ${widget.user.displayName}",
                      onClickOkButton: (txt){
                        LoadingDialog.showLoadingDialog(context, "Đang đổi tên ...");


                        _fireAuth.ChangeNameUser(
                          user: widget.user,
                            name: txt,
                          onS: (txt){NotificationDialog.showNotificationDialog(
                              msg: txt,
                              context: context,
                            onClickOkButton: () async {
                              LoadingDialog.hideLoadingDialog(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Page_Login()));

                            }
                          );
                          }
                        );



                      },
                      
                    );


                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue,
                        width: 1
                    )
                ),
                child: ListTile(
                  leading: Icon(Icons.email,color:  Colors.blue,),
                  title: Text("Đăng kí nhận thông tin ứng dụng miễn phí!",
                    style: TextStyle(
                        color:  Colors.blue
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        )
      ),
      ),
    );
  }
}