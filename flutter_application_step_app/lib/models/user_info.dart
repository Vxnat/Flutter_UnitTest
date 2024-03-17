import 'package:flutter_application_unit_test/models/address_info.dart';

class UserInfo {
  String? name;
  String? gender;
  String? email;
  String? phoneNumber;
  DateTime? birthDate;
  AddressInfo? address;

  UserInfo({
    this.name,
    this.email,
    this.gender,
    this.phoneNumber,
    this.birthDate,
    this.address,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      name: map['name'] as String?,
      gender: map['gender'] as String?,
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      birthDate: map['birthDate'] != null
          ? DateTime.parse(map['birthDate'] as String)
          : null,
      address:
          map['address'] != null ? AddressInfo.fromMap(map['address']) : null,
    );
  }
}
