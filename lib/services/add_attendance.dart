import 'package:cloud_firestore/cloud_firestore.dart';

Future addAttendance(String firstName, String lastName, String middleInitial,
    String userId, String photo, bool isActive) async {
  final docUser =
      FirebaseFirestore.instance.collection('Attendance').doc(userId);

  final json = {
    'firstName': firstName,
    'lastName': lastName,
    'middleInitial': middleInitial,
    'id': docUser.id,
    'dateTime': DateTime.now(),
    'userId': userId,
    'photo': photo,
    'isActive': isActive,
    'day': DateTime.now().day,
    'month': DateTime.now().month,
    'year': DateTime.now().year,
  };

  await docUser.set(json);
}
