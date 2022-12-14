# RSVP_CORSAIRS


<img src="https://user-images.githubusercontent.com/31410839/206510853-372fabf0-ba71-4b6a-bb3b-ac9a5e394e39.gif" width="1000"/>

## Screenshots of the app

![Frame](https://user-images.githubusercontent.com/31410839/207100949-337fe7cc-9d99-4152-8507-d0a42f9b0947.png)


### Running the app

1. Clone the repo.
2. Run this command to generate the models
```
  flutter pub run build_runner build --delete-conflicting-outputs
```
3. You will require a secrets.dart file to run this project on your local machine. This file is not included in the repo for obvious reasons.You can dm me and I will provide you the command to generate the secrets file
4. Run the project using the command
```
  flutter run
```

_This project was generated using the [flutter_create template](https://github.com/maheshmnj/flutter_create).


### features to impelement

### App
- [ ] Use fonts similar

### Events
- [X] Create a new Event
- [X] Hide navbar bar on scroll
- [X] Add a new Event (Cover image crop)
- [X] View event detail
- [X] Edit an event
- [X] RSVP to an event
- [ ] Improve card UI and Date
- [ ] Bookmark an event
- [ ] View attendees
- [ ] Add filter out expired events
- [ ] Search Events
- [ ] Delete an event
- [ ] Categorize the events (custom categories)
- [ ] Prevent editing of events in last hour
- [ ] Share an event
- [ ] Draft save events for publishing later

### Profile
- [ ] View host/users profile
- [ ] View events attended/hosted and bookmarked

### Leaderboard
- [ ] Create table for leaderboard
- [ ] Allocate points for attending and creating events
- [ ]

### Authentication
- [X] Login and signup seamless
- [X] Login with Google or Username
- [X] Signup with Google or Username
- [ ] Edit user profile

### Game elements

- [ ] Add game elements such as awarding points or medals

### UMD Points
- [ ] Get points for attending events
- [ ] Get points for creating events


Known UX Issues

- [ ] On incorrect password (existing User) we are currently prompting user to signup.
- [ ] No option for forggot password
- [ ] We are storing passwords in a plain text format atleasr we should be using bcrypt or something similar.


### Architecture Scalability Issues
- [ ] Unposted images are being stored in the server
