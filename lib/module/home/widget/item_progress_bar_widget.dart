import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';

class ItemProgressBar extends StatelessWidget {

  const ItemProgressBar({
    Key? key,
    required this.progress,
  }) : super(key: key);
  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final progressWidth = MediaQuery.of(context).size.width * 0.85;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkTheme ? AppColors.blueSand : Colors.black,
              ),
            ),
          ),
        ),
        Positioned(
          left: progress * progressWidth - 3,
          top: -6,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDarkTheme ? AppColors.blueSand : AppColors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 24,
                height: 23,
                decoration: BoxDecoration(
                  color: isDarkTheme ? AppColors.blueSand : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
