import 'dart:html';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kcc_management_software/services/add_member.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/drawer_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';
import 'package:kcc_management_software/widgets/textfield_widget.dart';
import 'package:kcc_management_software/widgets/toast_widget.dart';

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
  String filter = 'Active';

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
                        addMemberDialog();
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ButtonWidget(
                      height: 40,
                      radius: 10,
                      width: 125,
                      fontSize: 10,
                      color: Colors.grey[300],
                      label: 'EXPORT CSV',
                      onPressed: () {},
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
                                    filter = 'Active';
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
                                    filter = 'Flagged';
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
                  child: Expanded(
                    child: SizedBox(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: IconButton(
                                onPressed: () {
                                  addMemberDialog();
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: TextRegular(
                                  text: 'John C. Doe',
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 75,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: TextBold(
                                                  text: 'Attendance',
                                                  fontSize: 16,
                                                  color: Colors.black),
                                              content: TextRegular(
                                                  text:
                                                      'Mark John Doe as present?',
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
                                                    onPressed: () {
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
                                      child: const Icon(
                                        Icons.check_box_outline_blank_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
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
                          itemCount: 100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  addMemberDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
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
                          Container(
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
                              uploadPicture();
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
                                    text: '124567',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Icon(
                                    Icons.circle,
                                    color: Colors.red,
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
                                          onPressed: () {
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
                        label: 'ADD USER',
                        onPressed: () {
                          if (_validateFields()) {
                            Random random = Random();
                            int idNumber = random.nextInt(1000000);

                            addMember(
                                firstnameController.text,
                                lastnameController.text,
                                middlenameController.text,
                                birthdateController.text,
                                statusController.text,
                                addressController.text,
                                idNumber.toString(),
                                imgUrl);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String imgUrl = '';

  uploadPicture() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child('newfile').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: TextRegular(
                text: 'Photo Uploaded Succesfully!',
                fontSize: 14,
                color: Colors.white)));

        setState(() {
          imgUrl = downloadUrl;
        });
      });
    });
  }

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
}
