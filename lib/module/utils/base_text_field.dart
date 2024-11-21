import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../presentation/colors.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    Key? key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.cursorColor,
    this.decoration = const InputDecoration(),
    this.autofocus = false,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.onEditingComplete,
    this.style,
    this.inputFormatters,
    this.textInputAction,
    this.initialValue,
    this.textCapitalization = TextCapitalization.sentences,
    this.enabled,
    this.cursorWidth = 2.0,
    this.focusNode,
    this.readOnly = false,
    this.autocorrect = true,
    this.isObscured,
    this.onTap,
    this.validator,
    this.autoFillHints,
    this.scrollPadding,
    this.autovalidateMode,
    required this.textSelectionColor,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final InputDecoration decoration;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool readOnly;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final double cursorWidth;
  final bool? isObscured;
  final Color textSelectionColor;
  final String? Function(String?)? validator;
  final List<String>? autoFillHints;
  final AutovalidateMode? autovalidateMode;
  final EdgeInsets? scrollPadding;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: const TextSelectionThemeData(
        selectionColor: Colors.grey,
      ),
      child: TextFormField(
        autocorrect: autocorrect,
        scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
        onTap: onTap,
        autovalidateMode: autovalidateMode,
        autofillHints: autoFillHints,
        validator: validator,
        selectionControls:
            kIsWeb ? null : CustomColorSelectionHandle(textSelectionColor),
        obscureText: isObscured ?? false,
        textCapitalization: textCapitalization,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: cursorColor,
        decoration: decoration,
        initialValue: initialValue,
        autofocus: autofocus,
        onChanged: onChanged,
        readOnly: readOnly,
        cursorWidth: cursorWidth,
        style: style,
        maxLines: maxLines,
        focusNode: focusNode,
        minLines: minLines,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}

class CustomColorSelectionHandle extends TextSelectionControls {
  CustomColorSelectionHandle(this.handleColor)
      : _controls = Platform.isIOS
            ? cupertinoTextSelectionControls
            : materialTextSelectionControls;

  final Color handleColor;
  final TextSelectionControls _controls;

  Widget _wrapWithThemeData(
          Widget Function(BuildContext) builder) =>
      Platform.isIOS
          ? CupertinoTheme(
              data: CupertinoThemeData(primaryColor: handleColor),
              child: Builder(builder: builder))
          : TextSelectionTheme(
              data: TextSelectionThemeData(selectionHandleColor: handleColor),
              child: Builder(builder: builder));

  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap]) {
    return _wrapWithThemeData((BuildContext context) =>
        _controls.buildHandle(context, type, textLineHeight));
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return _controls.getHandleAnchor(type, textLineHeight);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return _controls.getHandleSize(textLineHeight);
  }

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset selectionMidpoint,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) =>
      _controls.buildToolbar(
          context,
          globalEditableRegion,
          textLineHeight,
          selectionMidpoint,
          endpoints,
          delegate,
          clipboardStatus,
          lastSecondaryTapDownPosition);

  TextSelectionControls get getCon {
    return cupertinoDesktopTextSelectionHandleControls;
    /*   switch (theme.platform) {
      case TargetPlatform.iOS:
        return cupertinoTextSelectionHandleControls;

      case TargetPlatform.macOS:
        return cupertinoDesktopTextSelectionHandleControls;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return materialTextSelectionHandleControls;

      case TargetPlatform.linux:
        return desktopTextSelectionHandleControls;

      case TargetPlatform.windows:
        return desktopTextSelectionHandleControls;

      default:
        return cupertinoDesktopTextSelectionHandleControls;
    } */
  }
}
