import 'package:flutter_application_unit_test/models/ward.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ward:', () {
    test('constructor', () {
      var ward = Ward(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        districtId: '01',
        provinceId: '01',
      );
      expect(ward, isA<Ward>());
      expect(ward.id, '01');
      expect(ward.name, 'Hoài Đức');
      expect(ward.level, 'Huyện');
      expect(ward.districtId, '01');
      expect(ward.provinceId, '01');
    });
    test('constructor handles null values', () {
      var ward = Ward(
          id: null,
          name: null,
          level: null,
          provinceId: null,
          districtId: null);

      expect(ward, isA<Ward>());
      expect(ward.id, isNull);
      expect(ward.name, isNull);
      expect(ward.level, isNull);
      expect(ward.provinceId, isNull);
      expect(ward.districtId, isNull);
    });

    test('copyWith', () {
      var originalWard = Ward(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        districtId: '01',
        provinceId: '01',
      );

      var copiedWard = originalWard.copyWith(
        name: 'New Name',
        level: 'New Level',
        districtId: '02',
        provinceId: '02',
      );

      expect(copiedWard.id, originalWard.id);
      expect(copiedWard.name, 'New Name');
      expect(copiedWard.level, 'New Level');
      expect(copiedWard.districtId, '02');
      expect(copiedWard.provinceId, '02');
    });

    test('toMap', () {
      var ward = Ward(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        districtId: '01',
        provinceId: '01',
      );

      var map = ward.toMap();

      expect(map['id'], '01');
      expect(map['name'], 'Hoài Đức');
      expect(map['level'], 'Huyện');
      expect(map['districtId'], '01');
      expect(map['provinceId'], '01');
    });

    test('toMap does not include null values', () {
      var ward = Ward(
          id: null,
          name: 'Test Name',
          level: null,
          provinceId: null,
          districtId: null);

      var map = ward.toMap();

      expect(map['id'], isNull);
      expect(map['name'], equals('Test Name'));
      expect(map['level'], isNull);
      expect(map['provinceId'], isNull);
      expect(map['districtId'], isNull);
    });

    test('fromMap', () {
      var map = {
        'id': '01',
        'name': 'Hoài Đức',
        'level': 'Huyện',
        'districtId': '01',
        'provinceId': '01',
      };

      var ward = Ward.fromMap(map);

      expect(ward.id, '01');
      expect(ward.name, 'Hoài Đức');
      expect(ward.level, 'Huyện');
      expect(ward.districtId, '01');
      expect(ward.provinceId, '01');
    });

    test('fromMap handles null values', () {
      var map = {
        'id': null,
        'name': null,
        'level': null,
        'provinceId': null,
        'districtId': null
      };

      var ward = Ward.fromMap(map);

      expect(ward, isA<Ward>());
      expect(ward.id, isNull);
      expect(ward.name, isNull);
      expect(ward.level, isNull);
    });

    test('toJson', () {
      var ward = Ward(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        districtId: '01',
        provinceId: '01',
      );

      var jsonStr = ward.toJson();

      expect(jsonStr,
          '{"id":"01","name":"Hoài Đức","level":"Huyện","districtId":"01","provinceId":"01"}');
    });

    test('fromJson', () {
      var jsonStr =
          '{"id":"01","name":"Hoài Đức","level":"Huyện","districtId":"01","provinceId":"01"}';

      var ward = Ward.fromJson(jsonStr);

      expect(ward.id, '01');
      expect(ward.name, 'Hoài Đức');
      expect(ward.level, 'Huyện');
      expect(ward.districtId, '01');
      expect(ward.provinceId, '01');
    });

    test('fromJson handles null values', () {
      var jsonStr =
          '{"id":null,"name":"Test Name","level":null,"provinceId":null,"districtId":null}';

      var ward = Ward.fromJson(jsonStr);

      expect(ward, isA<Ward>());
      expect(ward.id, isNull);
      expect(ward.name, equals('Test Name'));
      expect(ward.level, isNull);
      expect(ward.provinceId, isNull);
      expect(ward.districtId, isNull);
    });

    test('fromJson handles incomplete JSON', () {
      var jsonStr = '{"name":"Test Name"}';

      var ward = Ward.fromJson(jsonStr);

      expect(ward, isA<Ward>());
      expect(ward.id, isNull);
      expect(ward.name, equals('Test Name'));
      expect(ward.level, isNull);
      expect(ward.provinceId, isNull);
      expect(ward.districtId, isNull);
    });

    test('fromJson handles empty JSON object', () {
      var jsonStr = '{}';

      var ward = Ward.fromJson(jsonStr);

      expect(ward, isA<Ward>());
      expect(ward.id, isNull);
      expect(ward.name, isNull);
      expect(ward.level, isNull);
      expect(ward.provinceId, isNull);
      expect(ward.districtId, isNull);
    });

    test('equality', () {
      var ward1 = Ward(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        districtId: '01',
        provinceId: '01',
      );

      var ward2 = Ward(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        districtId: '01',
        provinceId: '01',
      );

      expect(ward1, equals(ward2));
    });
  });
}
