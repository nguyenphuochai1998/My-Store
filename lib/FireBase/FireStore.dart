import 'package:cloud_firestore/cloud_firestore.dart';
class FireStoreUser{
  Firestore _db = Firestore.instance;
  void addProduct({String userId,String name,String qrCode,int quantity,double price,Function(String) onSuccess,Function(String) onErr}){
    var product = {
      'name':name,
      'quantity':quantity,
      'price':price,
      'qrCode':qrCode
    };
    Firestore.instance.collection('Stores').document(userId).collection('product').where("name",isEqualTo: name).getDocuments()
    .then((QuerySnapshot docs){
      print("ten giong la : ${docs.documents.length}");
      if(docs.documents.length == 0){
        if(qrCode != ""){
          Firestore.instance.collection('Stores').document(userId).collection('product').where("qrCode",isEqualTo: qrCode).getDocuments()
              .then((QuerySnapshot docs)  {
            print(docs.documents.length);
            if(docs.documents.length == 0){
              // them mat hang len db
              _db.collection("Stores").document(userId).collection("product").document().setData(product).then((val){
                print("add product ok");
              }).catchError((err){
                print("co loi nang : ${err}");
              });
              onSuccess("Tạo mặt hàng trên hệ thống thành công");
            }else{
              onErr("Đã có mặt hàng trùng mã vạch với sản phẩm này trên hệ thống");
              print("da co tren db");

            }
          });
        }else{
          _db.collection("Stores").document(userId).collection("product").document().setData(product).then((val){
            print("add product ok");
          }).catchError((err){
            print("co loi nang : ${err}");
          });
          onSuccess("Tạo mặt hàng trên hệ thống thành công");
        }
      }else{
        print("da co tren db");
        onErr("Đã có mặt hàng trùng tên này trong cửa hàng của bạn");

      }
    });
  }
  void deleteProduct({String userId,String documentID,Function(String) onSuccess,Function(String) onErr}){
    _db.collection('Stores').document(userId).collection('product').document(documentID).delete()
        .then((val){
          // thanh cong
      onSuccess("Xóa mặt hàng thành công!");
    }).catchError((err){
      // k thanh cong
      onErr("Đã có lỗi khi xóa");
    });
  }
  void editProduct({String userId,String name,String qrCode,int quantity,double price,Function(String) onSuccess,Function(String) onErr,String documentID}){
    var product = {
      'name':name,
      'quantity':quantity,
      'price':price,
      'qrCode':qrCode
    };
    _db.collection('Stores').document(userId).collection('product').document(documentID).updateData(product)
    .then((val){
      onSuccess("sửa dữ liệu thành công!");
    }).catchError((err){
      onErr("lỗi ${err}");
    });
  }
}