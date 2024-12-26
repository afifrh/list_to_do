import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:todo/services/database.dart';
import 'package:todo/widgets/uihelper.dart';

class AddData extends StatefulWidget {
  const AddData({super.key, required this.userId});

  final String userId;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                label: const Text("Title"),
                hintText: "Write the title",
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                label: const Text("Description"),
                hintText: "Write the description",
              ),
              maxLines: 7,
            ),
          ),
          const SizedBox(height: 20),
          Uihelper.CustomButton(() async {
            String id = randomAlphaNumeric(10);
            String currentUserId = widget.userId;
            Map<String, dynamic> userInfo = {
              "desc": descController.text.toString(),
              "title": titleController.text.toString(),
              "Id": id,
              "currentUserId": currentUserId,
            };
            await DatabaseMethod().addUserDetails(userInfo, id).then((value) {
              Fluttertoast.showToast(
                msg: "Added successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }).catchError((error) {
              Fluttertoast.showToast(
                msg: "Error: ${error.toString()}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            });
          }, "Save"),
        ],
      ),
    );
  }
}
