import 'package:cloud_firestore/cloud_firestore.dart';

Future addMember(
    {required String firstName,
    required String lastName,
    required String middleInitial,
    required String brithdate,
    required String nationality,
    required String presentAddress,
    required String id,
    required String photo,
    required String fundsSource,
    required String idPhoto,
    required String permanentAddress,
    required String nature,
    required String number,
    required String contactNumber,
    required String benNames}) async {
  final docUser = FirebaseFirestore.instance.collection('Members').doc(id);

  final json = {
    'firstName': firstName,
    'lastName': lastName,
    'middleInitial': middleInitial,
    'brithdate': brithdate,
    'nationality': nationality,
    'address': presentAddress,
    'permanentAddress': permanentAddress,
    'id': docUser.id,
    'dateTime': DateTime.now(),
    'photo': photo,
    'isActive': true,
    'fundsSource': fundsSource,
    'idPhoto': idPhoto,
    'nature': nature,
    'number': number,
    'contactNumber': contactNumber,
    'benNames': benNames
  };

  await docUser.set(json);
}
