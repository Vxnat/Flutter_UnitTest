import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_unit_test/complete_page.dart';
import 'package:flutter_application_unit_test/models/district.dart';
import 'package:flutter_application_unit_test/models/province.dart';
import 'package:flutter_application_unit_test/models/ward.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyStepperApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStepperApp extends StatefulWidget {
  @override
  _MyStepperAppState createState() => _MyStepperAppState();
}

class _MyStepperAppState extends State<MyStepperApp> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  String errorTextValue = '';

  List<Province> provinceList = [
    Province(id: '', name: '', level: ''),
  ];
  List<District> districtList = [
    District(id: '', name: '', level: '', provinceId: '')
  ];
  List<District> districtListChoosen = [
    District(id: '', name: '', level: '', provinceId: '')
  ];
  List<Ward> wardList = [
    Ward(id: '', name: '', level: '', provinceId: '', districtId: '')
  ];
  List<Ward> wardListChoosen = [
    Ward(id: '', name: '', level: '', provinceId: '', districtId: '')
  ];
  // Lay du lieu API Provinces

  @override
  void initState() {
    super.initState();
    loadLocationData();
  }

  String? getIdFromProvinceName(String provinceName) {
    Province? selectedProvince = provinceList.firstWhere(
      (province) => province.name == provinceName,
      orElse: () => Province(
          id: '',
          name: '',
          level: ''), // Trả về một Province mặc định khi không tìm thấy
    );
    return selectedProvince.id;
  }

  String? getIdFromDistrictName(String districtName) {
    District? selectedDistrict = districtList.firstWhere(
      (district) => district.name == districtName,
      orElse: () => District(
          id: '',
          name: '',
          level: '',
          provinceId: ''), // Trả về một Province mặc định khi không tìm thấy
    );
    return selectedDistrict.id;
  }

  List<District> getDistrictsByProvinceId(String targetProvinceId) {
    return districtList
        .where((district) => district.provinceId == targetProvinceId)
        .toList();
  }

  int currentStep = 0;
  String globalProvinceId = "";
  String name = "";
  String gender = "";
  dynamic date = "";
  dynamic phone = "";
  dynamic email = "";
  String province = "";
  String district = "";
  String ward = "";
  String detailedAddress = "";

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isEmailValid = emailRegex.hasMatch(email ?? "");
    if (!isEmailValid) {
      return 'Vui lòng nhập chính xác Email';
    } else {
      return null;
    }
  }

  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thông tin người dùng'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.blue)),
          child: Stepper(
            type: StepperType.horizontal,
            steps: [
              step1(context),
              step2(),
              step3(),
            ],
            currentStep: currentStep,
            onStepContinue: () {
              if (_validateCurrentStep()) {
                _saveCurrentStep();
                setState(() {
                  // Kiểm tra nếu currentStep không phải là bước cuối cùng thì tăng giá trị lên 1
                  if (currentStep < 2) {
                    currentStep++;
                  } else {
                    // Nếu currentStep là bước cuối cùng, đánh dấu là đã hoàn thành
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Complete_Page()),
                      (route) => false,
                    );
                  }
                });
              }
            },
            onStepCancel: () {
              setState(() {
                currentStep > 0 ? currentStep-- : null;
              });
            },
            onStepTapped: (step) {
              setState(() {
                if (currentStep == 0) {
                  if (_formKey1.currentState!.validate()) {
                    currentStep = step;
                  }
                } else if (currentStep == 1) {
                  if (_formKey2.currentState!.validate()) {
                    currentStep = step;
                  }
                }
              });
            },
            controlsBuilder:
                (BuildContext context, ControlsDetails controlsDetails) {
              return Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: controlsDetails.onStepContinue,
                          child: Text(currentStep < 2 ? 'Next' : 'Complete'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Nút Continue được tùy chỉnh
                      // Nút Cancel được tùy chỉnh
                      if (currentStep != 0)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: controlsDetails.onStepCancel,
                            child: const Text('Back'),
                          ),
                        )
                    ],
                  ));
            },
          ),
        ));
  }

  Step step3() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController dateController = TextEditingController(text: date);
    TextEditingController genderController =
        TextEditingController(text: gender);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController provinceController =
        TextEditingController(text: province);
    TextEditingController districtController =
        TextEditingController(text: district);
    TextEditingController wardController = TextEditingController(text: ward);
    TextEditingController detailedAddressController =
        TextEditingController(text: detailedAddress);
    return Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: const Text('Xác nhận'),
      content: Form(
        key: _formKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: nameController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: dateController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: phoneController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: genderController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: emailController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: provinceController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Tỉnh/Thành',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: districtController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Quận/Huyện',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: wardController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Xã/Phường',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
                controller: detailedAddressController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ chi tiết',
                  labelStyle: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(33, 150, 243, 1))),
                )),
          ],
        ),
      ),
    );
  }

  Step step2() {
    return Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('Địa chỉ'),
      content: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Province
            DropdownButtonFormField<String>(
              value: province,
              onChanged: (value) {
                setState(() {
                  province = value!;
                  // Người dùng đã lựa chọn Province thì hiển thị District và Ward
                  if (value != '') {
                    var provinceIdTemp = getIdFromProvinceName(value);
                    // Lấy dữ liệu về tỉnh thành thông qua tên
                    districtListChoosen.clear();
                    districtListChoosen.add(
                        District(id: '', name: '', level: '', provinceId: ''));
                    districtListChoosen += districtList
                        .where(
                            (district) => district.provinceId == provinceIdTemp)
                        .toList();
                    district = districtListChoosen[1].name!;
                    var districtIdTemp = getIdFromDistrictName(district);
                    wardListChoosen.clear();
                    wardListChoosen.add(Ward(
                        id: '',
                        name: '',
                        level: '',
                        provinceId: '',
                        districtId: ''));
                    wardListChoosen += wardList
                        .where((ward) =>
                            ward.districtId == districtIdTemp &&
                            ward.provinceId == provinceIdTemp)
                        .toList();
                    ward = wardListChoosen[1].name!;
                  } else // Nếu chưa chọn Province hoặc cố tình chọn lại rỗng
                  // Thì ta cho District và Ward về danh sách khởi tạo
                  {
                    districtListChoosen.clear();
                    districtListChoosen.add(
                        District(id: '', name: '', level: '', provinceId: ''));
                    district = districtListChoosen[0].name!;
                    wardListChoosen.clear();
                    wardListChoosen.add(Ward(
                        id: '',
                        name: '',
                        level: '',
                        provinceId: '',
                        districtId: ''));
                    ward = wardListChoosen[0].name!;
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn Tỉnh/Thành !';
                }
                return null;
              },
              items: provinceList.map((Province province) {
                return DropdownMenuItem<String>(
                  value: province.name,
                  child: Text(province.name!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Tỉnh/Thành',
              ),
            ),
            // End Province
            // District
            DropdownButtonFormField<String>(
              value: district,
              onChanged: (value) {
                setState(() {
                  district = value!;
                  // Người dùng đã lựa chọn District thì hiển thị Ward
                  if (value != '') {
                    var districtIdTemp = getIdFromDistrictName(district);
                    wardListChoosen.clear();
                    wardListChoosen.add(Ward(
                        id: '',
                        name: '',
                        level: '',
                        provinceId: '',
                        districtId: ''));
                    wardListChoosen += wardList
                        .where((ward) => ward.districtId == districtIdTemp)
                        .toList();
                    ward = wardListChoosen[1].name!;
                  } else
                  // Cố tình chọn rỗng thì ta khởi tạo Ward về giá trị ban đầu
                  {
                    wardListChoosen.clear();
                    wardListChoosen.add(Ward(
                        id: '',
                        name: '',
                        level: '',
                        provinceId: '',
                        districtId: ''));
                    ward = wardListChoosen[0].name!;
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn Quận/Huyện !';
                }
                return null;
              },
              items: districtListChoosen.map((District district) {
                return DropdownMenuItem<String>(
                  value: district.name,
                  child: Text(district.name!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Quận/Huyện',
              ),
            ),
            // End District
            // Ward
            DropdownButtonFormField<String>(
              value: ward,
              onChanged: (value) {
                setState(() {
                  ward = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn Xã/Phường !';
                }
                return null;
              },
              // Kiểm tra wardList có chứa quận , huyện được chọn không , nếu ko thì cho list rỗng
              items: wardListChoosen.map((Ward ward) {
                return DropdownMenuItem<String>(
                  value: ward.name,
                  child: Text(ward.name!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Xã/Phường',
              ),
            ),
            // End Ward
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Địa chỉ chi tiết',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng điền địa chỉ chi tiết !';
                }
                return null;
              },
              onChanged: (value) {
                detailedAddress = value;
              },
              onSaved: (value) {
                detailedAddress = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  Step step1(BuildContext context) {
    return Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: const Text('Cơ bản'),
      content: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Họ và tên'),
              validator: (value) {
                if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value!) ||
                    value.isEmpty) {
                  return 'Vui lòng nhập chính xác Họ và Tên';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                name = value!;
              },
            ),
            // Date picker for Date of Birth
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: IgnorePointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Ngày sinh'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ngày sinh không được để trống';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    date = value;
                  },
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Vui lòng nhập Số điện thoại !';
                } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Định dạng Số điện thoại không hợp lệ !';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                phone = value;
              },
            ),
            // Dropdown for Gender
            DropdownButtonFormField<String>(
              value: gender,
              decoration: const InputDecoration(
                  labelText: 'Giới tính', labelStyle: TextStyle(fontSize: 20)),
              items: ['', 'Nam', 'Nữ', 'Khác'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn giới tính';
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              onSaved: (value) {
                email = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return _formKey1.currentState?.validate() ?? false;
      case 1:
        return _formKey2.currentState?.validate() ?? false;
      case 2:
        return _formKey3.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  void _saveCurrentStep() {
    switch (currentStep) {
      case 0:
        _formKey1.currentState?.save();
        break;
      case 1:
        _formKey2.currentState?.save();
        break;
      case 2:
        _formKey3.currentState?.save();
        break;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> loadLocationData() async {
    try {
      String data =
          await rootBundle.loadString('../assets/don_vi_hanh_chinh.json');
      Map<String, dynamic> jsonData = json.decode(data);

      List<dynamic> provinceData = jsonData['province'];
      provinceList
          .addAll(provinceData.map((json) => Province.fromMap(json)).toList());
      List<dynamic> districtData = jsonData['district'];
      districtList
          .addAll(districtData.map((json) => District.fromMap(json)).toList());

      List<dynamic> wardData = jsonData['ward'];
      wardList.addAll(wardData.map((json) => Ward.fromMap(json)).toList());
    } catch (e) {
      debugPrint('Error loading data');
    }
  }

  // Load lại data District khi Provinces thay đổi
  String getKeyByValue(Map<String, String> map, String targetValue) {
    for (var entry in map.entries) {
      if (entry.value == targetValue) {
        return entry.key;
      }
    }
    return ' ';
  }
}
