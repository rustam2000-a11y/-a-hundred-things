import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';
import '../../utils/base_text_field.dart';

enum TextFieldType { password, email, none }

abstract class TextFieldCustom extends StatefulWidget {
  const TextFieldCustom({
    Key? key,
    required this.fieldType,
    this.onChanged,
    this.controller,
    this.label,
    this.keyBoardType,
    this.isPasswordTextfield = false,
    this.isDeleteWhiteSpace = false,
    this.autoFillHints,
    this.autoFocus = false,
    this.errorText,
    this.autocorrect = true,
    this.onTapComplete,
    this.textCapitalization = TextCapitalization.sentences,
    required this.primaryColor,
    this.suffixIcon,
    this.prefix,
    this.focusNode,
    this.scrollPadding,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? label;
  final TextInputType? keyBoardType;
  final bool isPasswordTextfield;
  final List<String>? autoFillHints;
  final bool autoFocus;
  final bool isDeleteWhiteSpace;
  final VoidCallback? onTapComplete;
  final void Function(String)? onChanged;
  final String? errorText;
  final IconButton? suffixIcon;
  final TextFieldType fieldType;
  final Color primaryColor;
  final TextCapitalization textCapitalization;
  final Widget? prefix;
  final FocusNode? focusNode;
  final EdgeInsets? scrollPadding;
  final bool autocorrect;

  @override
  State<TextFieldCustom> createState() => _TextWidget();
}

class _TextWidget extends State<TextFieldCustom> {
  late bool isObscureText;

  bool hasFocus = false;

  Color get getLabelColor {
    if (widget.errorText != null) return Colors.red;

    if (hasFocus) return widget.primaryColor;

    return Colors.grey;
  }

  @override
  void initState() {
    isObscureText = widget.isPasswordTextfield;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          this.hasFocus = hasFocus;
        });
      },
      child: BaseTextField(
        autocorrect: widget.autocorrect,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onTapComplete,
        scrollPadding: widget.scrollPadding,
        inputFormatters: [
          if (widget.isDeleteWhiteSpace)
            FilteringTextInputFormatter(RegExp('[\\ ]'), allow: false),
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        textCapitalization: widget.textCapitalization,
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus,
        autoFillHints: widget.autoFillHints,
        autovalidateMode: AutovalidateMode.always,
        cursorColor: widget.primaryColor,
        controller: widget.controller,
        keyboardType: widget.keyBoardType,
        isObscured: isObscureText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        decoration: InputDecoration(
          errorText: widget.errorText,
          border: const OutlineInputBorder(),
          focusColor: Colors.grey,
          labelText: getLabelText,
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
          labelStyle: TextStyle(fontSize: 14, color: getLabelColor),
          errorStyle: const TextStyle(
            fontSize: 11,
            color: Colors.red,
          ),
          suffixIcon: widget.isPasswordTextfield
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                  icon: Icon(
                    isObscureText
                        ? Icons.remove_red_eye_sharp
                        : Icons.hide_source,
                    size: 17,
                  ))
              : null,
          suffixIconColor: Colors.grey,
          suffixIconConstraints: BoxConstraints(minWidth: 55),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: widget.primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red)),
          prefix: widget.prefix,
        ),
        textSelectionColor: widget.primaryColor,
      ),
    );
  }

  String get getLabelText {
    if (widget.label != null) return widget.label!;

    if (widget.fieldType == TextFieldType.email) {
      return S.of(context).email;
    }

    if (widget.fieldType == TextFieldType.password) {
      return S.of(context).password;
    }

    return '';
  }
}

class TextFieldPasswordWidget extends TextFieldCustom {
  const TextFieldPasswordWidget({
    super.key,
    String? errorText,
    required void Function(String)? onChanged,
    TextEditingController? controller,
    required Color primaryColor,
    String? labelText,
    EdgeInsets? scrollPadding,
  }) : super(
          isPasswordTextfield: true,
          controller: controller,
          autocorrect: false,
          fieldType: TextFieldType.password,
          keyBoardType: TextInputType.visiblePassword,
          autoFillHints: const [AutofillHints.password],
          errorText: errorText,
          label: labelText,
          primaryColor: primaryColor,
          textCapitalization: TextCapitalization.none,
          onChanged: onChanged,
          scrollPadding: scrollPadding,

        );
}

class TextFieldEmailWidget extends TextFieldCustom {
  const TextFieldEmailWidget({
    super.key,
    required String? errorText,
    required void Function(String)? onChanged,
    required Color primaryColor,
    void Function()? onTapComplete,
    TextEditingController? controller,
  }) : super(
          isPasswordTextfield: false,
          fieldType: TextFieldType.email,
          autocorrect: false,
          keyBoardType: TextInputType.emailAddress,
          autoFillHints: const [AutofillHints.email],
          isDeleteWhiteSpace: true,
          errorText: errorText,
          onChanged: onChanged,
          primaryColor: primaryColor,
          textCapitalization: TextCapitalization.none,
          onTapComplete: onTapComplete,
          controller: controller,
        );
}
