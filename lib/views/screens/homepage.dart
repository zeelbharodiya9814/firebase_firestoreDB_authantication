import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/helper_class/firebase_auth_helper.dart';
import 'package:firebase_app/helper_class/firebase_firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home_page extends StatefulWidget {
  const Home_page({Key? key}) : super(key: key);

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  String? name;
  int? age;
  String? course;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController coursecontroller = TextEditingController();

  GlobalKey<FormState> imsertformKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User?;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.yellow[400],
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuthHelper.firebaseAuthHelper.logOut();
                Navigator.of(context).pushReplacementNamed('Login_page');
              },
              icon: Icon(Icons.power_settings_new))
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(20)),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: (user!.photoURL != null)
                        ? NetworkImage(user!.photoURL as String)
                        : (user!.isAnonymous)
                            ? NetworkImage(
                                "https://o.remove.bg/downloads/d961157e-0be1-4367-a2e7-feb979a9d1e7/images-removebg-preview.png")
                            : null,
                  ),
                )),
            Expanded(
                flex: 8,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: (user!.isAnonymous)
                            ? Container()
                            : (user!.displayName == null)
                                ? Container()
                                : Text(
                                    "  Username : ${user!.displayName}"), // Text("Phone : ${user!.phoneNumber}"),
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: (user!.isAnonymous)
                            ? Container()
                            : Text("  Email : ${user!.email}"),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("students").snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              return Center(
                child: Text("Error : ${snapShot.error}"),
              );
            } else if (snapShot.hasData) {
              QuerySnapshot<Map<String, dynamic>> data =
                  snapShot.data as QuerySnapshot<Map<String, dynamic>>;

              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return
                // MasonryGridView.builder(
                //   padding: EdgeInsets.all(10),
                //   crossAxisSpacing: 10,
                //   mainAxisSpacing: 10,
                //   physics: BouncingScrollPhysics(),
                //   itemCount: allDocs.length,
                //   gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //   ),
                //   itemBuilder: (context, i) {
                //     return Stack(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             // Navigator.pushNamed(context, 'SliderPage',
                //             //     arguments: allDocs[i]);
                //           },
                //           child: Column(
                //             children: [
                //               Stack(
                //                 alignment: Alignment.bottomCenter,
                //                 children: [
                //                   Card(
                //                     elevation : 5,
                //                     child: Container(
                //                       // height: 150,
                //                       width: double.infinity,
                //                       child: Padding(
                //                         padding: const EdgeInsets.only(top: 10.0,left: 10,right: 10,bottom: 50),
                //                         child: Column(
                //                           children: [
                //                             Row(
                //                               children: [
                //                                 Container(
                //                                   alignment: Alignment.center,
                //                                   height: 30,
                //                                   width: 30,
                //                                   child: Text("${i + 1}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                //                                   decoration: BoxDecoration(
                //                                     color: Colors.blue[100],
                //                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                             Text("${allDocs[i].data()['name']}"),
                //                             Text(
                //                                 "${allDocs[i].data()['course']}"),
                //                             Text("Age : ${allDocs[i].data()['age']}"),
                //                           ],
                //                         ),
                //                       ),
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(15),
                //                         color: Colors.white,
                //                       ),
                //                     ),
                //                   ),
                //                   Card(
                //                     elevation: 5,
                //                     child: Container(
                //                       alignment: Alignment.center,
                //                       height: 40,
                //                       width: double.infinity,
                //                       decoration: BoxDecoration(
                //                           borderRadius: BorderRadius.only(
                //                               bottomLeft: Radius.circular(15),
                //                               bottomRight: Radius.circular(15)),
                //                           color: Colors.grey[300]),
                //                       child: Row(
                //                         mainAxisSize: MainAxisSize.min,
                //                         children: [
                //                           IconButton(
                //                               onPressed: () {
                //                                 UpdateandValidate(
                //                                     allId: allDocs[i].id);
                //                                 namecontroller.text =
                //                                     allDocs[i].data()['name'];
                //                                 agecontroller.text = allDocs[i]
                //                                     .data()['age']
                //                                     .toString();
                //                                 coursecontroller.text =
                //                                     allDocs[i].data()['course'];
                //                               },
                //                               icon: Icon(
                //                                 Icons.edit,
                //                                 color: Colors.blue[900],
                //                               )),
                //                           IconButton(
                //                               onPressed: () async {
                //                                 await FirestoreDBHelper
                //                                     .firestoreDBHelper
                //                                     .delete(id: allDocs[i].id);
                //                               },
                //                               icon: Icon(
                //                                 Icons.delete,
                //                                 color: Colors.blue[900],
                //                               )),
                //                         ],
                //                       ),
                //                     ),
                //                   )
                //                 ],
                //               ),
                //               SizedBox(
                //                 height: 5,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     );
                //   });

                ListView.builder(
                itemCount: allDocs.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0,right: 8,left: 8),
                      child: Card(
                        elevation: 5,
                        color: Colors.grey[200],
                        child: ListTile(
                          isThreeLine: true,
                          leading: Text("${i + 1}"),
                          title: Text("${allDocs[i].data()['name']}"),
                          subtitle: Text("${allDocs[i].data()['course']}\n Age : ${allDocs[i].data()['age']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: () {

                               UpdateandValidate(allId: allDocs[i].id);
                               namecontroller.text = allDocs[i].data()['name'];
                               agecontroller.text = allDocs[i].data()['age'].toString();
                               coursecontroller.text = allDocs[i].data()['course'];


                              }, icon: Icon(Icons.edit,color: Colors.blue[900],)),
                              IconButton(onPressed: () async {
                                await FirestoreDBHelper.firestoreDBHelper.delete(id: allDocs[i].id);
                              }, icon: Icon(Icons.delete,color: Colors.blue[900],)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );

            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add"),
        icon: Icon(Icons.add),
        onPressed: () {
          InsertAndValidate();
        },
      ),
    );
  }

  InsertAndValidate() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (all) => AlertDialog(
        backgroundColor: Colors.white,
        content: Form(
          key: imsertformKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     CircleAvatar(
              //       radius: 40,
              //       backgroundImage: (image != null)
              //           ? MemoryImage(image as Uint8List)
              //           : null,
              //       backgroundColor: Colors.grey[300],
              //     ),
              //     IconButton(onPressed: () {
              //       setState(() async {
              //         final ImagePicker pick = ImagePicker();
              //
              //         XFile? xfile = await pick.pickImage(source: ImageSource.camera,imageQuality: 50);
              //         image = await xfile!.readAsBytes();
              //       });
              //     }, icon: Icon(Icons.add_a_photo_outlined)),
              //   ],
              // ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: namecontroller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter name...";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: agecontroller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter age...";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      age = int.parse(val!);
                    });
                    print(age);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.real_estate_agent_rounded,
                        color: Colors.black,
                      ),
                      hintText: "Age",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: coursecontroller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter course...";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      course = val;
                    });
                    print(course);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.subject,
                        color: Colors.black,
                      ),
                      hintText: "Course",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    namecontroller.clear();
                    agecontroller.clear();
                    coursecontroller.clear();

                    setState(() {
                      name = null;
                      age = null;
                      course = null;
                      // image = null;
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imsertformKey.currentState!.validate()) {
                    imsertformKey.currentState!.save();

                    Map<String, dynamic> data = {
                      'name': name,
                      'age': age,
                      'course': course,
                    };

                    await FirestoreDBHelper.firestoreDBHelper
                        .insert(data: data);
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Record inserted successfully..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    print("validate successfully...");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Record insertion failed"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }

                  namecontroller.clear();
                  agecontroller.clear();
                  coursecontroller.clear();

                  setState(() {
                    name = null;
                    age = null;
                    course = null;
                    // image = null;
                  });
                },
                child: Text("Insert"),
              ),
            ],
          )
        ],
      ),
    );
  }

  // UpdateAndValidate () {
  //
  //   namecontroller.text = alDocs[i]['name'];
  //   agecontroller.text = age.toString();
  //   coursecontroller.text = course;
  //
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (all) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       content: Form(
  //         key: updateformKey,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Stack(
  //             //   alignment: Alignment.center,
  //             //   children: [
  //             //     CircleAvatar(
  //             //       radius: 40,
  //             //       backgroundImage: (image != null)
  //             //           ? MemoryImage(image as Uint8List)
  //             //           : null,
  //             //       backgroundColor: Colors.grey[300],
  //             //     ),
  //             //     IconButton(onPressed: () {
  //             //       setState(() async {
  //             //         final ImagePicker pick = ImagePicker();
  //             //
  //             //         XFile? xfile = await pick.pickImage(source: ImageSource.camera,imageQuality: 50);
  //             //         image = await xfile!.readAsBytes();
  //             //       });
  //             //     }, icon: Icon(Icons.add_a_photo_outlined)),
  //             //   ],
  //             // ),
  //             SizedBox(height: 15,),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: namecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter name...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     name = val;
  //                   });
  //                 },
  //                 decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.person,
  //                       color: Colors.black,
  //                     ),
  //                     hintText: "Name",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: agecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter age...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     age = int.parse(val!);
  //                   });
  //                   print(age);
  //                 },
  //                 keyboardType: TextInputType.number,
  //                 decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.real_estate_agent_rounded,
  //                       color: Colors.black,
  //                     ),
  //                     hintText: "Age",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //             Card(
  //               elevation: 5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: TextFormField(
  //                 controller: coursecontroller,
  //                 textInputAction: TextInputAction.next,
  //                 validator: (val) {
  //                   if (val!.isEmpty) {
  //                     return "Enter course...";
  //                   }
  //                 },
  //                 onSaved: (val) {
  //                   setState(() {
  //                     course = val;
  //                   });
  //                   print(course);
  //                 },
  //                 decoration: InputDecoration(
  //                     prefixIcon: Icon(
  //                       Icons.subject,
  //                       color: Colors.black,
  //                     ),
  //                     hintText: "Course",
  //                     hintStyle: TextStyle(color: Colors.grey[400]),
  //                     filled: true,
  //                     fillColor: Colors.white,
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                       borderSide: BorderSide.none,
  //                     )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             OutlinedButton(
  //                 onPressed: () {
  //                   namecontroller.clear();
  //                   agecontroller.clear();
  //                   coursecontroller.clear();
  //
  //                   setState(() {
  //                     name = null;
  //                     age = null;
  //                     course = null;
  //                     // image = null;
  //                   });
  //
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text("Cancel")),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             ElevatedButton(onPressed: () async {
  //               if (updateformKey.currentState!.validate()) {
  //                 updateformKey.currentState!.save();
  //
  //                 Map<String, dynamic> data = {
  //                   'name' : name,
  //                   'age' : age,
  //                   'course' : course,
  //                 };
  //
  //                 await FirestoreDBHelper.firestoreDBHelper.insert(data: data );
  //                 Navigator.of(context).pop();
  //
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(
  //                         "Record updated successfully..."),
  //                     backgroundColor: Colors.green,
  //                     behavior: SnackBarBehavior.floating,
  //                   ),
  //                 );
  //                 print("validate successfully...");
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text("Record updation failed"),
  //                     backgroundColor: Colors.red,
  //                     behavior: SnackBarBehavior.floating,
  //                   ),
  //                 );
  //               }
  //
  //               namecontroller.clear();
  //               agecontroller.clear();
  //               coursecontroller.clear();
  //
  //               setState(() {
  //                 name = null;
  //                 age = null;
  //                 course = null;
  //                 // image = null;
  //               });
  //
  //             }, child: Text("Update"),),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  UpdateandValidate({required allId}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (all) => AlertDialog(
        backgroundColor: Colors.white,
        content: Form(
          key: updateformKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     CircleAvatar(
              //       radius: 40,
              //       backgroundImage: (image != null)
              //           ? MemoryImage(image as Uint8List)
              //           : null,
              //       backgroundColor: Colors.grey[300],
              //     ),
              //     IconButton(onPressed: () {
              //       setState(() async {
              //         final ImagePicker pick = ImagePicker();
              //
              //         XFile? xfile = await pick.pickImage(source: ImageSource.camera,imageQuality: 50);
              //         image = await xfile!.readAsBytes();
              //       });
              //     }, icon: Icon(Icons.add_a_photo_outlined)),
              //   ],
              // ),
              SizedBox(
                height: 15,
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: namecontroller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter name...";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: agecontroller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter age...";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      age = int.parse(val!);
                    });
                    print(age);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.real_estate_agent_rounded,
                        color: Colors.black,
                      ),
                      hintText: "Age",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: coursecontroller,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter course...";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      course = val;
                    });
                    print(course);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.subject,
                        color: Colors.black,
                      ),
                      hintText: "Course",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: () {
                    namecontroller.clear();
                    agecontroller.clear();
                    coursecontroller.clear();

                    setState(() {
                      name = null;
                      age = null;
                      course = null;
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (updateformKey.currentState!.validate()) {
                    updateformKey.currentState!.save();

                    await FirestoreDBHelper.firestoreDBHelper.update(
                        id: allId,
                        name: name!,
                        age: age!.toString(),
                        course: course!);
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Record updated successfully..."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    print("validate successfully...");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Record updation failed"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }

                  namecontroller.clear();
                  agecontroller.clear();
                  coursecontroller.clear();

                  setState(() {
                    name = null;
                    age = null;
                    course = null;
                    // image = null;
                  });
                },
                child: Text("Update"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
