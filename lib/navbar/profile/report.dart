import 'package:flutter/material.dart';
import 'package:rsvp/exports.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/textfield.dart';
import 'package:rsvp/widgets/widgets.dart';

class ReportABug extends StatefulWidget {
  static const String route = '/report';

  const ReportABug({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportABug> createState() => _ReportABugState();
}

class _ReportABugState extends State<ReportABug> {
  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    return ResponsiveBuilder(
        desktopBuilder: (context) => const ReportABugDesktop(),
        mobileBuilder: (context) =>
            user!.isAdmin ? const ViewBugReports() : const ReportABugMobile());
  }
}

class ReportABugDesktop extends StatefulWidget {
  const ReportABugDesktop({Key? key}) : super(key: key);

  @override
  State<ReportABugDesktop> createState() => _ReportABugDesktopState();
}

class _ReportABugDesktopState extends State<ReportABugDesktop> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}

class ViewBugReports extends StatefulWidget {
  const ViewBugReports({Key? key}) : super(key: key);

  @override
  State<ViewBugReports> createState() => _ViewBugReportsState();
}

class _ViewBugReportsState extends State<ViewBugReports> {
  @override
  void dispose() {
    _request.dispose();
    super.dispose();
  }

  Future<void> getReports() async {
    // try {
    //   _request.value =
    //       Request(RequestState.active, message: 'Loading', data: null);
    //   final reports = await ReportService.getReports();
    //   _request.value =
    //       Request(RequestState.done, message: 'Success', data: reports);
    // } catch (e) {
    //   _request.value = Request(RequestState.error, message: e.toString());
    // }
  }

  @override
  void initState() {
    super.initState();
    getReports();
  }

  final ValueNotifier<Response> _request = ValueNotifier(Response.init());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reports and Feedbacks'),
        ),
        body: ValueListenableBuilder<Response>(
            valueListenable: _request,
            builder: (BuildContext context, Response request, Widget? child) {
              if (request.state == RequestState.active) {
                return const LoadingWidget();
              }
              if (request.state == RequestState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          getReports();
                        },
                        child: const Text('Try Again'),
                      ),
                      Text(request.message),
                    ],
                  ),
                );
              }
              List<EventModel> reports = request.data as List<EventModel>;
              if (reports.isEmpty) {
                return const Center(
                  child: Text('No reports yet'),
                );
              }
              return AnimatedList(
                  itemBuilder: (context, index, animation) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(reports[index].name!),
                          subtitle: Text(reports[index].name!),
                          trailing:
                              Text(reports[index].createdAt!.standardDate()),
                          // subtitle: Text(reports[index].feedback * 100),
                        ),
                        Padding(
                          padding: 16.0.horizontalPadding,
                          child: Text(reports[index].name!),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  initialItemCount: (request.data as List).length);
            }));
  }
}

class ReportABugMobile extends StatefulWidget {
  const ReportABugMobile({Key? key}) : super(key: key);

  @override
  State<ReportABugMobile> createState() => _ReportABugMobileState();
}

class _ReportABugMobileState extends State<ReportABugMobile> {
  final ValueNotifier<Response> _request = ValueNotifier(Response.init());

  @override
  void dispose() {
    _request.dispose();
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a bug'),
      ),
      body: ValueListenableBuilder<Response>(
          valueListenable: _request,
          builder: (context, value, snapshot) {
            return Column(
              children: [
                24.0.vSpacer(),
                CSField(
                  hint: 'Description of the bug',
                  hasLabel: false,
                  controller: _controller,
                  maxLines: 8,
                ),
                24.0.vSpacer(),
                CSButton(
                    height: 48,
                    onTap: () async {
                      // _request.value = Request(RequestState.active);
                      // try {
                      //   final report = ReportModel(
                      //       feedback: _controller.text.trim(),
                      //       email: user!.email,
                      //       created_at: DateTime.now(),
                      //       id: Uuid().v4(),
                      //       name: user.name);
                      //   await ReportService.addReport(report);
                      //   _request.value = Request(RequestState.done);
                      //   showMessage(context, 'Thanks for reporting the bug');
                      // } catch (e) {
                      //   _request.value =
                      //       Request(RequestState.error, message: e.toString());
                      //   showMessage(
                      //       context, 'Something went wrong, try agcain');
                      // }
                    },
                    isLoading: _request.value.state == RequestState.active,
                    foregroundColor: Colors.white,
                    backgroundColor: CorsairsTheme.primaryColor,
                    label: 'Submit'),
                Expanded(child: Container()),
                Padding(
                  padding: 16.0.allPadding,
                  child: const Text(
                      'Note: We may contact you for more information about the bug you reported.'),
                ),
                24.0.vSpacer(),
              ],
            );
          }),
    );
  }
}
