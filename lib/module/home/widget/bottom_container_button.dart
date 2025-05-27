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

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(30),
          backgroundColor: color,

          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(

          ),
        ),


    child: Text(
        textAlign: TextAlign.center,
        text,
        style: const TextStyle(fontSize: 18,color: Colors.black),

      ),
      ),
    );
  }
}

class AddButton extends AbstractButton {
  AddButton({required VoidCallback onPressed})
      : super(
    text: "Добавить",
    color: Colors.white,
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



