import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/widgets/textfield.dart';
import 'package:rsvp/widgets/widgets.dart';

class AddEvent extends StatefulWidget {
  bool isEdit;
  AddEvent({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final ValueNotifier<Event> _eventNotifier = ValueNotifier(Event.init());

  @override
  void dispose() {
    _eventNotifier.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      setState(() {
        coverFile = XFile(croppedFile!.path);
      });
    }
  }

  Future<void> uploadImage() async {
    // SupabaseClient client = SupabaseClient('https://zqjzjzjzjzjz.supabase.co', 'public-anon-key');
    // final String? path = _eventNotifier.value.image;
    // if(path != null){
    //   final String fileName = path.split('/').last;
    //   final String fileExt = fileName.split('.').last;
    //   final String filePath = 'public/$fileName';
    //   final Uint8List fileBytes = File(path).readAsBytesSync();
    //   final StorageUploadOptions options = StorageUploadOptions(
    //     contentType: 'image/$fileExt',
    //     cacheControl: '3600',
    //     upsert: false,
    //   );
    //   final StorageUploadFileResponse response = await client.storage.from('rsvp').uploadFile(filePath, fileBytes, options: options);
    //   if(response.error == null){
    //     _eventNotifier.value = _eventNotifier.value.copyWith(image: response.data!.url);
    //   }
    // }
  }
  XFile? coverFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
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
            onPressed: () {},
            child: const Text(
              'Publish',
              style: TextStyle(
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
              controller: _titleController,
            ),
            _uploadImage(() {
              pickImage();
            }),
            CSField(
              hint: 'In few lines explain what the event is about',
              hasLabel: false,
              isTransparent: true,
              fontSize: 16,
              maxLines: 4,
              controller: _descriptionController,
            ),
            8.0.vSpacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: _subHeading('Event Starts At'),
            ),
            ValueListenableBuilder<Event>(
                valueListenable: _eventNotifier,
                builder: (context, _event, snapshot) {
                  return ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: CorsairsTheme.primaryYellow),
                    onTap: () {
                      final now = DateTime.now();
                      showCSPickerSheet(context, (newDate) {
                        _eventNotifier.value =
                            _event.copyWith(startsAt: newDate, createdAt: now);
                      }, 'Event Starts At', _event.startsAt!);
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
            ValueListenableBuilder<Event>(
                valueListenable: _eventNotifier,
                builder: (context, _event, snapshot) {
                  return ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: CorsairsTheme.primaryYellow),
                    onTap: () {
                      final now = DateTime.now();
                      showCSPickerSheet(context, (newDate) {
                        _eventNotifier.value = _event.copyWith(endsAt: newDate);
                      }, 'Event Ends At', _event.endsAt!);
                    },
                    title: Text(_event.endsAt!.formatDate()),
                    subtitle: Text(_event.endsAt!.standardTime()),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                }),
            CSField(
              hint: 'Where is the event taking place?',
              hasLabel: false,
              isTransparent: true,
              fontSize: 16,
              maxLines: 4,
              controller: _locationController,
            ),
            // TODO INVITE BOTTOM SHEET
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
      height: 200,
      margin: 16.0.allPadding,
      decoration: BoxDecoration(
        border: Border.all(color: CorsairsTheme.primaryYellow, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () => onUpload(),
        child: Center(
          child: coverFile != null
              ? Image.asset(
                  coverFile!.path,
                )
              : const Text(
                  'Upload Image',
                  style: TextStyle(
                    color: CorsairsTheme.primaryYellow,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
