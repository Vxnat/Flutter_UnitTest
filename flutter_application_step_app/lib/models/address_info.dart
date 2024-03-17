import 'package:flutter_application_unit_test/models/district.dart';
import 'package:flutter_application_unit_test/models/province.dart';
import 'package:flutter_application_unit_test/models/ward.dart';

class AddressInfo {
  Province? province;
  District? district;
  Ward? ward;
  String? street;

  AddressInfo({
    this.province,
    this.district,
    this.ward,
    this.street,
  });

  factory AddressInfo.fromMap(Map<String, dynamic> map) {
    return AddressInfo(
      province:
          map['province'] != null ? Province.fromMap(map['province']) : null,
      district:
          map['district'] != null ? District.fromMap(map['district']) : null,
      ward: map['ward'] != null ? Ward.fromMap(map['ward']) : null,
      street: map['street'] as String?,
    );
  }
}
