import 'package:flutter/material.dart';
import 'package:rsvp/exports.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:url_launcher/link.dart';

class AboutAppWidget extends StatefulWidget {
  static const String route = '/about';

  const AboutAppWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutAppWidget> createState() => _AboutAppWidgetState();
}

class _AboutAppWidgetState extends State<AboutAppWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        desktopBuilder: (context) => const AboutAppWidgetDesktop(),
        mobileBuilder: (context) => const AboutAppWidgetMobile());
  }
}

class AboutAppWidgetDesktop extends StatefulWidget {
  const AboutAppWidgetDesktop({Key? key}) : super(key: key);

  @override
  State<AboutAppWidgetDesktop> createState() => _AboutAppWidgetDesktopState();
}

class _AboutAppWidgetDesktopState extends State<AboutAppWidgetDesktop> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}

class AboutAppWidgetMobile extends StatefulWidget {
  const AboutAppWidgetMobile({Key? key}) : super(key: key);

  @override
  State<AboutAppWidgetMobile> createState() => _AboutAppWidgetMobileState();
}

class _AboutAppWidgetMobileState extends State<AboutAppWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: 16.0.allPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// about the app
            const Text(
              ABOUT_TEXT,
            ),
            16.0.vSpacer(),
            // open source repo link
            16.0.vSpacer(),
            const Expanded(child: SizedBox.shrink()),
            Center(
              child: Link(
                  uri: Uri.parse(SOURCE_CODE_URL),
                  target: LinkTarget.blank,
                  builder: (context, followLink) {
                    return TextButton(
                      onPressed: followLink,
                      child: const Text(
                        'View source code',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
            ),
            24.0.vSpacer(),
          ],
        ),
      ),
    );
  }
}
