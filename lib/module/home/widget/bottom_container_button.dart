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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(180, 46), // Размер кнопки
        backgroundColor: color, // Цвет кнопки
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Закругленные углы
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
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



