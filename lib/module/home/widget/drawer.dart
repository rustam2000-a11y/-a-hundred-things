import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../login/screen/login_screen.dart';
import '../../settings/widget/user_profile_screen.dart';
import 'custom_divider.dart';
import 'custom_list_tile.dart';

class CustomDrawer extends StatefulWidget {

  const CustomDrawer({super.key, required this.onToggleCategoryList});
  final void Function(bool show) onToggleCategoryList;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}


class _CustomDrawerState extends State<CustomDrawer> {
  String name = 'Загрузка...';
  String email = 'Загрузка...';

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
  Widget build(BuildContext context)  {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, size: 24),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/house2.png',
                        width: 32,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/inscription2.png',
                        width: 100,
                        height: 16,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const CustomDivider(),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 16),
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
              const SizedBox(height: 10),


              CustomListTile(
                icon: Icons.home_filled,
                text: 'Main',
                onTap: () {
                  Navigator.pop(context);
                  widget.onToggleCategoryList(false);
                },
              ),
              CustomListTile(
                icon: Icons.folder_copy,
                text: 'My categories ',
                onTap: () {
                  Navigator.pop(context);
                  widget.onToggleCategoryList(true);
                },
              ),
              CustomListTile(
                icon: Icons.email,
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
                icon: Icons.favorite,
                text: 'Favorites',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              CustomListTile(
                icon: Icons.settings,
                text: 'Settings',
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
              CustomListTile(
                icon: Icons.qr_code_scanner,
                text: 'Scan QR',
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 80),
              CustomListTile(
                icon: Icons.question_mark_sharp,
                text: 'Help',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              CustomListTile(
                icon: Icons.logout,
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
    );
  }
}
