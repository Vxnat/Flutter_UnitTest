import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:provider/provider.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function() onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: !context.read<ListProvider>().isDarkMode
                ? Colors.grey[200]
                : Colors.grey[900]),
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sectionName,
                  style: TextStyle(
                      color: !context.read<ListProvider>().isDarkMode
                          ? Colors.grey[500]
                          : Colors.grey[200]),
                ),
                IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.settings,
                      color: !context.read<ListProvider>().isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[200],
                    ))
              ],
            ),
            Text(
              text,
              style: TextStyle(
                  color: !context.read<ListProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey[200]),
            )
          ],
        ));
  }
}
