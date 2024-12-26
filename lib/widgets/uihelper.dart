import 'package:flutter/material.dart';

class Uihelper {
  static CustomTextField(TextEditingController controller, String text, IconData iconData, bool toHide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            )
        ),
      ),
    );
  }

  static CustomButton(VoidCallback voidCallback, String text) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(onPressed: () {
        voidCallback();
      },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      )), child: Text(text, style: TextStyle(color: Colors.white, fontSize: 20),)),
    );
  }

  static CustomAlertBox(BuildContext context, String text) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),

        title: Text(text,style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("OK"))
        ],
      );
    });
  }
}
