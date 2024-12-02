import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../presentation/colors.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../presentation/colors.dart';

Future<void> showItemDetailsBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
  required String type,
  required String itemId,
  String? imageUrl,
}) async {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight * 0.9,
            color: isDarkMode ? AppColors.blackSand : Colors.white,
            child: Stack(
              children: [
                Container(
                  height: screenHeight * 0.6,
                  color: isDarkMode
                      ? AppColors.blackSand
                      : Colors.deepPurpleAccent[200],
                  child: imageUrl != null
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                      : Center(
                    child: Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.05,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Тип: $type',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.55,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.50,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      gradient: isDarkMode
                          ? AppColors.darkBlueGradient
                          : null,
                      color: isDarkMode
                          ? null
                          : AppColors.silverColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Название:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Описание:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.blackSand
                          : AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Добавлено')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? AppColors.greySand
                                : Colors.blueAccent,
                            foregroundColor:
                            isDarkMode ? Colors.black : Colors.white,
                          ),
                          child: Text(
                            "Добавить",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('item')
                                  .doc(itemId)
                                  .delete();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Элемент удалён')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Ошибка: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            "Удалить",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}





