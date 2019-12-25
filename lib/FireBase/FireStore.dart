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
    if(name.length > 20){
      onErr("Tên sản phẩm phải dưới 20 kí tự");
    }else{
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
    });
  }
  void checkStore({String userId}){
    _db.collection('Stores').document(userId).collection('currentBill').document().setData({});
    _db.collection('Stores').document(userId).collection('currentBill').getDocuments().then((snapshot){
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }
  void ChargeWithQrCode({String userId,String QrCode,Function(String,DocumentSnapshot) onSuccess,Function(String) onErr}){
    Firestore.instance.collection('Stores').document(userId).collection('currentBill').where("qrCode",isEqualTo: QrCode).getDocuments()
    .then((val){
      if(val.documents.length >= 1){

        val.documents.map((DocumentSnapshot document){
          int _quantity;
          _quantity = document['quantity']+1;

          Firestore.instance.collection('Stores').document(userId).collection('currentBill').document(document.documentID).updateData({ 'quantity': _quantity});

        }).toList();
      }else{
        _db.collection('Stores').document(userId).collection('product').where("qrCode",isEqualTo: QrCode).getDocuments()
            .then((QuerySnapshot docs){
          if(docs.documents.length != 0){
            print("co san pham");
            docs.documents.map((DocumentSnapshot document){
              var product = {
                'product':document.data,
                'quantity':1,
                'qrCode':QrCode
              };

              _db.collection('Stores').document(userId).collection('currentBill').document().setData(product);
              onSuccess("Thêm ${document['name']} vào đơn hàng thành công",document);
            }).toList();
          }else{
            onErr("Mặt hàng có mã vạch này hiện chưa có trong cửa hàng!");

          }
        });
      }
    });

    //

  }
  void ChangeQuantityProductBill({String userId,String docId,int quantityUpdate}){
    Firestore.instance.collection('Stores').document(userId).collection('currentBill').document(docId).updateData({ 'quantity': quantityUpdate });
  }
  void UpdateQuantityProductStore({String userId,String docId,int quantityUpdate}){
    Firestore.instance.collection('Stores').document(userId).collection('product').document(docId).updateData({ 'quantity': quantityUpdate });

  }
  void CancelBill({String userId,Function(String) onSuccess,Function(String) onErr}){
    _db.collection('Stores').document(userId).collection('currentBill').getDocuments().then((snapshot){
      if(snapshot.documents.length>0){
        for (DocumentSnapshot ds in snapshot.documents){
          ds.reference.delete();
        }
        onSuccess("Xóa hóa đơn thành công!");
      }else{
        onErr("Hóa đơn không có mặt hàng nào để xóa");
      }


    });
  }
  void ChangeBill({String userId,Function(String) onSuccess,Function(String) onErr,double total}){
    _db.collection('Stores').document(userId).collection('currentBill').getDocuments()
        .then((snapshot){
      var now = new DateTime.now();
      var product=[];

      if(snapshot.documents.length>0){
        print("so l sp hien tai ${snapshot.documents.length}");
        snapshot.documents.map((DocumentSnapshot document)  {
          checkProductInStore(userId: userId,qrCode: document['product']['qrCode'],name: document['product']['name']
              ,onErr: (txt){}
              ,onS: (data){
                int quatityUpdate = data['quantity'] - document['quantity'];
                UpdateQuantityProductStore(docId: data.documentID,userId: userId,quantityUpdate: quatityUpdate);

              }
          );

          product.add(document.data);
        }).toList();
        print(product);
        var bill = {
          'time':now,
          'bill':product,
          'total':total
        };

        _db.collection('Stores').document(userId).collection('BillsHistory').document().setData(bill);
        onSuccess("Tính tiền thành công!");




      }else{
        onErr("Chưa có sản phẩm nào để tính tiền");
      }
    });
  }
  void checkProductInStore({String qrCode,String userId,String name,Function(String) onErr(String),Function(DocumentSnapshot)onS}){
    _db.collection('Stores').document(userId).collection('product').where("qrCode",isEqualTo: qrCode).getDocuments()
        .then((QuerySnapshot docs){
      if(docs.documents.length != 0){
         docs.documents.map((DocumentSnapshot document){
          print(document.data);
          onS(document);
        }).toList();
      }else{
        _db.collection('Stores').document(userId).collection('product').where("name",isEqualTo: name).getDocuments()
            .then((QuerySnapshot docs)  {
          if(docs.documents.length != 0){
              docs.documents.map((DocumentSnapshot document){
                print(document.data);
                onS(document);
            }).toList();
          }else{
            onErr("Lỗi!");
          }
        });
      }
    });
  }

}