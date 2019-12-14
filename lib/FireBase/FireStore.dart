import 'package:cloud_firestore/cloud_firestore.dart';
class FireStoreUser{
  Firestore _db = Firestore.instance;
  void addProduct({String userId,String name,String qrCode,int quantity,double price,Function onSuccess,Function onErr}){
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
        Firestore.instance.collection('Stores').document(userId).collection('product').where("qrCode",isEqualTo: qrCode).getDocuments()
            .then((QuerySnapshot docs)  {
              print(docs.documents.length);
          if(docs.documents.length == 0){
            print("dang chay");
             _db.collection("Stores").document(userId).collection("product").document().setData(product).then((val){
              print("add product ok");
            }).catchError((err){
              print("co loi nang : ${err}");
            });
            onSuccess();
          }else{
            onErr();
            print("da co tren db");

          }
        });
      }else{
        print("da co tren db");
        onErr();

      }
    });





  }

}