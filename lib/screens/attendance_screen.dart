import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/drawer_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io' as io;
import '../services/add_attendance.dart';
import 'package:pdf/pdf.dart';

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

  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  DateTimeRange dateRangeFilter =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerWidget(),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          width: 700,
          child: Stack(
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
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/Asset 8@4x.png')),
                          ),
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
                              const SizedBox(
                                height: 5,
                              ),
                              TextRegular(
                                text:
                                    '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                                fontSize: 14,
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
                          height: 40,
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
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search ID of User',
                                  hintStyle: TextStyle(
                                      fontFamily: 'QRegular', fontSize: 12),
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  )),
                              controller: searchController,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Attendance')
                                .where('dateTime',
                                    isGreaterThanOrEqualTo:
                                        dateRangeFilter.start)
                                .where('dateTime',
                                    isLessThanOrEqualTo: dateRangeFilter.end)
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
                              return Row(
                                children: [
                                  ButtonWidget(
                                    height: 40,
                                    radius: 10,
                                    width: 100,
                                    fontSize: 10,
                                    color: Colors.grey[300],
                                    label: 'EXPORT',
                                    onPressed: () {
                                      generatePdf(data.docs);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ButtonWidget(
                                    height: 40,
                                    radius: 10,
                                    width: 100,
                                    fontSize: 10,
                                    color: Colors.grey[300],
                                    label: 'Filter Export',
                                    onPressed: () async {
                                      DateTimeRange? result =
                                          await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2000, 1,
                                            1), // the earliest allowable
                                        lastDate: DateTime(2050, 12,
                                            31), // the latest allowable
                                        currentDate: DateTime.now(),
                                        saveText: 'Done',
                                      );

                                      print(result!.start);
                                      print(result.end);
                                      setState(() {
                                        dateRangeFilter = result;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
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
                              .where('id',
                                  isGreaterThanOrEqualTo:
                                      toBeginningOfSentenceCase(nameSearched))
                              .where('id',
                                  isLessThan:
                                      '${toBeginningOfSentenceCase(nameSearched)}z')
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
                                                          data.docs[index]
                                                              ['photo'],
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
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: TextRegular(
                                          text: data.docs[index]['id'],
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextBold(
                          text: 'Active Players',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        ButtonWidget(
                          height: 40,
                          radius: 10,
                          width: 100,
                          fontSize: 10,
                          color: Colors.grey[300],
                          label: '$month/$day/$year',
                          onPressed: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );

                            if (selectedDate != null) {
                              setState(() {
                                day = selectedDate.day;
                                month = selectedDate.month;
                                year = selectedDate.year;
                              });
                            }
                          },
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
                              .collection('Attendance')
                              .where('month', isEqualTo: month)
                              .where('year', isEqualTo: year)
                              .where('day', isEqualTo: day)
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
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: TextRegular(
                                          text: data.docs[index]['userId'],
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
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
        ),
      ),
    );
  }

  void generatePdf(List tableDataList) async {
    final pdf = pw.Document();
    final tableHeaders = [
      'Member ID',
      'Member Name',
      'Member Status',
    ];

    String cdate1 = DateFormat("MMMM, dd, yyyy").format(dateRangeFilter.start);
    String cdate2 = DateFormat("MMMM, dd, yyyy").format(dateRangeFilter.end);

    List<List<String>> tableData = [];
    for (var i = 0; i < tableDataList.length; i++) {
      tableData.add([
        tableDataList[i]['id'],
        '${tableDataList[i]['firstName']} ${tableDataList[i]['middleInitial']}. ${tableDataList[i]['lastName']}',
        tableDataList[i]['isActive'] ? 'Active' : 'Flagged',
      ]);
    }

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        pageFormat: PdfPageFormat.letter,
        orientation: pw.PageOrientation.portrait,
        build: (context) => [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('KCC Membership Software',
                    style: const pw.TextStyle(
                      fontSize: 18,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(
                  style: const pw.TextStyle(
                    fontSize: 15,
                  ),
                  'Attendance',
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  style: const pw.TextStyle(
                    fontSize: 10,
                  ),
                  cdate1 == cdate2 ? cdate1 : '$cdate1 - $cdate2',
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: tableData,
            headerDecoration: const pw.BoxDecoration(),
            rowDecoration: const pw.BoxDecoration(),
            headerHeight: 25,
            cellHeight: 45,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
            },
          ),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    final output = await getTemporaryDirectory();
    final file = io.File("${output.path}/payroll_report.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}
