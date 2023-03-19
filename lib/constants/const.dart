/// APP CONSTANTS GO HERE IN THIS FILE

class Constants {
  static const String APP_TITLE = 'RSVP';
  static const String BASE_URL = '';
  static const VERSION = 'v0.0.1';
  static const VERSION_KEY = 'version';
  static const UPDATE_URL_KEY = 'update_url';
  static const FORCE_UPDATE_KEY = 'forceUpdate';
  static const CONFIG_COLLECTION_KEY = 'config';
  static const UPDATE_DOC_KEY = 'app';
  static const BUILD_NUMBER_KEY = 'buildNumber';
  static const REPO_NAME = 'rsvp-corsairs';
  static const SOURCE_CODE_URL = 'https://github.com/maheshmnj/$REPO_NAME';

  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=com.wml.rsvp';
  static const AMAZON_APP_STORE_URL = '';

  static const REPORT_URL =
      'https://github.com/maheshmnj/$REPO_NAME/issues/new/choose';

  static const String signInScopeUrl =
      'https://www.googleapis.com/auth/contacts.readonly';
// const SHEET_URL =
//     'https://docs.google.com/spreadsheets/d/1G1RtQfsEDqHhHP4cgOpO9x_ZtQ1dYa6QrGCq3KFlu50';

  static const PRIVACY_POLICY = 'https://maheshmnj.github.io/privacy';

  static const String profileUrl = 'assets/profile.png';

  static const FEEDBACK_EMAIL_TO = 'maheshmn121@gmail.com';

  static const SUPABASE_API_KEY = String.fromEnvironment('SUPABASE_API_KEY');
  static const SUPABASE_URL = String.fromEnvironment('SUPABASE_PROJECT_URL');
  static const REDIRECT_URL = String.fromEnvironment('SUPABASE_REDIRECT_URL');

  /// TABLES
  static const EVENTS_TABLE_NAME = 'events';
  static const ATTENDEES_TABLE_NAME = 'attendees';

  static const USER_TABLE_NAME = 'user';
  static const BOOKMARKS_TABLE_NAME = 'bookmarks';
// const VOCAB_TABLE_NAME = 'vocabsheet_copy';
// const USER_TABLE_NAME = 'users_test';
  static const FEEDBACK_TABLE_NAME = 'feedback';

  static const WORD_STATE_TABLE_NAME = 'word_state';
  static const WORD_OF_THE_DAY_TABLE_NAME = 'word_of_the_day';

  /// VOCAB TABLE COLUMNS
  static const EVENT_NAME_COLUMN = 'name';
  static const ID_COLUMN = 'id';
  static const HOST_COLUMN = 'host';
  static const EVENT_ID_COLUMN = 'event_id';
  static const EVENT_USER_ID_COLUMN = 'user_id';
  static const SYNONYM_COLUMN = 'synonyms';
  static const MEANING_COLUMN = 'meaning';
  static const EXAMPLE_COLUMN = 'example';
  static const NOTE_COLUMN = 'notes';
  static const STATE_COLUMN = 'state';
  static const CREATED_AT_COLUMN = 'createdAt';

  /// USER TABLE COLUMNS
  static const USER_ID_COLUMN = 'user_id';
  static const USER_NAME_COLUMN = 'name';
  static const USER_EMAIL_COLUMN = 'email';
  static const USERNAME_COLUMN = 'username';
  static const USER_BOOKMARKS_COLUMN = 'bookmarks';
  static const USER_CREATED_AT_COLUMN = 'created_at';
  static const USER_LOGGEDIN_COLUMN = 'isLoggedIn';
  static const STUDENT_ID_COLUMN = 'studentId';

  /// EDIT HISTORY TABLE COLUMNS
  static const EDIT_ID_COLUMN = 'edit_id';
  static const EDIT_USER_ID_COLUMN = 'user_id';
  static const EDIT_WORD_ID_COLUMN = 'word_id';

  static const String dateFormatter = 'MMMM dd, y';
  static const String timeFormatter = 'h:mm a';

  static const int HOME_INDEX = 0;
  static const int SEARCH_INDEX = 1;
  static const int EXPLORE_INDEX = 2;
  static const int PROFILE_INDEX = 3;

  int maxExampleCount = 3;
  int maxSynonymCount = 5;
  int maxMnemonicCount = 5;

  static const int NAME_VALIDATOR = 0;
  static const int EMAIL_VALIDATOR = 1;
  static const int STUDENT_ID_VALIDATOR = 2;
  static const int PASSWORD_VALIDATOR = 3;
  static const int USER_ID_VALIDATOR = 12;

  // static const String emailPattern =
  //     r'^[a-zA-Z]+[a-zA-Z0-9_.+-]+@[a-z]{4,}.[a-z]{3}$';
  // email pattern for @domain.com or @domain.co.in or @domain.in etc
  static const String emailPattern = r'^[a-zA-Z]+[a-zA-Z0-9_.+-]+@[a-z._]{4,}$';

  static const String userPattern = r'^[a-zA-Z0-9]{3,}$';
  static const String firstAndLastNamePattern = r'^[a-zA-Z]{3,}\s[a-zA-Z]{3,}$';
  static const String studentIdPattern = r'^[0-9]{8}$';
}

enum RequestState { active, done, error, none }

enum EditState {
  approved('approved'),

  /// Admin has rejected the request
  rejected('rejected'),
  pending('pending'),

  /// user can cancel the edit request
  cancelled('cancelled');

  final String state;
  const EditState(this.state);

  String toName() => state;
}

enum Status { success, notfound, error }

enum WordState { known, unknown, unanswered }

enum EditType {
  /// request to add a new word
  add,

  /// request to edit an existing word
  edit,

  /// request to delete an existing word
  delete,
}
