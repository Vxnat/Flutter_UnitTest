// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_application_unit_test/main.dart';

// ignore: must_be_immutable, camel_case_types
class Complete_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Information people',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.check,
              color: Colors.green,
              size: 50,
            ),
            const Text(
              'Hoàn thành',
              style: TextStyle(fontSize: 30),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 15,
                      shadowColor: Colors.blue),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => (MyStepperApp())),
                      (route) => false,
                    );
                  },
                  child: const Text('Reset')),
            )
          ]),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
