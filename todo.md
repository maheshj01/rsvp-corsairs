### TODO

### App

- [ ] Use fonts similar to duolingo

### Events
- [X] Create a new Event
- [X] Hide navbar bar on scroll
- [X] Add a new Event (Cover image crop)
- [X] View event detail
- [X] Edit an event
- [X] RSVP to an event
- [X] Improve card UI 
- [X] Bookmark an event
- [X] Unbookmark an event not updated in UI
- [] Event Duration should be shown in days if >24
- [] View attendees
- [] Add filter out expired events
- [] Search Events
- [] Delete an event
- [] Categorize the events (custom categories)
- [] Prevent editing of events in last hour
- [] Share an event
- [] Draft save events for publishing later

### Profile
- [ ] View host/users profile
- [ ] View events attended/hosted and bookmarked
- [ ] Update user profile picture

### Leaderboard
- [] Create table for leaderboard
- [] Allocate points for attending and creating events
- []

### Authentication
[] Login and signup seamless
- [X] Login with Google
- [X] Signup with email
- [X] Edit user profile
- [ ] Existing user error not shown on signup (Already signed in using Google signin sign's up)
- [ ] Update user table with user details on email confirmation
- [ ] Update user table on Google SignIn if not already present
- [ ] For first time GoogleSignIn users, we should prompt them to enter their details along with user avatar (Should be skippable)


### Game elements

- [] Points system.
- [] 

### UMD Points
- [] Get points for attending events
- [] Get points for creating events
- [] Get points for inviting friends
- [] Points to be allocated for public events only


Known UX Issues

- [X] On incorrect password (existing User) we are currently prompting user to signup.
- [] No option for forggot password
- [] We are storing passwords in a plain text format atleasr we should be using bcrypt or something similar.

### Architecture Scalability Issues
- [] Unposted images are being stored in the server