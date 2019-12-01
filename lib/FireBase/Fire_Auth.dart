import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class FireAuth{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void Register(String name,String phone,String email,String pass
      ,Function onSuccess,Function(String) onRegisterErr){
    _auth.createUserWithEmailAndPassword(email: email, password: pass)
        .then((user){
          _creadUserOnFirestore(user.user.uid, name, phone, onSuccess, onRegisterErr);
          print(user);
          print("dk ok");
        })
        .catchError((Err){
          OnErrRegister(Err.code, onRegisterErr);
          print(Err);

    });

  }
  _creadUserOnFirestore(String id,String name,String phone,Function onSuccess,Function(String) onRegisterErr){
    Firestore.instance.collection('User').document(id)
        .setData({ 'name': name, 'phone': phone }).then((user){
        onSuccess();

    }).catchError((err){
      onRegisterErr("vui lòng thử đăng kí lại! cảm ơn");

    });
  }
  void OnErrRegister(String codeErr,Function(String) onRegisterErr){
    switch(codeErr){
      case "ERROR_EMAIL_ALREADY_IN_USE" :
        onRegisterErr("Đã có tài khoản sử dụng email này!");
        break;
      case "ERROR_OPERATION_NOT_ALLOWED" :
        onRegisterErr("Ứng dụng không cho phép sử dụng tài khoản nặt danh!");

    }


  }
  void Login(String user,String pass,Function onSuccsess,Function(String) onErr){
    _auth.signInWithEmailAndPassword(email: user, password: pass)
        .then((user){
          onSuccsess();
    })
        .catchError((err){
          print(err.code);
          OnErrLogin(err.code, onErr);

    });
  }
  void OnErrLogin(String codeErr,Function(String) onLoginErr){
    switch(codeErr){
      case "ERROR_USER_DISABLED" :
        onLoginErr("Tài khoản này đã bị khóa!");
        break;
      case "ERROR_OPERATION_NOT_ALLOWED" :
        onLoginErr("Tài khoản này chưa được kích hoạt bởi Google!");
        break;
      case "ERROR_WRONG_PASSWORD" :
        onLoginErr("Có lẽ mật khẩu không đúng vui lòng kiểm tra lại!");
        break;

    }
  }
}