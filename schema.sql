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
  max_capacity int NULL DEFAULT 50,
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
  map_id uuid DEFAULT gen_random_uuid(),
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