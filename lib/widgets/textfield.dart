import 'package:flutter/material.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/utility.dart';

class CSField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isReadOnly;
  final bool hasLabel;
  final int maxLines;
  final int minLines;
  final double fontSize;
  final int? maxLength;
  final Function(String)? onChanged;
  final bool isTransparent;
  final bool hasBorder;
  final bool autoFocus;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final String? Function(String?)? validator;
  const CSField(
      {super.key,
      required this.hint,
      this.controller,
      this.isReadOnly = false,
      this.hasLabel = true,
      this.onChanged,
      this.maxLength,
      this.fontSize = 16,
      this.isTransparent = false,
      this.hasBorder = false,
      this.minLines = 1,
      this.maxLines = 1,
      this.validator,
      this.autovalidateMode,
      this.obscureText = false,
      this.autoFocus = false,
      this.keyboardType = TextInputType.text});

  @override
  State<CSField> createState() => _CSFieldState();
}

class _CSFieldState extends State<CSField> {
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  late TextEditingController _controller;

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !widget.hasLabel
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.hint,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
        Container(
          padding: 16.0.horizontalPadding,
          decoration: BoxDecoration(
            color: widget.isTransparent ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: widget.isTransparent
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
          ),
          child: TextFormField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            readOnly: widget.isReadOnly,
            autofocus: widget.autoFocus,
            obscureText: widget.obscureText,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            onChanged: (x) {
              if (widget.onChanged != null) {
                widget.onChanged!(x);
              }
            },
            cursorColor: CorsairsTheme.primaryYellow,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: widget.fontSize),
            decoration: InputDecoration(
              border: !widget.hasBorder ? InputBorder.none : null,
              focusedBorder: !widget.hasBorder ? InputBorder.none : null,
              enabledBorder: !widget.hasBorder ? InputBorder.none : null,
              hintText: widget.hint,
              counterText: '',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
        if (widget.hasLabel) 6.0.vSpacer()
      ],
    );
  }
}

class TransparentField extends StatefulWidget {
  final int index;
  final String hint;
  final TextEditingController controller;
  final Key? fKey;
  final bool readOnly;
  final Iterable<String>? autoFillHints;
  const TransparentField(
      {super.key,
      this.fKey,
      this.readOnly = false,
      this.autoFillHints,
      required this.index,
      required this.hint,
      required this.controller});

  @override
  State<TransparentField> createState() => _TransparentFieldState();
}

class _TransparentFieldState extends State<TransparentField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 8.0.verticalPadding,
      child: TextFormField(
        key: widget.fKey,
        readOnly: widget.readOnly,
        controller: widget.controller,
        autofillHints: widget.autoFillHints,
        cursorHeight: 32,
        decoration: InputDecoration(
          hintText: widget.hint,
          counterText: '',
        ),
        obscureText: widget.index == Constants.PASSWORD_VALIDATOR,
        obscuringCharacter: obscureCharacter,
        maxLength: widget.index == Constants.STUDENT_ID_VALIDATOR ? 8 : null,
        keyboardType: keyboardType(widget.index),
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: fieldValidator(widget.index),
      ),
    );
  }
}
