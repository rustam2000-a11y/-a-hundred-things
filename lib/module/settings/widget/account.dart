import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../../login/widget/custom_text.dart';
import '../../login/widget/text_filed.dart';
import 'custom_bottom_navbar.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        passwordController.text = userData['password'] ?? '';
        _imageUrl = userData['avatarUrl'] ?? '';

      }
    }
  }
  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _imageFile = File(pickedFile.path);
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_avatars')
        .child('$userId.jpg');

    await storageRef.putFile(_imageFile!);
    final downloadUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      'avatarUrl': downloadUrl,
    });

    setState(() {
      _imageUrl = downloadUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo updated successfully')),
    );
  }

  Future<void> _updateUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const NewCustomAppBar(
          showBackButton: false,
          showSearchIcon: false,
          logo: Text('Edit Profile'),
      ),
      bottomNavigationBar:CustomBottomNavbar(buttonText: 'SAVE', onPressed: _updateUserData,),
      backgroundColor: isDarkTheme ? AppColors.blackSand : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:24 ),
            Center(
              child: Stack(
                children: [

                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: _imageUrl != null
                          ? DecorationImage(
                        image: NetworkImage(_imageUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageUrl == null
                        ? const Icon(Icons.person, size: 80, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
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
                  Text(
                    S.of(context).name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: nameController,
                    hintText: CustomText4(text: S.of(context).enterName),
                    height: 40,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: emailController,
                    hintText: CustomText4(text: S.of(context).enterYourEmail),
                    height: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).number,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: phoneController,
                    hintText: CustomText4(text: S.of(context).enterNumber),
                    height: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).password,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: passwordController,
                    hintText:
                        CustomText4(text: S.of(context).enterYourPassword),
                    height: 40,
                  ),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
