import 'package:flutter/material.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';

class VHIcon extends StatelessWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? splashColor;
  final IconData iconData;
  final double size;
  final Function? onTap;
  final BoxBorder? border;
  const VHIcon(this.iconData,
      {Key? key,
      this.size = 32,
      this.backgroundColor,
      this.onTap,
      this.border,
      this.splashColor,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(border: border, shape: BoxShape.circle),
      child: Material(
        color: backgroundColor ?? CorsairsTheme.primaryYellow,
        borderRadius: (size * 2.0).allRadius,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          splashColor: splashColor ?? Theme.of(context).splashColor,
          onTap: () {
            if (onTap != null) {
              onTap!.call();
            }
          },
          child: Icon(
            iconData,
            color: iconColor ?? Colors.white,
            size: size / 2,
          ),
        ),
      ),
    );
  }
}
