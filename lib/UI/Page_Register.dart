import 'package:flutter/material.dart';
import 'package:flutter_app_my_store/Bloc/Register_bloc.dart';
import 'package:flutter_app_my_store/UI/Dialog/Msg_Dialog.dart';
import 'package:flutter_app_my_store/UI/Dialog/loading_dialog.dart';
import 'package:flutter_app_my_store/UI/Page_Login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterBloc bloc = new RegisterBloc();


  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passAController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();


  @override
  void dispose() {
    bloc.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 140,
              ),
              Container(
                width: 150,
                height: 150,
                child:Image.asset("ic_store.png"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                child: Text(
                  "Chào Mừng Bạn!",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              Text(
                "Hãy điền thông tin để đăng kí tài khoản",
                style: TextStyle(fontSize: 16, color: Color(0xff606470)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
                child: StreamBuilder(
                    stream:bloc.nameStream,

                    builder: (context, snapshot) => TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          errorText:
                          snapshot.hasError ? snapshot.error : null,
                          labelText: "Tên",
                          prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                              width: 50, child: Image.asset("ic_user.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                    )),
              ),
              StreamBuilder(
                  stream: bloc.userStream,


                  builder: (context, snapshot) => TextField(
                    controller: _userController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Email",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50, child: Image.asset("ic_user2.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: StreamBuilder(
                    stream: bloc.phoneAStream,

                    builder: (context, snapshot) => TextField(

                      controller: _phoneController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "SĐT",
                          errorText:
                          snapshot.hasError ? snapshot.error : null,
                          prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                              width: 50, child: Image.asset("ic_user2.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: StreamBuilder(
                    stream: bloc.passStream,

                    builder: (context, snapshot) => TextField(
                      obscureText: true,
                      controller: _passController,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Mật Khẩu",
                          errorText:
                          snapshot.hasError ? snapshot.error : null,
                          prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                              width: 50, child: Image.asset("ic_password.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                    )),
              ),
              StreamBuilder(
                  stream: bloc.passAStream,

                  builder: (context, snapshot) => TextField(
                    controller: _passAController,
                    obscureText: true,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        labelText: "Nhập Lại Mật Khẩu",
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50, child: Image.asset("ic_password.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: _onClickRegister,
                    child: Text(
                      "Đăng Kí",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    color: Color(0xFFA8DBA8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: RichText(
                  text: TextSpan(
                      text: "Đã Có Tài Khoản? ",
                      style: TextStyle(color: Color(0xff606470), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Bấm Để Đăng Nhập",
                            style: TextStyle(
                                color: Color(0xFFA8DBA8), fontSize: 16))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _onClickRegister(){
    if(bloc.isValOk(_nameController.text, _userController.text, _passController.text, _passAController.text,_phoneController.text)){
      LoadingDialog.showLoadingDialog(context, "Đang tiến hành đăng kí..."+"\n"+"Vui lòng đợi..."+"\n"+"Cảm ơn");
        bloc.Register(_nameController.text,_phoneController.text, _userController.text, _passController.text,
            (){
              LoadingDialog.hideLoadingDialog(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Page_Login()));

            },
            (msg){
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showMsgDialog(context, "Lỗi..!!!", msg.toString());
            });
    }
  }


}