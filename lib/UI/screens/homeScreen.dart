import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_3/Models/NoteModel.dart';
import 'package:todo_3/Providers/authServices.dart';
import 'package:todo_3/UI/screens/Utils.dart';
import 'package:todo_3/UI/screens/auth/loginPage.dart';
import 'package:todo_3/functions/FireBase/firebaseDB.dart';

import '../../functions/function.dart';
import '../../functions/sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  List<NoteModel> myItems = [];
  bool backUpInProcess = false;

  String? validateForm(String? val) {
    if (val!.isEmpty) return 'Field is Required';
    return null;
  }

  Future<void> addItem() async {
    await DatabaseHelper.createItem(_titleController.text, _desController.text);
    _refreshData();
  }

  Future<void> updateItem(NoteModel note) async {
    int res = await DatabaseHelper.updateItem(
      NoteModel(
        id: note.id,
        userId: note.userId,
        reference: notesReference.path,
        title: _titleController.text,
        description: _desController.text,
        uploaded: isOnline ? 1 : 0,
        createdAt: note.createdAt,
        updatedAt: DateTime.now().toString(),
      ),
    );
    if (res == 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('successfully updated!'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Operation failed'),
        backgroundColor: Colors.red,
      ));
    }
    _refreshData();
  }

  Future<void> deleteItem(NoteModel note) async {
    await DatabaseHelper.deleteItem(note);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('successfully deleted!'),
      backgroundColor: Colors.green,
    ));
    _refreshData();
  }

  _refreshData() async {
    var data = await DatabaseHelper.getItems();
    myItems.clear();
    for (var element in data) {
      myItems.add(NoteModel.fromJson(element));
    }
    setState(() {});
  }

  Future<void> backUpData() async {
    backUpInProcess = true;
    setState(() {});
    for (var element in myItems) {
      print(element.toJson());
      if (element.uploaded == 0) {
        var newItem = element;
        if (isOnline) {
          newItem.uploaded = 1;
          await DatabaseHelper.updateItem(newItem);
        }
        setState(() {});
      }
    }
    backUpInProcess = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Example'),
        actions: [
          IconButton(
              onPressed: isOnline
                  ? () async {
                      await backUpData();
                    }
                  : () => Utils.showNetWorkToast(),
              icon: Icon(
                backUpInProcess ? Icons.downloading : Icons.rotate_left_rounded,
                color: backUpInProcess ? Colors.green : null,
              )),
          IconButton(
              onPressed: isOnline
                  ? () async {
                      await Provider.of<AuthServices>(context, listen: false)
                          .signOut()
                          .then((value) => Get.offAll(LoginScreen()));
                    }
                  : () => Utils.showNetWorkToast(),
              icon: Icon(
                Icons.logout,
                color: backUpInProcess ? Colors.green : null,
              )),
        ],
      ),
      body: myItems.isEmpty
          ? const Center(
              child: Text('No Data Available!!!'),
            )
          : ListView.builder(
              itemCount: myItems.length,
              itemBuilder: (context, i) {
                return Stack(
                  children: [
                    Card(
                      color: i % 2 == 0 ? Colors.grey[300] : Colors.yellow[100],
                      margin: const EdgeInsets.all(15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              myItems[i].id.toString(),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  myItems[i].title ?? '',
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      myItems[i].description ?? '',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'User Id : ${myItems[i].userId}',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Ref : ${myItems[i].reference}',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Backup : ${myItems[i].uploaded == 0 ? 'false' : 'true'}',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Created At ${myItems[i].createdAt}',
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showMyForm(
                                        id: myItems[i].id, note: myItems[i]);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.warning,
                                            headerAnimationLoop: true,
                                            animType: AnimType.bottomSlide,
                                            title:
                                                'Are you sure to delete this item?',
                                            reverseBtnOrder: false,
                                            body:
                                                const AlsoDeleteFromCloudSwitch(),
                                            btnCancelOnPress: () {
                                              // Navigator.pop(context);
                                            },
                                            btnOkOnPress: () async {
                                              await deleteItem(myItems[i]);
                                            },
                                            desc:
                                                'Item will be deleted forever.')
                                        .show();
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (myItems[i].uploaded == 1)
                      const Positioned(
                        right: 20,
                        top: 20,
                        child: Icon(
                          Icons.cloud_done_rounded,
                          color: Colors.green,
                        ),
                      ),
                  ],
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showMyForm({int? id, NoteModel? note}) async {
    if (id != null) {
      final existingData = myItems.firstWhere((element) => element.id == id);
      // setState(() {
      _titleController.text = existingData.title!;
      _desController.text = existingData.description!;

      // });
    } else {
      _titleController.clear();
      _desController.clear();
    }
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isDismissible: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (context) {
          return BottomSheet(
            enableDrag: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(15),
                    ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: validateForm,
                                controller: _titleController,
                                decoration:
                                    const InputDecoration(hintText: 'Title'),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: validateForm,
                                controller: _desController,
                                decoration: const InputDecoration(
                                    hintText: 'Description'),
                                maxLines: 5,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        id != null
                                            ? await updateItem(note!)
                                            : await addItem();
                                        setState(() {
                                          _titleController.clear();
                                          _desController.clear();
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      id != null ? 'Update' : 'Add Item',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onClosing: () {},
          );
        });
  }
}

class AlsoDeleteFromCloudSwitch extends StatefulWidget {
  const AlsoDeleteFromCloudSwitch({Key? key}) : super(key: key);

  @override
  State<AlsoDeleteFromCloudSwitch> createState() =>
      _AlsoDeleteFromCloudSwitchState();
}

class _AlsoDeleteFromCloudSwitchState extends State<AlsoDeleteFromCloudSwitch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
        title: const Text('Also Delete from cloud?'),
        value: noteDeleteFromFbAlso,
        onChanged: (val) {
          setState(() {
            noteDeleteFromFbAlso = val;
          });

        });
  }
}
