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
      print("k gowir leen dc");
    });
  }
  void OnErrRegister(String codeErr,Function(String) onRegisterErr){
    switch(codeErr){
      case "ERROR_EMAIL_ALREADY_IN_USE" :
        onRegisterErr("Đã có tài khoảng sử dụng email này!");
        break;
      case "ERROR_OPERATION_NOT_ALLOWED" :
        onRegisterErr("Ứng dụng không cho phép sử dụng tài khoảng nặt danh!");

    }


  }
}