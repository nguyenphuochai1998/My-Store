import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_my_store/UI/Page_Register.dart';
class Page_Login extends StatefulWidget{
  @override
  _PageLoginState createState() => _PageLoginState();

}
class _PageLoginState extends State<Page_Login>{
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     return Scaffold(
         body: Container(
           constraints: BoxConstraints.expand(),
           color: Colors.white,
           padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
           child: SingleChildScrollView(
             child: Column(
               children: <Widget>[
                 SizedBox(
                   height: 60,
                 ),
                 Container(
                   width: 150,
                   height: 150,
                   child:Image.asset("ic_store.png"),
                 ),
                 Padding(
                   padding: EdgeInsets.fromLTRB(0, 30, 0, 2),
                   child: Text(
                     "Chào Mừng Bạn!",
                     style: TextStyle(fontSize: 22, color: Color(0xff666666)),
                   ),

                 ),
                 Text(
                   "Đăng Nhập Để Vào Cửa Hàng Của Bạn",
                   style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                 ),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                   child: TextField(
                     controller: _userController,
                 
                     style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
                     decoration: InputDecoration(
                         labelText: "Email hoặc SĐT",
                         prefixIcon: Container(
                             padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                             width: 50, child: Image.asset("ic_user.png")),
                         border: OutlineInputBorder(
                             borderSide:
                             BorderSide(color: Color(0xFFA8DBA8), width: 1),
                             borderRadius: BorderRadius.all(Radius.circular(6)))),
                   ),
                 ),
                 TextField(
                   controller: _passController,
                   style: TextStyle(fontSize: 18, color: Color(0xFFA8DBA8)),
                   obscureText: true,
                   decoration: InputDecoration(
                       labelText: "Mật Khẩu",
                       prefixIcon: Container(
                           padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                           width: 50, child: Image.asset("ic_lock.png")),
                       border: OutlineInputBorder(
                           borderSide:
                           BorderSide(color: Color(0xFFA8DBA8), width: 1),
                           borderRadius: BorderRadius.all(Radius.circular(6)))),
                 ),
                 Container(

                   constraints: BoxConstraints.loose(Size(double.infinity, 50)),
                   alignment: AlignmentDirectional.centerEnd,
                   child: Padding(
                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                     child: Text(
                       "Quên Mật Khẩu?",
                       style: TextStyle(fontSize: 16, color: Color(0xff606470)),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                   child: SizedBox(
                     width: double.infinity,
                     height: 52,
                     child: RaisedButton(
                       onPressed: (){

                     },
                       child: Text(
                         "Đăng Nhập",
                         style: TextStyle(color: Colors.white, fontSize: 18),
                       ),
                       color: Color(0xFFA8DBA8),

                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.all(Radius.circular(6))),
                     ),
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                   child: RichText(
                     text: TextSpan(
                         text: "Đăng kí? ",
                         style: TextStyle(color: Color(0xFFA8DBA8), fontSize: 16),
                         children: <TextSpan>[
                           TextSpan(
                               recognizer: TapGestureRecognizer()
                                 ..onTap = () {
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) => RegisterPage()));
                                 },
                               text: "Bấm vào để đăng kí",
                               style: TextStyle(
                                   color: Color(0xff606470), fontSize: 16))
                         ]),
                   ),
                 )

               ],

             ),
           )

         ),
       );
  }

}