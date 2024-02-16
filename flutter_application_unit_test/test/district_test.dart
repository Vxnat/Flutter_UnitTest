import 'package:flutter_application_unit_test/models/district.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('District:', () {
    test('constructor', () {
      var district = District(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        provinceId: '01',
      );
      expect(district, isA<District>());
      expect(district.id, '01');
      expect(district.name, 'Hoài Đức');
      expect(district.level, 'Huyện');
      expect(district.provinceId, '01');
    });

    test('constructor handles null values', () {
      var district =
          District(id: null, name: null, level: null, provinceId: null);

      expect(district, isA<District>());
      expect(district.id, isNull);
      expect(district.name, isNull);
      expect(district.level, isNull);
      expect(district.provinceId, isNull);
    });

    test('copyWith', () {
      var originalDistrict = District(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        provinceId: '01',
      );

      var copiedDistrict = originalDistrict.copyWith(
        name: 'New Name',
        level: 'New Level',
        provinceId: '02',
      );

      expect(copiedDistrict.id, originalDistrict.id);
      expect(copiedDistrict.name, 'New Name');
      expect(copiedDistrict.level, 'New Level');
      expect(copiedDistrict.provinceId, '02');
    });

    test('toMap', () {
      var district = District(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        provinceId: '01',
      );

      var map = district.toMap();

      expect(map['id'], '01');
      expect(map['name'], 'Hoài Đức');
      expect(map['level'], 'Huyện');
      expect(map['provinceId'], '01');
    });

    test('toMap does not include null values', () {
      var district =
          District(id: null, name: 'Test Name', level: null, provinceId: null);

      var map = district.toMap();

      expect(map['id'], isNull);
      expect(map['name'], equals('Test Name'));
      expect(map['level'], isNull);
      expect(map['provinceId'], isNull);
    });

    test('fromMap', () {
      var map = {
        'id': '01',
        'name': 'Hoài Đức',
        'level': 'Huyện',
        'provinceId': '01',
      };

      var district = District.fromMap(map);

      expect(district.id, '01');
      expect(district.name, 'Hoài Đức');
      expect(district.level, 'Huyện');
      expect(district.provinceId, '01');
    });

    test('fromMap handles null values', () {
      var map = {'id': null, 'name': null, 'level': null, 'provinceId': null};

      var district = District.fromMap(map);

      expect(district, isA<District>());
      expect(district.id, isNull);
      expect(district.name, isNull);
      expect(district.level, isNull);
    });

    test('toJson', () {
      var district = District(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        provinceId: '01',
      );

      var jsonStr = district.toJson();

      expect(jsonStr,
          '{"id":"01","name":"Hoài Đức","level":"Huyện","provinceId":"01"}');
    });

    test('fromJson', () {
      var jsonStr =
          '{"id":"01","name":"Hoài Đức","level":"Huyện","provinceId":"01"}';

      var district = District.fromJson(jsonStr);

      expect(district.id, '01');
      expect(district.name, 'Hoài Đức');
      expect(district.level, 'Huyện');
      expect(district.provinceId, '01');
    });
    test('fromJson handles null values', () {
      var jsonStr =
          '{"id":null,"name":"Test Name","level":null,"provinceId":null}';

      var district = District.fromJson(jsonStr);

      expect(district, isA<District>());
      expect(district.id, isNull);
      expect(district.name, equals('Test Name'));
      expect(district.level, isNull);
      expect(district.provinceId, isNull);
    });

    test('fromJson handles incomplete JSON', () {
      var jsonStr = '{"name":"Test Name"}';

      var district = District.fromJson(jsonStr);

      expect(district, isA<District>());
      expect(district.id, isNull);
      expect(district.name, equals('Test Name'));
      expect(district.level, isNull);
      expect(district.provinceId, isNull);
    });

    test('fromJson handles empty JSON object', () {
      var jsonStr = '{}';

      var district = District.fromJson(jsonStr);

      expect(district, isA<District>());
      expect(district.id, isNull);
      expect(district.name, isNull);
      expect(district.level, isNull);
      expect(district.provinceId, isNull);
    });

    test('equality', () {
      var district1 = District(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        provinceId: '01',
      );

      var district2 = District(
        id: '01',
        name: 'Hoài Đức',
        level: 'Huyện',
        provinceId: '01',
      );

      expect(district1, equals(district2));
    });
  });
}
