import 'package:flutter/material.dart';
import 'package:rsvp/utils/extensions.dart';

class CSButton extends StatefulWidget {
  const CSButton(
      {Key? key,
      this.backgroundColor,
      this.foregroundColor = Colors.black,
      this.onTap,
      required this.label,
      this.height = 55.0,
      this.width,
      this.fontSize,
      this.isLoading = false,
      this.leading})
      : super(key: key);

  final void Function()? onTap;

  /// label on the button
  final String label;

  final Widget? leading;

  final Color? backgroundColor;

  final Color foregroundColor;

  final double height;

  final double? fontSize;

  final double? width;
  final bool isLoading;

  @override
  _CSButtonState createState() => _CSButtonState();
}

class _CSButtonState extends State<CSButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          disabledBackgroundColor: const Color.fromARGB(255, 138, 116, 77),
          side: const BorderSide(color: Colors.white),
          minimumSize: Size(widget.width ?? 120, widget.height),
          maximumSize: Size(widget.width ?? 120, widget.height),
          foregroundColor: widget.foregroundColor,
          backgroundColor: widget.backgroundColor),
      onPressed:
          widget.isLoading || (widget.onTap == null) ? null : widget.onTap,
      child: widget.isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.foregroundColor),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.leading ?? const SizedBox.shrink(),
                (widget.leading == null ? 0.0 : 20.0).hSpacer(),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.fontSize,
                      color: widget.foregroundColor),
                ),
              ],
            ),
    );
  }
}
