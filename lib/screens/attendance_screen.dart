import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/drawer_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

import '../services/add_attendance.dart';

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
                  height: 275,
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
                          height: 250,
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
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
                                                  'Mark ${data.docs[index]['firstName']} ${data.docs[index]['middleInitial']}. ${data.docs[index]['lastName']} as present?',
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
                                                  addAttendance(
                                                      data.docs[index]
                                                          ['firstName'],
                                                      data.docs[index]
                                                          ['lastName'],
                                                      data.docs[index]
                                                          ['middleInitial'],
                                                      data.docs[index].id,
                                                      data.docs[index]['photo'],
                                                      data.docs[index]
                                                          ['isActive']);
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
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextRegular(
                                      text: data.docs[index]['id'],
                                      fontSize: 18,
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
                                  trailing: const SizedBox(
                                    width: 75,
                                    child: Row(
                                      children: [
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
                              itemCount: data.docs.length),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextBold(
                  text: 'Active Players',
                  fontSize: 18,
                  color: Colors.black,
                ),
                TextRegular(
                  text:
                      '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                  fontSize: 14,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 275,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Attendance')
                          .where('firstName',
                              isGreaterThanOrEqualTo:
                                  toBeginningOfSentenceCase(nameSearched))
                          .where('firstName',
                              isLessThan:
                                  '${toBeginningOfSentenceCase(nameSearched)}z')
                          .where('month', isEqualTo: DateTime.now().month)
                          .where('year', isEqualTo: DateTime.now().year)
                          .where('day', isEqualTo: DateTime.now().day)
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
                          height: 250,
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextRegular(
                                      text: data.docs[index]['userId'],
                                      fontSize: 18,
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
                                  trailing: const SizedBox(
                                    width: 75,
                                    child: Row(
                                      children: [
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
}
