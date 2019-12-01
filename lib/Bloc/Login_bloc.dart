import 'dart:async';
import 'package:flutter_app_my_store/Validators/Login_Register_Validato.dart';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';


class LoginBloc{
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;

  FireAuth _fireAuth = new FireAuth();
  bool isValOk(String user,String pass){
    if(!LoginRegisterValidato.isPhoneNumber(user)){
      if(!LoginRegisterValidato.isEmail(user)){
        _userController.sink.addError("Nhập Email!");
        return false;
      }
    }
    if(!LoginRegisterValidato.isPass(pass)){
      _passController.sink.addError("Mật Khẩu Phải Có 6 Kí Tự Hoặc Hơn!");
      return false;
    }
    _passController.add("ok");
    _userController.add("ok");
    return true;
  }
  void Login(String user,String pass,Function onSuccsess,Function(String) onErr){
    _fireAuth.Login(user, pass, onSuccsess, onErr);
  }


  void dispose(){
    _userController.close();
    _passController.close();
  }
}