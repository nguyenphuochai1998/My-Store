import 'dart:async';
import 'package:flutter_app_my_store/Validators/Login_Register_Validato.dart';

class RegisterBloc{
  StreamController _nameController = new StreamController();
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _passAController = new StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get passAStream => _passAController.stream;

  bool isValOk(String name,String user,String pass,String passA){
    if(name.length == 0){
      _nameController.sink.addError("Bạn Cần Nhập Tên!");
      return false;
    }
    if(!LoginRegisterValidato.isPhoneNumber(user)){
      if(!LoginRegisterValidato.isEmail(user)){
        _userController.sink.addError("Nhập SĐT Hoặc Email!");
        return false;
      }
    }
    if(!LoginRegisterValidato.isPass(pass)){
      _passController.sink.addError("Mật Khẩu Phải Có 6 Kí Tự Hoặc Hơn!");
      return false;
    }else{
      if(!LoginRegisterValidato.isPassAOk(pass, passA)){
        _passAController.sink.addError("Phải Nhập Giống Mật Khẩu Ở Trên");
        return false;
      }
    }
    _passAController.add("ok");
    _passController.add("ok");
    _nameController.add("ok");
    _userController.add("ok");
    return true;

  }
  void dispose(){
    _passAController.close();
    _passController.close();
    _nameController.close();
    _userController.close();
  }
}