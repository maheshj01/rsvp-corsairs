# RSVP_CORSAIRS

This is a demo app I presented at school as part of my course CIS-539 User Interface Design. The app is built using Flutter and Supabase.
The presentation can be found [here](https://docs.google.com/presentation/d/1MnPqcCwWJEdSHxkL5gTBEtmFy3HFS6k3Pviwx6aHq40/edit?usp=sharing)

### Running the app (The schema has changed and is not compatible with the current code yet)

1. Clone the repo
2. Run this command to generate the models
```
  flutter pub run build_runner build --delete-conflicting-outputs
```


3. You will need to setup your own supabase backend as per the ER [diagram below](./er-diagram.png)

You can run the below script which will generate the database and tables for you.

```
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS csevents;
SET search_path = csevents;

-- -----------------------------------------------------
-- Table "csevents"."user"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.user (
  user_id uuid DEFAULT gen_random_uuid(),
  email VARCHAR(45) NULL,
  avatar_url VARCHAR(45) NULL,
  isAdmin BOOLEAN NULL DEFAULT FALSE,
  username VARCHAR(45) NULL,
  created_at TIMESTAMP NULL,
  PRIMARY KEY (user_id)
);


-- -----------------------------------------------------
-- Table "csevents"."events"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.events (
  id uuid DEFAULT gen_random_uuid(),
  created_at TIMESTAMP NULL,
  name VARCHAR(45) NULL,
  description VARCHAR(245) NULL,
  starts_at TIMESTAMP NULL,
  ends_at TIMESTAMP NULL,
  cover_image VARCHAR(45) NULL,
  address VARCHAR(65) NULL,
  private BOOLEAN NULL DEFAULT FALSE,
  deleted BOOLEAN NULL DEFAULT FALSE,
  user_id uuid NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_user_id
    FOREIGN KEY (user_id)
    REFERENCES csevents.user (user_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table "csevents"."attendees"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.attendees (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  event_id uuid NOT NULL,
  user_id uuid NOT NULL,
  created_at TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_attendees_event_id
    FOREIGN KEY (event_id)
    REFERENCES csevents.events (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_attendees_user_id
    FOREIGN KEY (user_id)
    REFERENCES csevents.user (user_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table "csevents"."bookmarks"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.bookmarks (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  created_at TIMESTAMP NOT NULL,
  event_id uuid NULL,
  user_id uuid NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_bookmarks_event_id
    FOREIGN KEY (event_id)
    REFERENCES csevents.events (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_bookmarks_user_id
    FOREIGN KEY (user_id)
    REFERENCES csevents.user (user_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table "csevents"."feedback"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.feedback (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NULL,
  feedback VARCHAR(245) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_feedback_user_id
    FOREIGN KEY (user_id)
    REFERENCES csevents.user (user_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table "csevents"."leaderboard"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.leaderboard (
  user_id uuid NOT NULL,
  reputation INTEGER NULL,
  PRIMARY KEY (user_id),
  CONSTRAINT fk_leaderboard_user_id
    FOREIGN KEY (user_id)
    REFERENCES csevents.user (user_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table "csevents"."tags"
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS csevents.tags (
  tag_id serial NOT NULL,
  tag_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (tag_id)
);

CREATE TABLE IF NOT EXISTS event_tag_map (
  event_id uuid NOT NULL,
  tag_id int NULL,
  map_id uuid NOT NULL,
  PRIMARY KEY (map_id),
  CONSTRAINT fk_event_tag_map_event_id
    FOREIGN KEY (event_id)
    REFERENCES events (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_event_tag_map_tag_id
    FOREIGN KEY (tag_id)
    REFERENCES tags (tag_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS tag_id_idx ON event_tag_map (tag_id);
```

4. Ensure you have a lib/utils/secrets.dart file in your project if not run the below command to generate it

```
echo Y29uc3QgQ09ORklHX1VSTCA9ICc8UHJvamVjdCBVUkw+JzsKY29uc3QgQVBJX0tFWSA9ICc8UHJvamVjdCBBUEktS0VZPic7Cg== | base64 -d > lib/utils/secrets.dart
```
and enter the api key and project url from supabase.

4. Run the project using the command
```
  flutter run
```