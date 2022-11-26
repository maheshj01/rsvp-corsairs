import 'package:flutter/material.dart';
import 'package:rsvp/exports.dart';
import 'package:rsvp/navbar/profile/about.dart';
import 'package:rsvp/navbar/profile/report.dart';
import 'package:rsvp/pages/authentication/login.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/authentication.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/settings.dart';
import 'package:rsvp/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  static const String route = '/settings';

  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        desktopBuilder: (context) => const SettingsPageDesktop(),
        mobileBuilder: (context) => const SettingsPageMobile());
  }
}

class SettingsPageMobile extends StatefulWidget {
  const SettingsPageMobile({Key? key}) : super(key: key);

  @override
  State<SettingsPageMobile> createState() => _SettingsPageMobileState();
}

class _SettingsPageMobileState extends State<SettingsPageMobile> {
  Widget settingTile(String label, {Function? onTap}) {
    return ListTile(
      minVerticalPadding: 24.0,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          color: CorsairsTheme.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          settingTile(
            'About',
            onTap: () {
              Navigate.push(context, const AboutAppWidget());
            },
          ),
          hLine(),
          // heading('Theme'),
          // const SizedBox(height: 16),
          settingTile(
            'Report a bug',
            onTap: () {
              Navigate.push(context, const ReportABug());
            },
          ),
          hLine(),
          // heading('terms of service'),
          // const SizedBox(height: 16),
          settingTile('Privacy Policy', onTap: () {
            launchUrl(Uri.parse(PRIVACY_POLICY),
                mode: LaunchMode.externalApplication);
          }),
          hLine(),
          settingTile('Contact Us', onTap: () {
            launchUrl(Uri.parse('mailto:$FEEDBACK_EMAIL_TO'),
                mode: LaunchMode.externalApplication);
          }),
          hLine(),
          settingTile('Logout', onTap: () async {
            await Settings.clear();
            await AuthService.updateLogin(
                email: user!.email, isLoggedIn: false);
            Navigate.pushAndPopAll(context, const LoginPage());
          }),
          hLine(),
          const Expanded(child: SizedBox.shrink()),
          const VersionBuilder(),
          60.0.vSpacer()
        ],
      ),
    );
  }
}

class SettingsPageDesktop extends StatefulWidget {
  const SettingsPageDesktop({Key? key}) : super(key: key);

  @override
  State<SettingsPageDesktop> createState() => _SettingsPageDesktopState();
}

class _SettingsPageDesktopState extends State<SettingsPageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}
