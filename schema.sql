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


-- Populate the data

  INSERT INTO csevents.user (user_id, email, avatar_url, isAdmin, username, created_at)
  VALUES
  ('38d61eba-45ef-460a-b9d3-ccdbaf7a4187', 'johnsmith@example.com','http://example.com/avatar1.jpg', TRUE, 'johnsmith', NOW()),
  ('5c6cb802-0834-46e1-ae1b-396c3cbc75c8', 'janedoe@example.com', 'http://example.com/avatar2.jpg', FALSE, 'janedoe', NOW()),
  ('8c6b30f8-ac41-4ad0-be1b-3da9e36eb3cb' , 'davidsanchez@example.com', 'http://example.com/avatar3.jpg', FALSE, 'davidsanchez', NOW()),
  ('200749c8-09b3-441a-8991-bad9881f3869', 'mariaperez@example.com', 'http://example.com/avatar4.jpg', FALSE, 'mariaperez', NOW()),
  ('1e5de463-efd5-442e-be3f-31c937c75d3a', 'markjohnson@example.com', 'http://example.com/avatar5.jpg', FALSE, 'markjohnson', NOW()),
  ('b5736b66-921a-481d-a50f-fc574af39f6a', 'sarahlee@example.com', 'http://example.com/avatar6.jpg', FALSE, 'sarahlee', NOW()),
  ('db6f8bb4-474d-4301-9bc9-1845b6758f45', 'brianharris@example.com', 'http://example.com/avatar7.jpg', FALSE, 'brianharris', NOW()),
  ('eaea22f1-a287-4f25-b271-47986b089da4', 'jessicawang@example.com', 'http://example.com/avatar8.jpg', FALSE, 'jessicawang', NOW()),
  ('457d3c28-57ba-44bf-9bba-2c844b2a0c4c', 'andrewnguyen@example.com', 'http://example.com/avatar9.jpg', FALSE, 'andrewnguyen', NOW()),
  ('9cb9323a-7235-499c-996a-8a989558d292', 'emilytaylor@example.com', 'http://example.com/avatar10.jpg', FALSE, 'emilytaylor', NOW()),
  ('8d394aa9-7551-4e30-9026-080f774cac96', 'jamesbrown@example.com', 'https://i.pravatar.cc/150?img=11', FALSE, 'jamesbrown', NOW()),
  ('819ad26c-d4f3-4390-b9dc-09a3a2fe6e65' , 'ashleywilson@example.com', 'https://i.pravatar.cc/150?img=12', FALSE, 'ashleywilson', NOW()),
  ('c8828526-01c8-44dc-a09e-afa162ccc9c7' , 'samueljackson@example.com', 'https://i.pravatar.cc/150?img=13', FALSE, 'samueljackson', NOW()),
  ('3ed55e35-c0a0-4b33-9bb7-33b793ba7bc6' , 'lauradavis@example.com', 'https://i.pravatar.cc/150?img=14', FALSE, 'lauradavis', NOW()),
  ('8e0cee35-2ffe-4654-a043-c19cecd0b571' , 'robertmorris@example.com', 'https://i.pravatar.cc/150?img=15', FALSE, 'robertmorris', NOW()),
  ('e3cd5c37-00a9-46ff-9004-0afac0df9c70' , 'dianeparker@example.com', 'https://i.pravatar.cc/150?img=16', FALSE, 'dianeparker', NOW()),
  ('2bb24f9c-4fc8-423c-ab5b-fe4fb7a053d9' , 'kevinsmith@example.com', 'https://i.pravatar.cc/150?img=17', FALSE, 'kevinsmith', NOW()),
  ('c52b33a3-4fbb-4a72-b64c-8bd6563810ae' , 'kellygreen@example.com', 'https://i.pravatar.cc/150?img=18', FALSE, 'kellygreen', NOW()),
  ('2e0cee35-2ffe-4624-a043-c19cecd0b472' , 'williamturner@example.com', 'https://i.pravatar.cc/150?img=19', FALSE, 'williamturner', NOW()),
  ('519ad26c-d4f3-4380-b9dc-09a3a2fe6e36' , 'jessicamiller@example.com', 'https://i.pravatar.cc/150?img=20', FALSE, 'jessicamiller', NOW());

  INSERT INTO csevents.events (id, created_at, name, description, starts_at, ends_at, cover_image, address, private, deleted, user_id)
  VALUES
    ('b293293b-b133-4a2b-8aa4-d9afb488c680', NOW(), 'TED2023 Conference', 'TED is a nonprofit devoted to spreading ideas, usually in the form of short, powerful talks.', NOW() + INTERVAL '1 MONTH', NOW() + INTERVAL '1 MONTH 3 DAYS', 'https://ted.com/talks/cover.jpg', 'Vancouver Convention Centre, Vancouver, Canada', FALSE, FALSE, '38d61eba-45ef-460a-b9d3-ccdbaf7a4187'),
    ('ccacfe1e-398a-42cb-bccc-fd3a5f8ef293', NOW(), 'Web Summit 2023', 'Web Summit brings together the people and companies redefining the global tech industry.', NOW() + INTERVAL '2 MONTH', NOW() + INTERVAL '2 MONTH 4 DAYS', 'https://websummit.com/cover.jpg', 'Altice Arena, Lisbon, Portugal', FALSE, FALSE, '5c6cb802-0834-46e1-ae1b-396c3cbc75c8'),
    ('2d8c4bf8-ff8a-4cb9-b60a-b514c4df6ee4', NOW(), 'Comic Con 2023', 'Comic Con is a multi-genre entertainment and comic convention.', NOW() + INTERVAL '3 MONTH', NOW() + INTERVAL '3 MONTH 3 DAYS', 'https://comiccon.com/cover.jpg', 'San Diego Convention Center, San Diego, USA', FALSE, FALSE, '2e0cee35-2ffe-4624-a043-c19cecd0b472'),
    ('55980b2b-4f50-4f11-80a2-4ad62e2ca860', NOW(), 'New York Fashion Week', 'New York Fashion Week is a fashion event held twice a year in New York City.', NOW() + INTERVAL '4 MONTH', NOW() + INTERVAL '4 MONTH 5 DAYS', 'https://nyfw.com/cover.jpg', 'Skylight Clarkson Sq, New York City, USA', FALSE, FALSE, '819ad26c-d4f3-4390-b9dc-09a3a2fe6e65'),
    ('a8a68074-b46e-4ead-8ed1-68791af31247', NOW(), 'Cannes Film Festival 2023', 'Cannes Film Festival is an annual film festival held in Cannes, France.', NOW() + INTERVAL '5 MONTH', NOW() + INTERVAL '5 MONTH 7 DAYS', 'https://cannesfilmfestival.com/cover.jpg', 'Palais des Festivals et des Congrès, Cannes, France', FALSE, FALSE, '9cb9323a-7235-499c-996a-8a989558d292'),
    ('0366a101-12f0-4fbd-a727-2f13cfa9cd5c', NOW(), 'Coachella 2023', 'Coachella is an annual music and arts festival held in California.', NOW() + INTERVAL '6 MONTH', NOW() + INTERVAL '6 MONTH 4 DAYS', 'https://coachella.com/cover.jpg', 'Empire Polo Club, Indio, California, USA', FALSE, FALSE,  '8d394aa9-7551-4e30-9026-080f774cac96'),
    ('593eb395-001b-44a7-b675-1f6fa5957857', NOW(), 'Art Basel 2023', 'Art Basel is an international art fair held annually in Basel, Switzerland.', NOW() + INTERVAL '7 MONTH', NOW() + INTERVAL '7 MONTH 6 DAYS', 'https://artbasel.com/cover.jpg', 'Messe Basel, Basel, Switzerland', FALSE, FALSE,  '3ed55e35-c0a0-4b33-9bb7-33b793ba7bc6'),
    ('d1b4f656-e0a1-4b5b-b2ac-cdd64d2d9486', NOW(), 'South by Southwest (SXSW) 2023', 'SXSW is an annual conglomerate of film, interactive media, and music festivals.', NOW() + INTERVAL '8 MONTH', NOW() + INTERVAL '8 MONTH 7 DAYS', 'https://sxsw.com/cover.jpg', 'Austin Convention Center, Austin, Texas, USA', FALSE, FALSE, '2bb24f9c-4fc8-423c-ab5b-fe4fb7a053d9'),
    ('d7cba507-b008-4fdc-a9e1-b26bbf667ae3', NOW(), 'Paris Fashion Week 2023', 'Paris Fashion Week is a fashion event held biannually in Paris, France.', NOW() + INTERVAL '9 MONTH', NOW() + INTERVAL '9 MONTH 8 DAYS', 'https://sxsw.com/cover.jpg', 'Texas Convention Center, Texas, USA', FALSE, FALSE, '2e0cee35-2ffe-4624-a043-c19cecd0b472'),
    ('cce7dd0e-7c71-49c4-9642-aafaeee9d8be', NOW(), 'New York Fashion Week', 'This is a Fashion week in the times Square', NOW() + INTERVAL '7 MONTH', NOW() + INTERVAL '7 MONTH 6 DAYS', 'https://artbasel.com/cover.jpg', 'Messe Basel, Basel, Switzerland', FALSE, FALSE,  '3ed55e35-c0a0-4b33-9bb7-33b793ba7bc6');

  INSERT INTO csevents.attendees (event_id, user_id)
  VALUES
  ('55980b2b-4f50-4f11-80a2-4ad62e2ca860' , 'e3cd5c37-00a9-46ff-9004-0afac0df9c70'),
  ('ccacfe1e-398a-42cb-bccc-fd3a5f8ef293' , 'c52b33a3-4fbb-4a72-b64c-8bd6563810ae'),
  ('2d8c4bf8-ff8a-4cb9-b60a-b514c4df6ee4' , '2e0cee35-2ffe-4624-a043-c19cecd0b472'),
  ('a8a68074-b46e-4ead-8ed1-68791af31247' , '5c6cb802-0834-46e1-ae1b-396c3cbc75c8'),
  ('0366a101-12f0-4fbd-a727-2f13cfa9cd5c' , '519ad26c-d4f3-4380-b9dc-09a3a2fe6e36'),
  ('593eb395-001b-44a7-b675-1f6fa5957857' , '9cb9323a-7235-499c-996a-8a989558d292'),
  ('d7cba507-b008-4fdc-a9e1-b26bbf667ae3' , 'c8828526-01c8-44dc-a09e-afa162ccc9c7'),
  ('cce7dd0e-7c71-49c4-9642-aafaeee9d8be' , 'c8828526-01c8-44dc-a09e-afa162ccc9c7'),
  ('593eb395-001b-44a7-b675-1f6fa5957857' , 'c52b33a3-4fbb-4a72-b64c-8bd6563810ae'),
  ('593eb395-001b-44a7-b675-1f6fa5957857' , '457d3c28-57ba-44bf-9bba-2c844b2a0c4c'),
  ('55980b2b-4f50-4f11-80a2-4ad62e2ca860' , 'db6f8bb4-474d-4301-9bc9-1845b6758f45'),
  ('ccacfe1e-398a-42cb-bccc-fd3a5f8ef293' , '9cb9323a-7235-499c-996a-8a989558d292'),
  ('2d8c4bf8-ff8a-4cb9-b60a-b514c4df6ee4' , '8c6b30f8-ac41-4ad0-be1b-3da9e36eb3cb'),
  ('a8a68074-b46e-4ead-8ed1-68791af31247' , 'c8828526-01c8-44dc-a09e-afa162ccc9c7'),
  ('593eb395-001b-44a7-b675-1f6fa5957857' , 'e3cd5c37-00a9-46ff-9004-0afac0df9c70'),
  ('d1b4f656-e0a1-4b5b-b2ac-cdd64d2d9486' , '457d3c28-57ba-44bf-9bba-2c844b2a0c4c'),
  ('d7cba507-b008-4fdc-a9e1-b26bbf667ae3' , '200749c8-09b3-441a-8991-bad9881f3869'),
  ('cce7dd0e-7c71-49c4-9642-aafaeee9d8be' , '8c6b30f8-ac41-4ad0-be1b-3da9e36eb3cb');

