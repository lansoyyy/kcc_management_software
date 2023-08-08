import 'dart:html';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kcc_management_software/services/add_member.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/drawer_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';
import 'package:kcc_management_software/widgets/textfield_widget.dart';
import 'package:kcc_management_software/widgets/toast_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  String nameSearched = '';
  final searchController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final birthdateController = TextEditingController();
  final statusController = TextEditingController();
  final addressController = TextEditingController();

  int dropValue = 0;

  bool filter = true;

  bool isUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerWidget(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 300,
                color: Colors.grey[200],
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100),
                      child: TextBold(
                        text: 'PLAYER LIST',
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                    Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () async {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Colors.grey,
                          size: 42,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 37.5,
                      width: 250,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              nameSearched = value;
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              label: TextRegular(
                                text: 'Search User',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              hintStyle: const TextStyle(
                                  fontFamily: 'QRegular', fontSize: 12),
                              suffixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                          controller: searchController,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    ButtonWidget(
                      height: 40,
                      radius: 10,
                      width: 125,
                      fontSize: 10,
                      color: Colors.grey[300],
                      label: 'ADD MEMBER',
                      onPressed: () {
                        firstnameController.clear();
                        middlenameController.clear();
                        lastnameController.clear();
                        birthdateController.clear();
                        statusController.clear();
                        addressController.clear();

                        addMemberDialog(false, {});
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ButtonWidget(
                      height: 40,
                      radius: 10,
                      width: 100,
                      fontSize: 10,
                      color: Colors.grey[300],
                      label: 'EXPORT',
                      onPressed: () {
                        exportCSV([
                          {'employee': 'Lance Olana'}
                        ]);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: SizedBox(
                          height: 40,
                          child: DropdownButton(
                            underline: const SizedBox(),
                            value: dropValue,
                            items: [
                              DropdownMenuItem(
                                onTap: () {
                                  setState(() {
                                    filter = true;
                                  });
                                },
                                value: 0,
                                child: TextRegular(
                                  text: 'Active Players',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              DropdownMenuItem(
                                onTap: () {
                                  setState(() {
                                    filter = false;
                                  });
                                },
                                value: 1,
                                child: TextRegular(
                                  text: 'Flagged Players',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                dropValue = int.parse(value.toString());
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    TextBold(
                      text:
                          '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 550,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Members')
                          .where('firstName',
                              isGreaterThanOrEqualTo:
                                  toBeginningOfSentenceCase(nameSearched))
                          .where('firstName',
                              isLessThan:
                                  '${toBeginningOfSentenceCase(nameSearched)}z')
                          .where('isActive', isEqualTo: filter)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        final data = snapshot.requireData;
                        return SizedBox(
                          height: 350,
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: IconButton(
                                    onPressed: () {
                                      addMemberDialog(true, data.docs[index]);
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: TextRegular(
                                      text:
                                          '${data.docs[index]['firstName']} ${data.docs[index]['middleInitial']}. ${data.docs[index]['lastName']}',
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: 75,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: TextBold(
                                                      text: data.docs[index]
                                                              ['isActive']
                                                          ? 'Flag user confirmation'
                                                          : 'Unflag user confirmation',
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                  content: TextRegular(
                                                      text: data.docs[index]
                                                              ['isActive']
                                                          ? 'Are you sure you want to flag ${data.docs[index]['firstName']} ${data.docs[index]['middleInitial']}. ${data.docs[index]['lastName']}?'
                                                          : 'Are you sure you want to unflag ${data.docs[index]['firstName']} ${data.docs[index]['middleInitial']}. ${data.docs[index]['lastName']}?',
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: TextRegular(
                                                            text: 'Close',
                                                            fontSize: 14,
                                                            color:
                                                                Colors.grey)),
                                                    TextButton(
                                                        onPressed: () async {
                                                          if (data.docs[index]
                                                              ['isActive']) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Members')
                                                                .doc(data
                                                                    .docs[index]
                                                                    .id)
                                                                .update({
                                                              'isActive': false
                                                            });
                                                          } else {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Members')
                                                                .doc(data
                                                                    .docs[index]
                                                                    .id)
                                                                .update({
                                                              'isActive': true
                                                            });
                                                          }

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: TextRegular(
                                                            text: 'Continue',
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black))
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.circle,
                                            color: data.docs[index]['isActive']
                                                ? Colors.white
                                                : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        // data.docs[index]['isActive']
                                        //     ? StreamBuilder<QuerySnapshot>(
                                        //         stream: FirebaseFirestore
                                        //             .instance
                                        //             .collection('Attendance')
                                        //             .where('userId',
                                        //                 isEqualTo:
                                        //                     data.docs[index].id)
                                        //             .where('month',
                                        //                 isEqualTo:
                                        //                     DateTime.now()
                                        //                         .month)
                                        //             .where('year',
                                        //                 isEqualTo:
                                        //                     DateTime.now().year)
                                        //             .where('day',
                                        //                 isEqualTo:
                                        //                     DateTime.now().day)
                                        //             .snapshots(),
                                        //         builder: (BuildContext context,
                                        //             AsyncSnapshot<QuerySnapshot>
                                        //                 snapshot) {
                                        //           if (snapshot.hasError) {
                                        //             print(snapshot.error);
                                        //             return const Center(
                                        //                 child: Text('Error'));
                                        //           }
                                        //           if (snapshot
                                        //                   .connectionState ==
                                        //               ConnectionState.waiting) {
                                        //             return const Padding(
                                        //               padding: EdgeInsets.only(
                                        //                   top: 50),
                                        //               child: Center(
                                        //                   child:
                                        //                       CircularProgressIndicator(
                                        //                 color: Colors.black,
                                        //               )),
                                        //             );
                                        //           }

                                        //           final data1 =
                                        //               snapshot.requireData;
                                        //           return data1.docs.isEmpty
                                        //               ? GestureDetector(
                                        //                   onTap: () {
                                        //                     showDialog(
                                        //                       context: context,
                                        //                       builder:
                                        //                           (context) {
                                        //                         return AlertDialog(
                                        //                           title: TextBold(
                                        //                               text:
                                        //                                   'Attendance',
                                        //                               fontSize:
                                        //                                   16,
                                        //                               color: Colors
                                        //                                   .black),
                                        //                           content: TextRegular(
                                        //                               text:
                                        //                                   'Mark ${data.docs[index]['firstName']} ${data.docs[index]['middleInitial']}. ${data.docs[index]['lastName']} as present?',
                                        //                               fontSize:
                                        //                                   14,
                                        //                               color: Colors
                                        //                                   .grey),
                                        //                           actions: [
                                        //                             TextButton(
                                        //                                 onPressed:
                                        //                                     () {
                                        //                                   Navigator.pop(
                                        //                                       context);
                                        //                                 },
                                        //                                 child: TextRegular(
                                        //                                     text:
                                        //                                         'Close',
                                        //                                     fontSize:
                                        //                                         14,
                                        //                                     color:
                                        //                                         Colors.grey)),
                                        //                             TextButton(
                                        //                                 onPressed:
                                        //                                     () {
                                        //                                   addAttendance(
                                        //                                       data.docs[index]['firstName'],
                                        //                                       data.docs[index]['lastName'],
                                        //                                       data.docs[index]['middleInitial'],
                                        //                                       data.docs[index].id,
                                        //                                       data.docs[index]['photo'],
                                        //                                       data.docs[index]['isActive']);
                                        //                                   Navigator.pop(
                                        //                                       context);
                                        //                                 },
                                        //                                 child: TextRegular(
                                        //                                     text:
                                        //                                         'Continue',
                                        //                                     fontSize:
                                        //                                         14,
                                        //                                     color:
                                        //                                         Colors.black))
                                        //                           ],
                                        //                         );
                                        //                       },
                                        //                     );
                                        //                   },
                                        //                   child: const Icon(
                                        //                     Icons
                                        //                         .check_box_outline_blank_outlined,
                                        //                     color: Colors.grey,
                                        //                   ),
                                        //                 )
                                        //               : const Icon(
                                        //                   Icons.check_box,
                                        //                   color: Colors.green,
                                        //                 );
                                        //         })
                                        //     : const SizedBox()
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: Colors.grey,
                                );
                              },
                              itemCount: data.docs.length),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  addMemberDialog(bool inEdit, data) {
    if (inEdit) {
      setState(() {
        firstnameController.text = data['firstName'];
        lastnameController.text = data['lastName'];
        middlenameController.text = data['middleInitial'];
        birthdateController.text = data['brithdate'];
        statusController.text = data['status'];
        addressController.text = data['address'];

        imgUrl = data['photo'];
      });
    }

    print(imgUrl);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              width: 430,
              height: 550,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            imgUrl != '' || inEdit
                                ? Container(
                                    height: 175,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            imgUrl,
                                          ),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                                : Container(
                                    height: 175,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            ButtonWidget(
                              height: 40,
                              radius: 10,
                              width: 125,
                              fontSize: 10,
                              color: Colors.grey[300],
                              label: 'UPLOAD',
                              onPressed: () {
                                InputElement input = FileUploadInputElement()
                                    as InputElement
                                  ..accept = 'image/*';
                                FirebaseStorage fs = FirebaseStorage.instance;
                                input.click();
                                input.onChange.listen((event) {
                                  final file = input.files!.first;
                                  final reader = FileReader();
                                  reader.readAsDataUrl(file);
                                  reader.onLoadEnd.listen((event) async {
                                    var snapshot = await fs
                                        .ref()
                                        .child('newfile')
                                        .putBlob(file);
                                    String downloadUrl =
                                        await snapshot.ref.getDownloadURL();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: TextRegular(
                                                text:
                                                    'Photo Uploaded Succesfully!',
                                                fontSize: 14,
                                                color: Colors.white)));

                                    setState(() {
                                      imgUrl = downloadUrl;

                                      isUploaded = true;
                                    });
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextBold(
                                      text: 'ID NUMBER',
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextRegular(
                                      text: inEdit ? data.id : '',
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: inEdit
                                          ? data['isActive']
                                              ? Colors.blue
                                              : Colors.red
                                          : Colors.white,
                                    ),
                                  ],
                                ),
                                TextRegular(
                                  text:
                                      'REGISTRATION DATE: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    TextFieldWidget(
                                        width: 150,
                                        height: 35,
                                        label: 'FIRST NAME',
                                        controller: firstnameController),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextFieldWidget(
                                        isPassword: false,
                                        padding: 2.5,
                                        width: 50,
                                        height: 35,
                                        label: 'MI',
                                        controller: middlenameController),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFieldWidget(
                                    width: 217,
                                    height: 35,
                                    label: 'LAST NAME',
                                    controller: lastnameController),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ButtonWidget(
                              height: 35,
                              radius: 0,
                              width: 217,
                              fontSize: 10,
                              color: Colors.red[300],
                              label: 'DELETE USER',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: TextBold(
                                          text: 'Delete Confirmation',
                                          fontSize: 16,
                                          color: Colors.black),
                                      content: TextRegular(
                                          text:
                                              'Are you sure you want to delete this user?',
                                          fontSize: 14,
                                          color: Colors.grey),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: TextRegular(
                                                text: 'Close',
                                                fontSize: 14,
                                                color: Colors.grey)),
                                        TextButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Members')
                                                  .doc(data.id)
                                                  .delete();

                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: TextRegular(
                                                text: 'Continue',
                                                fontSize: 14,
                                                color: Colors.black))
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFieldWidget(
                                width: 175,
                                height: 35,
                                label: 'BIRTHDATE',
                                controller: birthdateController),
                            const SizedBox(
                              width: 15,
                            ),
                            TextFieldWidget(
                                width: 175,
                                height: 35,
                                label: 'STATUS',
                                controller: statusController),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                            maxLine: 5,
                            width: 365,
                            height: 100,
                            label: 'ADDRESS',
                            controller: addressController),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonWidget(
                          fontColor: Colors.white,
                          height: 45,
                          radius: 0,
                          width: 275,
                          fontSize: 10,
                          color: Colors.blue,
                          label: inEdit ? 'EDIT' : 'ADD USER',
                          onPressed: () async {
                            int membersLength = 0;
                            if (_validateFields()) {
                              if (inEdit) {
                                await FirebaseFirestore.instance
                                    .collection('Members')
                                    .doc(data.id)
                                    .update({
                                  'firstName': firstnameController.text,
                                  'lastName': lastnameController.text,
                                  'middleInitial': middlenameController.text,
                                  'brithdate': birthdateController.text,
                                  'status': statusController.text,
                                  'address': addressController.text,
                                  'id': data.id,
                                  'photo': imgUrl,
                                });
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('Members')
                                    .get()
                                    .then((value) {
                                  setState(
                                    () {
                                      membersLength = value.docs.length;
                                    },
                                  );
                                });

                                addMember(
                                    firstnameController.text,
                                    lastnameController.text,
                                    middlenameController.text,
                                    birthdateController.text,
                                    statusController.text,
                                    addressController.text,
                                    membersLength.toString(),
                                    imgUrl);
                              }

                              firstnameController.clear();
                              lastnameController.clear();
                              middlenameController.clear();
                              birthdateController.clear();
                              statusController.clear();
                              addressController.clear();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  String imgUrl = '';

  _validateFields() {
    var errMsg = "";

    if (firstnameController.text == "") {
      errMsg = "First Name is required.";
    }
    if (lastnameController.text == "") {
      errMsg = "Last Name is required.";
    }

    if (middlenameController.text == "") {
      errMsg = "Middle Name is required.";
    }
    if (birthdateController.text == "") {
      errMsg = "Birth Date is required.";
    }
    if (statusController.text == "") {
      errMsg = "Status is required.";
    }
    if (addressController.text == "") {
      errMsg = "Address is required.";
    }

    if (imgUrl == '') {
      errMsg = "Member Photo is required.";
    }

    if (errMsg != "") {
      Navigator.pop(context);

      showToast(errMsg);

      return false;
    } else {
      return true;
    }
  }

  Future<void> exportCSV(List<Map<String, dynamic>> list) async {
    try {
      List<List<dynamic>> rows = [];
      rows.add(["Employee"]);

      for (var map in list) {
        rows.add([map["employee"]]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      // Use getTemporaryDirectory to get the temporary directory path
      var dir = await getDownloadsDirectory();
      String filePath = "${dir!.path}/list.csv";

      final file = await io.File(filePath)
          .create(); // Create the file if it doesn't exist

      // Write to the file using the csv data
      await file.writeAsString(csv);

      print("CSV File created at: $filePath");
    } catch (e) {
      print(e.toString());
    }
  }
}
