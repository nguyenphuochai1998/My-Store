import 'dart:async';
import 'package:flutter_app_my_store/FireBase/Fire_Auth.dart';
import 'package:flutter_app_my_store/Validators/Login_Register_Validato.dart';

class RegisterBloc{
  StreamController _nameController = new StreamController();
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _passAController = new StreamController();
  StreamController _phoneController = new StreamController();

  Stream get nameStream => _nameController.stream;
  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get passAStream => _passAController.stream;
  Stream get phoneAStream => _phoneController.stream;

  FireAuth _fireAuth = new FireAuth();

  bool isValOk(String name,String user,String pass,String passA,String phone){
    if(name.length == 0){
      _nameController.sink.addError("Bạn Cần Nhập Tên!");
      return false;
    }
    _nameController.add("ok");
    if(!LoginRegisterValidato.isPhoneNumber(phone)){
      _phoneController.sink.addError("Nhập SĐT Và Kiểm Tra Lại!");
      return false;
    }
    _phoneController.add("ok");
    if(!LoginRegisterValidato.isEmail(user)){
      _userController.sink.addError("Nhập Email Và Kiểm Tra Lại!");
      return false;
    }
    _userController.add("ok");

    if(!LoginRegisterValidato.isPass(pass)){
      _passController.sink.addError("Mật Khẩu Phải Có 6 Kí Tự Hoặc Hơn!");
      return false;
    }
    _passController.add("ok");
    print(passA.compareTo(pass));
    if(pass.compareTo(passA)!=0){
      _passAController.sink.addError("Mật Khẩu Nhập Lại Phải Giống Mật Khẩu Trên!");
      return false;
    }
    _passAController.add("ok");



    return true;

  }
  void Register(String name,String phone,String email,String pass
      ,Function onSuccess,Function(String) onRegisterErr){
    _fireAuth.Register(name, phone, email, pass, onSuccess, onRegisterErr);
  }
  void dispose(){
    _passAController.close();
    _passController.close();
    _nameController.close();
    _userController.close();
  }
}