import 'package:flutter/material.dart';
import 'package:rsvp/exports.dart';
import 'package:rsvp/models/report.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/services/report_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/textfield.dart';
import 'package:rsvp/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

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
        mobileBuilder: (context) => const ReportABugMobile());
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
    _responseNotifier.dispose();
    super.dispose();
  }

  Future<void> getReports() async {
    try {
      _responseNotifier.value = _responseNotifier.value
          .copyWith(state: RequestState.active, message: 'Loading', data: null);
      final reports = await ReportService.getReports();
      _responseNotifier.value = _responseNotifier.value.copyWith(
          state: RequestState.done, message: 'Success', data: reports);
    } catch (e) {
      _responseNotifier.value = _responseNotifier.value
          .copyWith(state: RequestState.error, message: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getReports();
  }

  final ValueNotifier<Response> _responseNotifier =
      ValueNotifier(Response.init());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reports and Feedbacks'),
        ),
        body: ValueListenableBuilder<Response>(
            valueListenable: _responseNotifier,
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
              List<ReportModel> reports = request.data as List<ReportModel>;
              if (reports.isEmpty) {
                return const Center(
                  child: Text('No reports yet'),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: AnimatedList(
                        itemBuilder: (context, index, animation) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionTile(
                                subtitle: Text(reports[index]
                                        .createdAt
                                        .standardDate() +
                                    ' ' +
                                    reports[index].createdAt.standardTime()),
                                title: Text(reports[index].user.name),
                                children: [
                                  Padding(
                                    padding: 16.0.allPadding,
                                    child: Text(reports[index].description,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87)),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        initialItemCount: (request.data as List).length),
                  ),
                  24.0.vSpacer()
                ],
              );
            }));
  }
}

class ReportABugMobile extends StatefulWidget {
  const ReportABugMobile({Key? key}) : super(key: key);

  @override
  State<ReportABugMobile> createState() => _ReportABugMobileState();
}

class _ReportABugMobileState extends State<ReportABugMobile> {
  final ValueNotifier<Response> _responseNotifier =
      ValueNotifier(Response.init());

  @override
  void dispose() {
    _responseNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Report a bug'),
      ),
      body: ValueListenableBuilder<Response>(
          valueListenable: _responseNotifier,
          builder: (context, value, snapshot) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      24.0.vSpacer(),
                      Padding(
                        padding: 16.0.horizontalPadding,
                        child: CSField(
                          hint: 'Description of the bug',
                          hasLabel: false,
                          controller: _controller,
                          maxLines: 12,
                          minLines: 5,
                        ),
                      ),
                      24.0.vSpacer(),
                      Padding(
                        padding: 16.0.horizontalPadding,
                        child: CSButton(
                            height: 48,
                            onTap: () async {
                              removeFocus(context);
                              _responseNotifier.value = _responseNotifier.value
                                  .copyWith(
                                      state: RequestState.active,
                                      message: 'Sending report');
                              try {
                                final report = ReportModel(
                                    id: const Uuid().v4(),
                                    description: _controller.text.trim(),
                                    createdAt: DateTime.now().toUtc(),
                                    user: user!);
                                final resp =
                                    await ReportService.addReport(report);
                                if (resp.status == 201) {
                                  _responseNotifier.value =
                                      _responseNotifier.value.copyWith(
                                          state: RequestState.done,
                                          message: 'Report sent successfully');
                                  _responseNotifier.value = _responseNotifier
                                      .value
                                      .copyWith(state: RequestState.done);
                                  showMessage(
                                      context, 'Thanks for reporting the bug');
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  Navigator.pop(context);
                                } else {
                                  _responseNotifier.value =
                                      _responseNotifier.value.copyWith(
                                          state: RequestState.done,
                                          message: 'Error sending report');
                                  showMessage(context,
                                      'Error sending report! Try again');
                                }
                              } catch (e) {
                                _responseNotifier.value =
                                    _responseNotifier.value.copyWith(
                                        state: RequestState.done,
                                        message: 'Error sending report');
                                showMessage(context,
                                    'Something went wrong, try agcain');
                              }
                            },
                            isLoading: _responseNotifier.value.state ==
                                RequestState.active,
                            foregroundColor: Colors.white,
                            backgroundColor: CorsairsTheme.primaryYellow,
                            label: 'Submit'),
                      ),
                    ],
                  ),
                ),
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
