import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

/// shows a snackbar message
void showMessage(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 2),
    bool isRoot = false,
    double bottom = 0,
    void Function()? onPressed,
    void Function()? onClosed}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.white),
          ),
          duration: duration,
          margin: EdgeInsets.only(bottom: bottom),
          action: onPressed == null
              ? null
              : SnackBarAction(
                  label: 'ACTION',
                  onPressed: onPressed,
                ),
        ),
      )
      .closed
      .whenComplete(() => onClosed == null ? null : onClosed());
}

void hideMessage(context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 12.0);
}

void hideToast() {
  Fluttertoast.cancel();
}

/// TODO: Add canLaunch condition back when this issue is fixed https://github.com/flutter/flutter/issues/74557
Future<void> launchURL(String url, {bool isNewTab = true}) async {
  // await canLaunch(url)
  // ?
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? '_blank' : '_self',
  );
  // : throw 'Could not launch $url';
}

String getInitial(String text) {
  if (text.isNotEmpty) {
    if (text.contains(' ')) {
      final list = text.split(' ').toList();
      return list[0].substring(0, 1) + list[1].substring(0, 1);
    } else {
      return text.substring(0, 1);
    }
  } else {
    return 'N/A';
  }
}

double diagonal(Size size) {
  return pow(pow(size.width, 2) + pow(size.width, 2), 0.5) as double;
}

String buildShareMessage(EventModel event) {
  return '''
    Hey Corsairs, I will be attending ${event.name} on ${event.startsAt!.formatDate()}, You can join to by using this link ${event.id};
    ''';
}

// void _openCustomDialog(BuildContext context) {
//   showGeneralDialog(
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionBuilder: (context, a1, a2, widget) {
//         return Transform.translate(
//             offset: Offset(0, 100 * a1.value), child: AddWordForm());
//       },
//       transitionDuration: Duration(milliseconds: 500),
//       barrierDismissible: true,
//       barrierLabel: '',
//       context: context,
//       pageBuilder: (context, animation1, animation2) {
//         return Container();
//       });
// }

Widget _buildNewTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return Transform.translate(
    offset: Offset(0, animation.value * -50),
    child: child,
  );
}

/// Returns a boolean value whether the window is considered medium or large size.
///
/// Used to build adaptive and responsive layouts.
// bool isDisplayDesktop(BuildContext context) =>
//     getWindowType(context) >= AdaptiveWindowType.medium;

// /// Returns boolean value whether the window is considered medium size.
// ///
// /// Used to build adaptive and responsive layouts.
// bool isDisplayMediumDesktop(BuildContext context) {
//   return getWindowType(context) == AdaptiveWindowType.medium;
// }

// bool isDisplaySmallDesktop(BuildContext context) {
//   return getWindowType(context) == AdaptiveWindowType.xsmall;
// }

Future<XFile?> pickImageAndCrop(context) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return XFile(croppedFile!.path);
  } else {
    return null;
  }
}

FormFieldValidator<String> fieldValidator(int field) {
  switch (field) {
    case NAME_VALIDATOR:
      return (String? value) {
        final regexp = RegExp(firstAndLastNamePattern);
        if (value == null || value.isEmpty || !value.contains(regexp)) {
          return 'Please enter a valid first and last name';
        }
        return null;
      };
    case EMAIL_VALIDATOR:
      return (String? value) {
        final regexp = RegExp(emailPattern);
        if (value != null && value.length > 5 && value.contains(regexp)) {
          return null;
        }
        return 'Please enter a valid email address';
      };
    case PASSWORD_VALIDATOR:
      return (String? value) {
        if (value != null && value.length > 7) {
          return null;
        }
        return 'Password must be at least 8 characters long';
      };

    case STUDENT_ID_VALIDATOR:
      return (String? value) {
        final regexp = RegExp(studentIdPattern);
        if (value != null && value.contains(regexp)) {
          return null;
        }
        return 'Please enter a valid Student ID';
      };
    default:
      return (String? value) {
        return null;
      };
  }
}


TextInputType keyboardType(int index){
  switch (index) {
    case NAME_VALIDATOR:
      return TextInputType.name;
    case EMAIL_VALIDATOR:
      return TextInputType.emailAddress;
    case PASSWORD_VALIDATOR:
      return TextInputType.visiblePassword;
    case STUDENT_ID_VALIDATOR:
      return TextInputType.number;
    default:
      return TextInputType.text;
  }
}