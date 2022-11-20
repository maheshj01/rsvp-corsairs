import 'package:flutter/material.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/widgets/textfield.dart';

class AddEvent extends StatefulWidget {
  bool isEdit;
  AddEvent({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
          ),

          CSField(
            hint: 'Whats the event title?',
            hasLabel: false,
            isTransparent: true,
            maxLines: 1,
            fontSize: 24,
          ),
          _uploadImage(),
          // upload image container
          CSField(
            hint: 'In few lines explain what the event is about',
            hasLabel: false,
            isTransparent: true,
            fontSize: 16,
            maxLines: 4,
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Widget _uploadImage() {
    return Container(
      height: 200,
      margin: 16.0.allPadding,
      decoration: BoxDecoration(
        border: Border.all(color: CorsairsTheme.primaryYellow, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () {},
        child: const Center(
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
    );
  }
}
