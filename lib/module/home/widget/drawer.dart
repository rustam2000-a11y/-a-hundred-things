import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/colors.dart';
import '../../login/screen/login_screen.dart';
import '../../settings/bloc/account_bloc.dart';
import '../../settings/screen/user_profile_screen.dart';
import '../../things/new_things/favorite_screen.dart';
import '../category/category_page.dart';
import '../my_home_page.dart';
import 'custom_divider.dart';
import 'custom_list_tile.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer(
      {super.key, required this.onToggleCategoryList, this.toggleTheme});

  final void Function(bool show) onToggleCategoryList;
  final VoidCallback? toggleTheme;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(LoadAccountData());
  }

  @override
  Widget build(BuildContext context) {
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
              BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.error != null) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Loading error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            image: (state.avatarUrl.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(state.avatarUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (state.avatarUrl.isEmpty)
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.name.isNotEmpty ? state.name : 'No name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              state.email.isNotEmpty
                                  ? state.email
                                  : 'No email',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const CustomDivider(),
              const SizedBox(height: 10),
              CustomListTile(
                icon: Icons.home_filled,
                text: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          MyHomePage(toggleTheme: widget.toggleTheme),
                    ),
                  );
                },
              ),
              CustomListTile(
                icon: Icons.folder_copy,
                text: 'My categories',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const CategoriePage(),
                    ),
                  );
                },
              ),
              CustomListTile(
                icon: Icons.favorite,
                text: 'Favorites',
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const FavorieteScreen(),
                      ),
                    );
                  });
                },
              ),
              CustomListTile(
                icon: Icons.settings,
                text: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 250), () {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => UserProfileScreen(
                            toggleTheme: widget.toggleTheme ?? () {}),
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: 80),
              CustomListTile(
                imagePath: 'assets/images/bxs_exit.png',
                text: 'Logout',
                textColor: AppColors.red,
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => LoginPage(toggleTheme: () {}),
                      ),
                    );
                  } catch (e) {
                    debugPrint('Error signing out: $e');
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
