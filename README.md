# RSVP_CORSAIRS

This is a demo app I presented at school as part of my course CIS-539 User Interface Design. The app is built using Flutter and Supabase.
The presentation can be found [here](https://docs.google.com/presentation/d/1MnPqcCwWJEdSHxkL5gTBEtmFy3HFS6k3Pviwx6aHq40/edit?usp=sharing)


<img src="https://user-images.githubusercontent.com/31410839/206510853-372fabf0-ba71-4b6a-bb3b-ac9a5e394e39.gif" width="1000"/>

## Screenshots of the app

![Frame](https://user-images.githubusercontent.com/31410839/207100949-337fe7cc-9d99-4152-8507-d0a42f9b0947.png)

### Running the app

1. Clone the repo

2. Run this command to generate the models
```
  flutter pub run build_runner build --delete-conflicting-outputs
```

3. You will need to setup your supabase backend as per the [ER diagram below](./schema.png). Run the below command in step 4 which will generate a sql script for you.

4. Execute the below command to generate the `schema.sql` file (if not already generated)

```
  sh setup.sh
```

5. Use the `schema.sql` file to create the tables and populate data in your supabase project. You can use the Supabase Query editor to do this.

The api keys in this project are managed using [--dart-define](https://dartcode.org/docs/using-dart-define-in-flutter/) flags passed to the flutter run command. You can also use the
```dart
flutter <command> --dart-define=SUPABASE_PROJECT_URL=<your project url here> --dart-define=SUPABASE_API_KEY=<your api key here> --dart-define=SUPABASE_REDIRECT_URL=<your redirect url here>
```

command to run the app from the command line, or If you want to use the launch.json file to run the app, you can copy paste the below configuration to your `.vscode/launch.json` file and pass the keys from the Supabase settings.

```
 {
    "name": "Launch",
    "request": "launch",
    "type": "dart",
    "program": "lib/main.dart",
    "args": [
        "--dart-define=SUPABASE_PROJECT_URL=<your project url here>",
        "--dart-define=SUPABASE_API_KEY=<your api key here>",
        "--dart-define=SUPABASE_REDIRECT_URL=<your redirect url here>"
    ]
  }
```

4. Run the project using the command
```
  flutter run --dart-define=SUPABASE_PROJECT_URL=<your project url here> --dart-define=SUPABASE_API_KEY=<your api key here> --dart-define=SUPABASE_REDIRECT_URL=<your redirect url here>
```

### Build the app

1. Run the command
```
  flutter build apk --dart-define=SUPABASE_PROJECT_URL=<your project url here> --dart-define=SUPABASE_API_KEY=<your api key here> --dart-define=SUPABASE_REDIRECT_URL=<your redirect url here>
```

The apk will be generated in the `build/app/outputs/flutter-apk/app-release.apk` folder.


### Future plans and features to implement see [Todo.md](./todo.md)
