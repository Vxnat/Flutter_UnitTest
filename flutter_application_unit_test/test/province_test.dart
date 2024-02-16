import 'package:flutter_application_unit_test/models/province.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Province:', () {
    test('constructor', () {
      var province = Province(
        id: '01',
        name: 'Thành phố Hà Nội',
        level: 'Thành phố Trung ương',
      );
      expect(province, isA<Province>());
      expect(province.id, '01');
      expect(province.name, 'Thành phố Hà Nội');
      expect(province.level, 'Thành phố Trung ương');
    });

    test('constructor handles null values', () {
      var province = Province(id: null, name: null, level: null);

      expect(province, isA<Province>());
      expect(province.id, isNull);
      expect(province.name, isNull);
      expect(province.level, isNull);
    });

    test('copyWith', () {
      var originalProvince = Province(
        id: '01',
        name: 'Thành phố Hà Nội',
        level: 'Thành phố Trung ương',
      );

      var copiedProvince = originalProvince.copyWith(
        name: 'New Name',
        level: 'New Level',
      );

      expect(copiedProvince.id, originalProvince.id);
      expect(copiedProvince.name, 'New Name');
      expect(copiedProvince.level, 'New Level');
    });

    test('toMap', () {
      var province = Province(
        id: '01',
        name: 'Thành phố Hà Nội',
        level: 'Thành phố Trung ương',
      );

      var map = province.toMap();

      expect(map['id'], '01');
      expect(map['name'], 'Thành phố Hà Nội');
      expect(map['level'], 'Thành phố Trung ương');
    });

    test('toMap does not include null values', () {
      var province = Province(id: null, name: 'Test Name', level: null);

      var map = province.toMap();

      expect(map['id'], isNull);
      expect(map['name'], equals('Test Name'));
      expect(map['level'], isNull);
    });

    test('fromMap', () {
      var map = {
        'id': '01',
        'name': 'Thành phố Hà Nội',
        'level': 'Thành phố Trung ương',
      };

      var province = Province.fromMap(map);

      expect(province.id, '01');
      expect(province.name, 'Thành phố Hà Nội');
      expect(province.level, 'Thành phố Trung ương');
    });

    test('fromMap handles null values', () {
      var map = {
        'id': null,
        'name': null,
        'level': null,
      };

      var province = Province.fromMap(map);

      expect(province, isA<Province>());
      expect(province.id, isNull);
      expect(province.name, isNull);
      expect(province.level, isNull);
    });

    test('toJson', () {
      var province = Province(
        id: '01',
        name: 'Thành phố Hà Nội',
        level: 'Thành phố Trung ương',
      );

      var jsonStr = province.toJson();

      expect(jsonStr,
          '{"id":"01","name":"Thành phố Hà Nội","level":"Thành phố Trung ương"}');
    });

    test('fromJson', () {
      var jsonStr =
          '{"id":"01","name":"Thành phố Hà Nội","level":"Thành phố Trung ương"}';

      var province = Province.fromJson(jsonStr);

      expect(province.id, '01');
      expect(province.name, 'Thành phố Hà Nội');
      expect(province.level, 'Thành phố Trung ương');
    });

    test('fromJson handles null values', () {
      var jsonStr = '{"id":null,"name":"Test Name","level":null}';

      var province = Province.fromJson(jsonStr);

      expect(province, isA<Province>());
      expect(province.id, isNull);
      expect(province.name, equals('Test Name'));
      expect(province.level, isNull);
    });

    test('fromJson handles incomplete JSON', () {
      var jsonStr = '{"name":"Test Name"}';

      var province = Province.fromJson(jsonStr);

      expect(province, isA<Province>());
      expect(province.id, isNull);
      expect(province.name, equals('Test Name'));
      expect(province.level, isNull);
    });

    test('fromJson handles empty JSON object', () {
      var jsonStr = '{}';

      var province = Province.fromJson(jsonStr);

      expect(province, isA<Province>());
      expect(province.id, isNull);
      expect(province.name, isNull);
      expect(province.level, isNull);
    });

    test('equality', () {
      var province1 = Province(
        id: '01',
        name: 'Thành phố Hà Nội',
        level: 'Thành phố Trung ương',
      );

      var province2 = Province(
        id: '01',
        name: 'Thành phố Hà Nội',
        level: 'Thành phố Trung ương',
      );

      expect(province1, equals(province2));
      expect(province1.hashCode, equals(province2.hashCode));
    });
  });
}
