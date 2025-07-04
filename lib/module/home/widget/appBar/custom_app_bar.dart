import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../presentation/colors.dart';
import '../../../../repository/things_repository.dart';
import '../../../settings/screen/user_profile_screen.dart';
import '../icon_home.dart';


class CustomAppBar extends StatelessWidget {

  const CustomAppBar({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.toggleTheme,

  }) : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final VoidCallback toggleTheme;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final repository = GetIt.instance<ThingsRepositoryI>();
    return SliverAppBar(
      pinned: true,
      expandedHeight: screenHeight * 0.21,
      backgroundColor: isDarkMode ? AppColors.blackSand : Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: screenHeight * 0.07,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.03,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.blackSand : Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/IMG_4650(1).png',
                            width: screenWidth * 0.09,
                            height: screenWidth * 0.09,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/100 Things(3).png',
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.04,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        SizedBox(width: 10),
                        // ReusableIconButton(
                        //   icon: Icons.search_rounded,
                        //   onPressed: () {
                        //
                        //     showSearchBottomSheet(context, repository);
                        //   },
                        //   screenWidth: screenWidth,
                        //   borderRadius: 10,
                        // ),

                        SizedBox(width: 4),
                        SizedBox(width: 10),
                        // ReusableIconButton(
                        //   icon: Icons.more_vert,
                        //   onPressed: () {
                        //     Scaffold.of(context).openDrawer();
                        //   },
                        //   screenWidth: screenWidth,
                        //   borderRadius: 10,
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('item')
                      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    int totalQuantity = 0;

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      totalQuantity = snapshot.data!.docs.fold<int>(
                        0,
                            (accumulator, doc) {
                          final quantity = doc['quantity'] as int? ?? 1;
                          return accumulator + quantity;
                        },
                      );
                    }

                    final progress = (totalQuantity / 100).clamp(0.0, 1.0);
                    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.lightviolet,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkTheme ? AppColors.blueSand : AppColors.violetSand,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: progress * (MediaQuery.of(context).size.width * 0.85) - 10,
                          top: -30,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkMode ? AppColors.blueSand : AppColors.violetSand,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? AppColors.blueSand : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.violetSand, width: 4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
