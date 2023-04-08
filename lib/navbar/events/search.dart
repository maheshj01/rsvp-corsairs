import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/navbar/events/event_detail.dart';
import 'package:rsvp/navbar/pageroute.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';

class EventsSearch extends StatefulWidget {
  const EventsSearch({super.key});

  @override
  State<EventsSearch> createState() => _EventsSearchState();
}

class _EventsSearchState extends State<EventsSearch> {
  Future<void> searchEvents(String query) async {
    List<EventModel> events = [];
    if (query.isEmpty) {
      events = await EventService.getAllEvents(context);
    } else {
      events = await EventService.searchEvents(query);
    }
    _responseNotifier.value = _responseNotifier.value
        .copyWith(data: events, state: RequestState.done);
  }

  final ValueNotifier<Response> _responseNotifier =
      ValueNotifier<Response>(Response.init());
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _responseNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchEvents('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.2,
        // backgroundColor: Colors.transparent,
        // elevation: 0.0,
        title: Row(
          children: [
            // const BackButton(),
            Expanded(
              child: TextFormField(
                controller: _searchController,
                cursorColor: CorsairsTheme.primaryYellow,
                onChanged: (x) {
                  searchEvents(x);
                },
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  suffixIcon: Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ValueListenableBuilder<Response>(
          valueListenable: _responseNotifier,
          builder: (BuildContext context, Response response, child) {
            // if (response.data == null) {}
            if (response.state == RequestState.active ||
                response.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (response.state == RequestState.error) {
              return Center(
                child: Column(
                  children: [
                    Text(response.message),
                    ElevatedButton(
                      onPressed: () {
                        searchEvents(_searchController.text);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final results = response.data as List<EventModel>;
            return Material(
              elevation: 5.0,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.network(
                          results[index].coverImage!,
                          height: 50,
                          width: 50,
                        ),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(PageRoutes.sharedAxis(
                                  EventDetail(
                                    event: results[index],
                                  ),
                                  SharedAxisTransitionType.horizontal));
                        },
                        title: Text(results[index].name!),
                        subtitle: Text(
                          results[index].description!,
                          maxLines: 2,
                        ),
                      ),
                      const Divider(
                        height: 1,
                      ),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