INSERT INTO csevents.tags (tag_id, tag_name)
VALUES
    (1, 'Technology'),
    (2, 'Innovation'),
    (3, 'Science'),
    (4, 'Art'),
    (5, 'Design'),
    (6, 'Fashion'),
    (7, 'Music'),
    (8, 'Film'),
    (9, 'Entertainment');

INSERT INTO csevents.event_tag_map (event_id, tag_id)
  VALUES
    ('b293293b-b133-4a2b-8aa4-d9afb488c680', '1'),
    ('d7cba507-b008-4fdc-a9e1-b26bbf667ae3', '2'),
    ('d7cba507-b008-4fdc-a9e1-b26bbf667ae3', '4'),
    ('d1b4f656-e0a1-4b5b-b2ac-cdd64d2d9486', '5'),
    ('0366a101-12f0-4fbd-a727-2f13cfa9cd5c', '4'),
    ('a8a68074-b46e-4ead-8ed1-68791af31247', '7'),
    ('0366a101-12f0-4fbd-a727-2f13cfa9cd5c', '5'),
    ('d1b4f656-e0a1-4b5b-b2ac-cdd64d2d9486', '6'),
    ('ccacfe1e-398a-42cb-bccc-fd3a5f8ef293', '7'),
    ('ccacfe1e-398a-42cb-bccc-fd3a5f8ef293', '8'),
    ('cce7dd0e-7c71-49c4-9642-aafaeee9d8be', '8'),
    ('d7cba507-b008-4fdc-a9e1-b26bbf667ae3', '9'),
    ('2d8c4bf8-ff8a-4cb9-b60a-b514c4df6ee4', '4'),
    ('593eb395-001b-44a7-b675-1f6fa5957857', '7'),
    ('a8a68074-b46e-4ead-8ed1-68791af31247', '9');

  INSERT INTO csevents.bookmarks (created_at, event_id, user_id)
  VALUES
      (NOW(), 'b293293b-b133-4a2b-8aa4-d9afb488c680', '9cb9323a-7235-499c-996a-8a989558d292'),
      (NOW(), 'd7cba507-b008-4fdc-a9e1-b26bbf667ae3', 'e3cd5c37-00a9-46ff-9004-0afac0df9c70'),
      (NOW(), 'd1b4f656-e0a1-4b5b-b2ac-cdd64d2d9486', '8c6b30f8-ac41-4ad0-be1b-3da9e36eb3cb'),
      (NOW(), 'cce7dd0e-7c71-49c4-9642-aafaeee9d8be', '200749c8-09b3-441a-8991-bad9881f3869'),
      (NOW(), 'd1b4f656-e0a1-4b5b-b2ac-cdd64d2d9486', '8c6b30f8-ac41-4ad0-be1b-3da9e36eb3cb'),
      (NOW(), 'a8a68074-b46e-4ead-8ed1-68791af31247', 'c52b33a3-4fbb-4a72-b64c-8bd6563810ae'),
      (NOW(), 'cce7dd0e-7c71-49c4-9642-aafaeee9d8be', '519ad26c-d4f3-4380-b9dc-09a3a2fe6e36');