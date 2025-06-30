import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../../login/widget/text_filed.dart';
import '../bloc/account_bloc.dart';
import 'custom_bottom_navbar.dart';


class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _syncControllers(AccountState state) {
    nameController.text = state.name;
    emailController.text = state.email;
    phoneController.text = state.phone;
    passwordController.text = state.password;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AccountBloc, AccountState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        _syncControllers(state);

        return Scaffold(
          appBar: const NewCustomAppBar(
            showBackButton: false,
            showSearchIcon: false,
            logo: Text('Edit Profile'),
          ),
          bottomNavigationBar: CustomBottomNavbar(
            buttonText: 'SAVE',
            onPressed: () {
              context.read<AccountBloc>().add(
                UpdateAccountData(
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  password: passwordController.text,
                ),
              );
            },
          ),
          backgroundColor: isDarkTheme ? AppColors.blackSand : Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: (state.avatarUrl.isNotEmpty)
                              ? DecorationImage(
                            image: NetworkImage(state.avatarUrl),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: (state.avatarUrl.isEmpty)
                            ? const Icon(Icons.person, size: 80, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () async {
                            final pickedFile =
                            await _picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              // можно добавить новый эвент в блок, если нужен апдейт фото
                            }
                          },
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(controller: nameController),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).password,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(controller: passwordController),
                      const SizedBox(height: 16),
                      const Text(
                        'Email Address',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(controller: emailController),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).number,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextField(controller: phoneController),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
