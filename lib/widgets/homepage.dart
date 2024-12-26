import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/database.dart';
import 'package:todo/services/auth.dart';
import 'package:todo/widgets/add_data.dart';
import 'package:todo/widgets/viewdetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.auth,
    required this.onSignedOut,
    required this.userId,
  });

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Stream<QuerySnapshot>? _userStream;
  String _email = "Loading...";
  String _name = "User";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserStream();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await widget.auth.currentUser();
    if (!mounted) return;

    setState(() {
      _email = user?.email ?? "No email";
      // You might want to fetch user's name from Firestore here
    });
  }

  Future<void> _loadUserStream() async {
    _userStream = await DatabaseMethod().getUserInfo(widget.userId);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _userStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final ds = snapshot.data!.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Title: ${ds["title"]}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye,
                                color: Colors.blue),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewDetails(
                                  title: ds["title"],
                                  desc: ds["desc"],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(
                                ds["Id"], ds["title"], ds["desc"]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.blue),
                            onPressed: () =>
                                DatabaseMethod().deleteUserDetails(ds["Id"]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Description: ${ds["desc"]}",
                        style: const TextStyle(fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(String id, String title, String desc) async {
    //_titleController.text = title;
    //_descController.text = desc;
    debugPrint("id: $id");
    final TextEditingController newtitleController = TextEditingController();
    final TextEditingController newdescController = TextEditingController();
    newtitleController.text = title;
    newdescController.text = desc;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Edit Details"),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newtitleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: "Title",
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newdescController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: "Description",
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updateInfo = {
                  "title": newtitleController.text,
                  "desc": newdescController.text,
                  "currentUserId": widget.userId,
                };
                await DatabaseMethod()
                    .updateUserDetails(id, updateInfo)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_name),
              accountEmail: Text(_email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  _name[0],
                  style: const TextStyle(color: Colors.yellowAccent),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddData(userId: widget.userId),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _buildUserList(),
      ),
    );
  }
}
