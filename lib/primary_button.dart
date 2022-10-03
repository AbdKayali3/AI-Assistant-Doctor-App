import 'package:flutter/material.dart';
import 'package:maching_learning/fading_loading_indicator.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.text,
    this.onPressed,
    this.backgroundColor,
    this.hasFullWidth = true,
    this.textColor = Colors.white,
    this.borderRadius,
    this.showLoader = false,
    this.child,
    this.isDense = false,
  }) : super(key: key);

  /// Text of type String is required for this widget to display the text of the button
  final String? text;

  /// A VoidCallback function to identify the functionality of the button. can be either null or () {}
  final VoidCallback? onPressed;

  /// to force custom background color
  final Color? backgroundColor;
  final Color? textColor;
  final bool hasFullWidth;
  final double? borderRadius;
  final bool showLoader;
  final bool isDense;

  /// this title if we want to add a widget rather than text ex: row(children:[icon,text])
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    if (showLoader) {
      return SizedBox(
        width: hasFullWidth ? double.infinity : null,
        height: 56,
        child: Stack(
          fit: hasFullWidth ? StackFit.expand : StackFit.loose,
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50, maxHeight: 50),
                child: _getButton(),
              ),
            ),
            Positioned(
              left: hasFullWidth ? 20 : 10,
              child: const FadingLoadingIndicator(),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: hasFullWidth ? double.infinity : null,
        height: 56,
        child: _getButton(),
      );
    }
  }

  ElevatedButton _getButton() {
    Widget child;
    if (text != null) {
      child = Text(
        isDense ? text! : text!.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: onPressed == null ? textColor?.withOpacity(0.2) : textColor,
          fontWeight: FontWeight.w500,
          fontSize: isDense ? 12 : 16,
          letterSpacing: 1,
        ),
      );
    } else {
      child = this.child!;
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.white30),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return (backgroundColor ?? Colors.purple).withOpacity(0.2);
          } else {
            return (backgroundColor ?? Colors.purple);
          }
        }),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4))),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      child: hasFullWidth
          ? child
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: child),
    );
  }
}
