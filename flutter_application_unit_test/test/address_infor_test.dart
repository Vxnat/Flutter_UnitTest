import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_unit_test/models/address_info.dart';
import 'package:flutter_application_unit_test/models/user_info.dart';

void main() {
  group('AddressInfo Tests', () {
    test('AddressInfo constructor should create an instance with valid data',
        () {
      // Arrange
      final Map<String, dynamic> testData = {
        'province': {
          'id': '01',
          'name': 'Thành phố Hà Nội',
          'level': 'Thành phố',
        },
        'district': {
          'id': '001',
          'name': 'Quận Ba Đình',
          'level': 'Quận',
          'provinceId': '01'
        },
        'ward': {
          "id": "00001",
          "name": "Phường Phúc Xá",
          "level": "Phường",
          "districtId": "001",
          "provinceId": "01"
        },
        'street': 'Test Street',
      };

      // Act
      final addressInfo = AddressInfo.fromMap(testData);

      // Assert
      expect(addressInfo, isA<AddressInfo>());
      expect(addressInfo.province?.name, 'Thành phố Hà Nội');
      expect(addressInfo.district?.name, 'Quận Ba Đình');
      expect(addressInfo.ward?.name, 'Phường Phúc Xá');
      expect(addressInfo.street, 'Test Street');
    });
    test(
        'fromMap should return AddressInfo instance with null values if input is null',
        () {
      // Kiểm tra xem các đối tượng có được tạo thành công từ dữ liệu đầu vào không.
      // Arrange
      const Map<String, dynamic>? testData = null;

      // Act
      final addressInfo = AddressInfo.fromMap(testData ?? {});

      // Assert
      expect(addressInfo, isA<AddressInfo>());
      expect(addressInfo.province, isNull);
      expect(addressInfo.district, isNull);
      expect(addressInfo.ward, isNull);
      expect(addressInfo.street, isNull);
    });

    test(
        'fromMap should return AddressInfo instance with correct values from input',
        () {
      // Kiểm tra tính đúng đắn của các thuộc tính của các đối tượng.
      // Arrange
      final Map<String, dynamic> testData = {
        'province': {
          'id': '01',
          'name': 'Thành phố Hà Nội',
          'level': 'Thành phố',
        },
        'district': {
          'id': '001',
          'name': 'Quận Ba Đình',
          'level': 'Quận',
          'provinceId': '01'
        },
        'ward': {
          "id": "00001",
          "name": "Phường Phúc Xá",
          "level": "Phường",
          "districtId": "001",
          "provinceId": "01"
        },
        'street': '123 Street',
      };

      // Act
      final addressInfo = AddressInfo.fromMap(testData);

      // Assert
      expect(addressInfo, isA<AddressInfo>());
      expect(addressInfo.province?.id, '01');
      expect(addressInfo.district?.id, '001');
      expect(addressInfo.ward?.id, '00001');
      expect(addressInfo.street, '123 Street');
    });

    test(
        'fromMap should return AddressInfo instance with null values if input is empty',
        () {
      // Arrange
      final Map<String, dynamic> testData = {};

      // Act
      final addressInfo = AddressInfo.fromMap(testData);

      // Assert
      expect(addressInfo, isA<AddressInfo>());
      expect(addressInfo.province, isNull);
      expect(addressInfo.district, isNull);
      expect(addressInfo.ward, isNull);
      expect(addressInfo.street, isNull);
    });

    test(
        'fromMap should return AddressInfo instance with null values if input has missing fields',
        () {
      // Arrange
      final Map<String, dynamic> testData = {
        'province': {
          'id': '01',
          'name': 'Thành phố Hà Nội',
          'level': 'Thành phố',
        },
        // 'district' and 'ward' fields are missing
        'street': '123 Street',
      };

      // Act
      final addressInfo = AddressInfo.fromMap(testData);

      // Assert
      expect(addressInfo, isA<AddressInfo>());
      expect(addressInfo.province?.id, '01');
      expect(addressInfo.district, isNull);
      expect(addressInfo.ward, isNull);
      expect(addressInfo.street, '123 Street');
    });
  });

  group('UserInfo Tests', () {
    test('UserInfo constructor should create an instance with valid data', () {
      // Arrange
      final Map<String, dynamic> testData = {
        'name': 'Anh Tu',
        'email': 'nguyenatu2003@gmail.com',
        'phoneNumber': '0399549912',
        'birthDate': '2003-10-18',
        'address': {
          'province': {
            'id': '01',
            'name': 'Thành phố Hà Nội',
            'level': 'Thành phố',
          },
          'district': {
            'id': '001',
            'name': 'Quận Ba Đình',
            'level': 'Quận',
            'provinceId': '01'
          },
          'ward': {
            "id": "00001",
            "name": "Phường Phúc Xá",
            "level": "Phường",
            "districtId": "001",
            "provinceId": "01"
          },
          'street': 'Test Street',
        },
      };

      // Act
      final userInfo = UserInfo.fromMap(testData);

      // Assert
      expect(userInfo, isA<UserInfo>());
      expect(userInfo.name, 'Anh Tu');
      expect(userInfo.email, 'nguyenatu2003@gmail.com');
      expect(userInfo.phoneNumber, '0399549912');
      expect(userInfo.birthDate, DateTime.parse('2003-10-18'));
      expect(userInfo.address?.province?.name, 'Thành phố Hà Nội');
      expect(userInfo.address?.district?.name, 'Quận Ba Đình');
      expect(userInfo.address?.ward?.name, 'Phường Phúc Xá');
      expect(userInfo.address?.street, 'Test Street');
    });
    test(
        'fromMap should return UserInfo instance with null values if input is null',
        () {
      // Kiểm tra xem các đối tượng có được tạo thành công từ dữ liệu đầu vào không.
      // Arrange
      const Map<String, dynamic>? testData = null;

      // Act
      final userInfo = UserInfo.fromMap(testData ?? {});

      // Assert
      expect(userInfo, isA<UserInfo>());
      expect(userInfo.name, isNull);
      expect(userInfo.email, isNull);
      expect(userInfo.phoneNumber, isNull);
      expect(userInfo.birthDate, isNull);
      expect(userInfo.address, isNull);
    });

    test(
        'fromMap should return UserInfo instance with correct values from input',
        () {
      // Kiểm tra tính đúng đắn của các thuộc tính của các đối tượng.
      // Arrange
      final Map<String, dynamic> testData = {
        'name': 'Anh Tu',
        'email': 'nguyenatu2003@gmail.com',
        'phoneNumber': '0399549912',
        'birthDate': '2003-10-18',
        'address': {
          'province': {
            'id': '01',
            'name': 'Thành phố Hà Nội',
            'level': 'Thành phố',
          },
          'district': {
            'id': '001',
            'name': 'Quận Ba Đình',
            'level': 'Quận',
            'provinceId': '01'
          },
          'ward': {
            "id": "00001",
            "name": "Phường Phúc Xá",
            "level": "Phường",
            "districtId": "001",
            "provinceId": "01"
          },
          'street': '123 Street',
        },
      };

      // Act
      final userInfo = UserInfo.fromMap(testData);

      // Assert
      expect(userInfo, isA<UserInfo>());
      expect(userInfo.name, 'Anh Tu');
      expect(userInfo.email, 'nguyenatu2003@gmail.com');
      expect(userInfo.phoneNumber, '0399549912');
      expect(userInfo.birthDate, DateTime.parse('2003-10-18'));
      expect(userInfo.address, isA<AddressInfo>());
    });

    test(
        'fromMap should return UserInfo instance with null values if input is empty',
        () {
      // Arrange
      final Map<String, dynamic> testData = {};

      // Act
      final userInfo = UserInfo.fromMap(testData);

      // Assert
      expect(userInfo, isA<UserInfo>());
      expect(userInfo.name, isNull);
      expect(userInfo.email, isNull);
      expect(userInfo.phoneNumber, isNull);
      expect(userInfo.birthDate, isNull);
      expect(userInfo.address, isNull);
    });

    test(
        'fromMap should return UserInfo instance with null values if input has missing fields',
        () {
      // Arrange
      final Map<String, dynamic> testData = {
        'name': 'Anh Tu',
        'email': 'nguyenatu2003@gmail.com',
        'address': {
          'province': {
            'id': '01',
            'name': 'Thành phố Hà Nội',
            'level': 'Thành phố',
          },
          'district': {
            'id': '001',
            'name': 'Quận Ba Đình',
            'level': 'Quận',
            'provinceId': '01'
          },
          'ward': {
            "id": "00001",
            "name": "Phường Phúc Xá",
            "level": "Phường",
            "districtId": "001",
            "provinceId": "01"
          },
          'street': '123 Street',
        },
      };

      // Act
      final userInfo = UserInfo.fromMap(testData);

      // Assert
      expect(userInfo, isA<UserInfo>());
      expect(userInfo.name, 'Anh Tu');
      expect(userInfo.email, 'nguyenatu2003@gmail.com');
      expect(userInfo.phoneNumber, isNull);
      expect(userInfo.birthDate, isNull);
      expect(userInfo.address, isA<AddressInfo>());
    });
  });
}
