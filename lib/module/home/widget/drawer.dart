import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../presentation/colors.dart';
import '../../login/login_page.dart';
import '../../settings/widget/user_profile_screen.dart';
import 'custom_divider.dart';
import 'custom_list_tile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String name = "Загрузка...";
  String email = "Загрузка...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final docSnapshot = await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (docSnapshot.exists) {
        setState(() {
          name = docSnapshot.data()?['name'] ?? "Неизвестное имя";
          email = docSnapshot.data()?['email'] ?? "Нет email";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20,
              bottom: 15,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/house.png',
                        width: 20,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/100 Things (6).png',
                        width: 106,
                        height: 26,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const CustomDivider(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const CustomDivider(),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text("Main"),
                  ],
                ),

                CustomListTile(
                  icon: Icons.home_filled,
                  text: 'Main',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                CustomListTile(
                  icon: Icons.email_outlined,
                  text: 'Inbox',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                CustomListTile(
                  icon: Icons.send,
                  text: 'Outbox',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                CustomListTile(
                  icon: Icons.favorite_border,
                  text: 'Favorites',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                CustomListTile(
                  icon: Icons.archive,
                  text: 'Archive',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const CustomDivider(),
                const Row(
                  children: [
                    Text('Settings'),
                  ],
                ),
                ListTile(
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.settings_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) =>
                            UserProfileScreen(toggleTheme: () {}),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomListTile(
                  icon: Icons.question_mark_sharp,
                  text: 'Help',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                CustomListTile(
                  icon: Icons.output_rounded,
                  text: 'Logout',
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      await Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (context) => LoginPage(
                            toggleTheme: () {},
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Error signing out: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
