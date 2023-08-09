import 'package:cloud_firestore/cloud_firestore.dart';

Future addMember(
    String firstName,
    String lastName,
    String middleInitial,
    String brithdate,
    String status,
    String address,
    String id,
    String photo,
    String incomeSource) async {
  final docUser = FirebaseFirestore.instance.collection('Members').doc(id);

  final json = {
    'firstName': firstName,
    'lastName': lastName,
    'middleInitial': middleInitial,
    'brithdate': brithdate,
    'status': status,
    'address': address,
    'id': docUser.id,
    'dateTime': DateTime.now(),
    'photo': photo,
    'isActive': true,
    'incomeSource': incomeSource
  };

  await docUser.set(json);
}
