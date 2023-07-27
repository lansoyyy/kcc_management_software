import 'package:flutter/material.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/drawer_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';
import 'package:kcc_management_software/widgets/textfield_widget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String nameSearched = '';
  final searchController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final middlenameController = TextEditingController();
  final birthdateController = TextEditingController();
  final statusController = TextEditingController();
  final addressController = TextEditingController();

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextBold(
                            text: 'ATTENDANCE',
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                          TextRegular(
                            text:
                                '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ],
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
                      label: 'EXPORT CSV',
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 600,
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
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextRegular(
                                  text: '2020300',
                                  fontSize: 18,
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
                                  children: const [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
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
                            onPressed: () {},
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
                                text: 'REGISTRATION DATE: 08/30/2023',
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
                            onPressed: () {},
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
                        onPressed: () {},
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
}
