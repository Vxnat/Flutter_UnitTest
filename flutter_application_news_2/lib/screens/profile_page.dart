import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/components/my_text_box.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void tongleDarkMode() {
    context.read<ListProvider>().isDarkMode =
        !context.read<ListProvider>().isDarkMode;
    context.read<ListProvider>().saveSettingLocal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: PopupMenuButton<String>(
                icon: const Icon(Icons.settings),
                tooltip: '',
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'changeDarkMode',
                    child: Text('Chuyển chế độ'),
                  ),
                ],
                // Xử lý khi một mục được chọn từ PopupMenu
                onSelected: (String value) {
                  if (value == 'changeDarkMode') {
                    tongleDarkMode();
                  }
                },
                iconSize: 23,
                iconColor: Colors.white,
              ),
            )
          ],
        ),
        body: Container(
          color: !context.read<ListProvider>().isDarkMode
              ? Colors.white
              : Colors.grey[200],
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.person,
                size: 72,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'nguyenatu2003@gmail.com',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'My Details',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              MyTextBox(
                text: 'Nguyen Anh Tu',
                sectionName: 'username',
                onPressed: () {},
              ),
              MyTextBox(
                text: 'Siuuuu',
                sectionName: 'bio',
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
