# RSVP_CORSAIRS

### Running the app

1. Clone the repo
2. Run this command to generate the models
```
  flutter pub run build_runner build --delete-conflicting-outputs
```


3. You will need to setup your own supabase backend as per the ER [diagram below](./ERDiagram.png) (You can use the [draw.io](https://draw.io) app to view the diagram

 a) Set up a table called events with the following columns
```
  id: uuid(PK)
  title: text
  description: text
  cover_image: text
  start_time: timestamp
  end_time: timestamp
  location: text
  host: uuid
  created_at: timestamp
  updated_at: timestamp
```
b) Set up a table called users with the following columns
```
  id: uuid(PK)
  name: text
  username: text
  email: text
  profile_image: text
  created_at: timestamp
  updated_at: timestamp
```

c) Set up a table called bookmarks with the following columns
```
  id: uuid(PK)
  user_id: uuid
  event_id: uuid
  created_at: timestamp
  updated_at: timestamp
```

d) Set up a table called "rsvp" with the following columns
```
  id: uuid(PK)
  user_id: uuid
  event_id: uuid
  created_at: timestamp
  updated_at: timestamp
```
e) Set up a table called "attendees" with the following columns

```
  id: uuid(PK)
  user_id: uuid
  event_id: uuid
  created_at: timestamp
  updated_at: timestamp
```

4. Run the project using the command
```
  flutter run
```
