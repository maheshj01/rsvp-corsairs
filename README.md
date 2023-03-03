# RSVP_CORSAIRS

This is a demo app I presented at school as part of my course CIS-539 User Interface Design. The app is built using Flutter and Supabase.
The presentation can be found [here](https://docs.google.com/presentation/d/1MnPqcCwWJEdSHxkL5gTBEtmFy3HFS6k3Pviwx6aHq40/edit?usp=sharing)


<img src="https://user-images.githubusercontent.com/31410839/206510853-372fabf0-ba71-4b6a-bb3b-ac9a5e394e39.gif" width="1000"/>

## Screenshots of the app

![Frame](https://user-images.githubusercontent.com/31410839/207100949-337fe7cc-9d99-4152-8507-d0a42f9b0947.png)

### Running the app (The schema has changed and is not compatible with the current code yet)

1. Clone the repo
2. Run this command to generate the models
```
  flutter pub run build_runner build --delete-conflicting-outputs
```

3. You will need to setup your supabase backend as per the ER [diagram below](./er-diagram.png). Run the below command in step 4 which will generate a sql script for you.

4. Execute the below command to generate the `schema.sql` and `utils/secrets.dart` file

```
  sh setup.sh
```

and enter the api key and project url from supabase in secrets.dart.

4. Run the project using the command
```
  flutter run
```

### features to impelement see [Todo.md](./todo.md)