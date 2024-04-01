import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_get_api_news/auth/auth_service.dart';
import 'package:flutter_application_get_api_news/components/my_text_box.dart';
import 'package:flutter_application_get_api_news/provider/list_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          cursorColor: Colors.grey,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintText: 'Enter new $field',
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(newValue);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context.read<ListProvider>().listFavorite.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[430],
        appBar: AppBar(
          title: const Text(
            'My profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: logout,
                icon: const Icon(
                  Icons.output,
                  color: Colors.white,
                ))
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
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
                    currentUser.email!,
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
                    text: userData['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),
                  MyTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          },
        ));
  }
}
