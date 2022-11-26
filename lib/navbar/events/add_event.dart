import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/widgets/textfield.dart';
import 'package:rsvp/widgets/widgets.dart';

class AddEvent extends StatefulWidget {
  bool isEdit;
  EventModel? event;
  VoidCallback? onDone;
  AddEvent({Key? key, this.isEdit = false, this.event, this.onDone})
      : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final ValueNotifier<EventModel> _eventNotifier =
      ValueNotifier(EventModel.init());

  @override
  void dispose() {
    _eventNotifier.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? file = await pickImageAndCrop(context);
    if (file != null) {
      setState(() {
        coverFile = XFile(file.path);
      });
      await uploadImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImage() async {
    try {
      showCircularIndicator(context);
      File imageFile = File(coverFile!.path);
      final resp = await DatabaseService.uploadImage(imageFile);
      if (resp.didSucced) {
        imageUploadSuccess = true;
        _eventNotifier.value =
            _eventNotifier.value.copyWith(coverImage: resp.data as String);
        showMessage(context, 'Image uploaded successfully');
        stopCircularIndicator(context);
      } else {
        imageUploadSuccess = false;
        showMessage(context, resp.message);
        _eventNotifier.value = _eventNotifier.value.copyWith(coverImage: '');
        stopCircularIndicator(context);
      }
    } catch (e) {
      imageUploadSuccess = false;
      showMessage(context, e.toString());
      _eventNotifier.value = _eventNotifier.value.copyWith(coverImage: '');
      stopCircularIndicator(context);
    }
  }

  Future<void> _publishPost() async {
    showCircularIndicator(context);
    final EventModel _event = _eventNotifier.value;
    if (_event.name!.isEmpty) {
      showMessage(context, 'Title cannot be empty');
      stopCircularIndicator(context);
      return;
    }
    if (_event.description!.isEmpty) {
      showMessage(context, 'Description cannot be empty');
      stopCircularIndicator(context);
      return;
    }
    if (_event.description!.split(' ').toList().length < 10) {
      showMessage(context, 'Description should be at least 10 words long.');
      stopCircularIndicator(context);
      return;
    }
    if (_event.startsAt!.isAfter(_event.endsAt!)) {
      showMessage(context, 'Start date cannot be after end date.');
      stopCircularIndicator(context);
      return;
    }
    if (_event.address!.isEmpty) {
      showMessage(context, 'Location cannot be empty');
      stopCircularIndicator(context);
      return;
    }
    if (_event.coverImage!.isEmpty) {
      showMessage(context, 'Cover image cannot be empty');
      stopCircularIndicator(context);
      return;
    }
    final eventModel = Event.fromEventModel(_event);
    final resp = await EventService.addEvent(eventModel);
    if (resp.didSucced) {
      showMessage(context, 'Event added successfully');
      stopCircularIndicator(context);
      await Future.delayed(const Duration(seconds: 3), () {
        widget.onDone!();
        Navigator.pop(context);
      });
    } else {
      showMessage(context, resp.message);
      stopCircularIndicator(context);
    }
  }

  bool imageUploadSuccess = true;
  XFile? coverFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _eventNotifier.value = widget.event!;
      _titleController.text = widget.event!.name!;
      _descriptionController.text = widget.event!.description!;
      _locationController.text = widget.event!.address!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _subHeading(String title) {
      return Padding(
        padding: 16.0.horizontalPadding,
        child: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.isEdit ? 'Edit Event' : 'Add Event'),
        actions: [
          // post button
          TextButton(
            onPressed: _publishPost,
            child: Text(
              widget.isEdit ? 'Update' : 'Publish',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: CorsairsTheme.primaryYellow),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.red,
            ),
            CSField(
              hint: 'Whats the event title?',
              hasLabel: false,
              isTransparent: true,
              maxLines: 2,
              autoFocus: true,
              fontSize: 24,
              onChanged: (x) {
                _eventNotifier.value = _eventNotifier.value.copyWith(name: x);
              },
              controller: _titleController,
            ),
            _uploadImage(() {
              pickImage();
            }),
            ValueListenableBuilder<EventModel>(
                valueListenable: _eventNotifier,
                builder: (context, _event, snapshot) {
                  if (!imageUploadSuccess) {
                    return Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: uploadImage,
                            child: const Text(
                              'Retry Upload',
                              style: TextStyle(color: Colors.red),
                            )));
                  } else {
                    return const SizedBox();
                  }
                }),
            CSField(
              hint: 'In few lines explain what the event is about',
              hasLabel: false,
              isTransparent: true,
              fontSize: 16,
              maxLines: 4,
              onChanged: (x) {
                _eventNotifier.value =
                    _eventNotifier.value.copyWith(description: x);
              },
              controller: _descriptionController,
            ),
            8.0.vSpacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: _subHeading('Event Starts At'),
            ),
            ValueListenableBuilder<EventModel>(
                valueListenable: _eventNotifier,
                builder: (context, _event, snapshot) {
                  return ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: CorsairsTheme.primaryYellow),
                    onTap: () {
                      final now = DateTime.now();
                      showCSPickerSheet(
                          context,
                          (newDate) {
                            _eventNotifier.value = _event.copyWith(
                                startsAt: newDate, createdAt: now);
                          },
                          'Event Starts At',
                          _event.startsAt!,
                          onClosed: () {
                            print('closed');
                          });
                    },
                    title: Text(_event.startsAt!.formatDate()),
                    subtitle: Text(_event.startsAt!.standardTime()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                }),
            Align(
              alignment: Alignment.centerLeft,
              child: _subHeading('Event Ends At'),
            ),
            ValueListenableBuilder<EventModel>(
                valueListenable: _eventNotifier,
                builder: (context, _event, snapshot) {
                  return ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: CorsairsTheme.primaryYellow),
                    onTap: () {
                      showCSPickerSheet(
                        context,
                        (newDate) {
                          _eventNotifier.value =
                              _event.copyWith(endsAt: newDate);
                        },
                        'Event Ends At',
                        _event.endsAt!,
                      );
                    },
                    title: Text(_event.endsAt!.formatDate()),
                    subtitle: Text(_event.endsAt!.standardTime()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                }),
            8.0.vSpacer(),
            CSField(
              hint: 'Where is the event taking place?',
              hasLabel: false,
              isTransparent: true,
              fontSize: 16,
              maxLines: 4,
              controller: _locationController,
              onChanged: (x) {
                _eventNotifier.value =
                    _eventNotifier.value.copyWith(address: x);
              },
            ),
            8.0.vSpacer(),
            ValueListenableBuilder<EventModel>(
                valueListenable: _eventNotifier,
                builder: (context, _event, snapshot) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock,
                            color: CorsairsTheme.primaryYellow),
                        title: const Text('Private Event'),
                        subtitle: const Text(
                            'Only invited members can see this event'),
                        trailing: CupertinoSwitch(
                          value: _event.private!,
                          onChanged: (x) {
                            _eventNotifier.value = _event.copyWith(private: x);
                          },
                        ),
                      ),
                      !_event.private!
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: _subHeading('Invite'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person_add,
                                      color: CorsairsTheme.primaryYellow),
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: false,
                                        elevation: 2.0,
                                        useRootNavigator: false,
                                        shape: 16.0.rounded,
                                        builder: (context) =>
                                            const InviteSheet());
                                  },
                                  title: const Text('Invite Friends'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            )
                    ],
                  );
                }),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadImage(Function onUpload) {
    return Container(
      margin: 16.0.allPadding,
      decoration: BoxDecoration(
        border: Border.all(color: CorsairsTheme.primaryYellow, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () => onUpload(),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: widget.isEdit
              ? Image.network(
                  widget.event!.coverImage!,
                )
              : coverFile != null
                  ? Image.file(
                      File(
                        coverFile!.path,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Upload Image',
                        style: TextStyle(
                          color: CorsairsTheme.primaryYellow,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}

class InviteSheet extends StatefulWidget {
  const InviteSheet({Key? key}) : super(key: key);

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 16.0.horizontalPadding,
      child: ListView(
        children: [
          16.0.vSpacer(),
          const Text(
            'Invite Friends',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          16.0.vSpacer(),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 200),
            child: CSField(
              maxLines: 1,
              hint: 'Search for friends',
              hasLabel: false,
              isTransparent: false,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
