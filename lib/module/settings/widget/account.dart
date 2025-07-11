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
        final data = userDoc.data()!;
        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          passwordController.text = data['password'] ?? '';
          _imageUrl = data['avatarUrl'] ?? '';
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final file = File(pickedFile.path);

      final bytes = await file.readAsBytes();
      final filename = '$userId.jpg';
      final ref =
          FirebaseStorage.instance.ref().child('user_avatars/$filename');

      print('Uploading avatar BYTES: ${file.path}');
      final uploadTask = await ref.putData(bytes);

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'avatarUrl': downloadUrl,
      });

      setState(() {
        _imageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo updated successfully')),
      );
    } on FirebaseException catch (e) {
      print('🔥 Firebase error: ${e.code} | ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase error: ${e.message}')),
      );
    } catch (e) {
      print('❌ Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload photo')),
      );
    }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const NewCustomAppBar(
        showBackButton: false,
        showSearchIcon: false,
        logo: Text('Edit Profile'),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        buttonText: 'SAVE',
        onPressed: _updateUserData,
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
                      image: (_imageUrl != null && _imageUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(_imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (_imageUrl == null || _imageUrl!.isEmpty)
                        ? const Icon(Icons.person,
                            size: 80, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _pickAndUploadImage,
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 20),
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
                    "Username",
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
                    'Email Adderss',
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
  }
}
