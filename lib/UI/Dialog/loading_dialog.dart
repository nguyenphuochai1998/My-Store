
import 'package:flutter/material.dart';
class LoadingDialog{
static void showLoadingDialog(BuildContext context,String msg){
showDialog(context: context,barrierDismissible: false,
builder:(context) => new Dialog(
child: new Container(
height: 200,
width: 200,
color: Color(0xFFA8DBA8),
child: new Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
new CircularProgressIndicator(),
Padding(
padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
child: Text(
msg,
style: TextStyle(fontSize: 18,color: Colors.white),

),
)
],
),
),
) );

}
static void hideLoadingDialog(BuildContext context){
Navigator.of(context).pop(LoadingDialog);
}
}