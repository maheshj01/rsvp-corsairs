import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';
import 'package:uuid/uuid.dart';

/// app string constants  from the UI go here in this page
/// e.g
const String GITHUB_ASSET_PATH = 'assets/images/github.png';
const String GITHUB_WHITE_ASSET_PATH = 'assets/images/github_white.png';
const String GOOGLE_ASSET_PATH = 'assets/images/google.png';
const String ARNIE_ASSET_PATH = 'assets/images/arnie.jpg';
const String SPLASH_PATH = 'assets/images/arnie_splash.png';

const String FORCE_UPDATE_MESSAGE = 'Please update your app to continue';
const String UPDATE_APP_MESSAGE = 'New version available. Update now?';

const String signInFailure = 'failed to sign in User, please try again later';

const String ABOUT_TEXT =
    "RSVP Corsairs is a event tracking app, specially built for Umass Corsairs to track their events and RSVP for them. It is built using Flutter and Supabase. It is open source and you can contribute to it on Github. You Can also help us improve the app by reporting bugs and suggesting features under the app settings.";

const String urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';

List<EventModel> sample_events = [
  EventModel(
    id: const Uuid().v4(),
    name: 'Mount Rushmore',
    description: 'U.S.A',
    endsAt: DateTime.now().add(const Duration(days: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [],
    createdAt: DateTime.now(),
    coverImage: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  EventModel(
    id: const Uuid().v4(),
    name: 'Gardens By The Bay',
    description:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
    endsAt: DateTime.now().add(const Duration(minutes: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [
      UserModel(
        name: 'John Doe',
        email: "jsa@hotmail.com",
        avatarUrl: '$urlPrefix/01-mount-rushmore.jpg',
      )
    ],
    createdAt: DateTime.now(),
    address: '18 Marina Gardens Drive, Singapore 018953',
    coverImage: '$urlPrefix/02-singapore.jpg',
  ),
  EventModel(
    id: const Uuid().v4(),
    name: 'Machu Picchu',
    description: 'Peru',
    address: 'Machu Picchu, Peru',
    endsAt: DateTime.now().add(const Duration(days: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [],
    createdAt: DateTime.now(),
    coverImage: '$urlPrefix/03-machu-picchu.jpg',
  ),
  EventModel(
    name: 'Vitznau',
    description: 'Switzerland',
    endsAt: DateTime.now().add(const Duration(minutes: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [],
    createdAt: DateTime.now(),
    coverImage: '$urlPrefix/04-vitznau.jpg',
  ),
  EventModel(
    id: const Uuid().v4(),
    name: 'Bali',
    description: 'Indonesia',
    endsAt: DateTime.now().add(const Duration(minutes: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [],
    createdAt: DateTime.now(),
    coverImage: '$urlPrefix/05-bali.jpg',
  ),
  EventModel(
    id: const Uuid().v4(),
    name: 'Mexico City',
    description: 'Mexico',
    endsAt: DateTime.now().add(const Duration(minutes: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [],
    createdAt: DateTime.now(),
    coverImage: '$urlPrefix/06-mexico-city.jpg',
  ),
  EventModel(
    id: const Uuid().v4(),
    name: 'Cairo',
    description: 'Egypt',
    endsAt: DateTime.now().add(const Duration(minutes: 1)),
    host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
    startsAt: DateTime.now(),
    attendees: [],
    createdAt: DateTime.now(),
    coverImage: '$urlPrefix/07-cairo.jpg',
  ),
];

const String obscureCharacter = '◦';
