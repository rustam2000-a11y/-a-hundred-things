import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';

abstract class AbstractButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const AbstractButton({
    required this.text,
    required this.color,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenWidth * 0.45 , 46), // 30% ширины экрана
        backgroundColor: color, // Цвет кнопки
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Закругленные углы
        ),
      ),
      child: Text(
        textAlign: TextAlign.center,
        text,
        style: const TextStyle(fontSize: 18,color: Colors.white),

      ),
    );
  }
}

class AddButton extends AbstractButton {
  AddButton({required VoidCallback onPressed})
      : super(
    text: "Добавить",
    color: AppColors.orangeSand,
    onPressed: onPressed,
  );
}

class CancelButton extends AbstractButton {
  CancelButton({required VoidCallback onPressed})
      : super(
    text: "Отмена",
    color: AppColors.violetSand,
    onPressed: onPressed,
  );
}

class SaveButton extends AbstractButton {
  SaveButton({required VoidCallback onPressed})
      : super(
    text: "Сохраниь",
    color: AppColors.orangeSand,
    onPressed: onPressed,
  );
}



