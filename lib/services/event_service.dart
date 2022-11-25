import 'dart:convert';

import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/platform/mobile.dart'
    // ignore: library_prefixes
    if (dart.library.html) 'package:rsvp/platform/web.dart' as platformOnly;
import 'package:rsvp/services/database.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:rsvp/utils/secrets.dart';
import 'package:supabase/supabase.dart';

/// Global Vocabulary table's api.
class EventService {
  static String tableName = EVENTS_TABLE_NAME;
  static final SupabaseClient _supabase = SupabaseClient(CONFIG_URL, APIkey);
  static const _logger = Logger('EventService');
  static Future<PostgrestResponse> findById(String id) async {
    final response = await DatabaseService.findSingleRowByColumnValue(id,
        columnName: ID_COLUMN, tableName: tableName);
    return response;
  }

  static Future<Event?> findByWord(String word) async {
    if (word.isEmpty) {
      return null;
    }
    final response = await DatabaseService.findSingleRowByColumnValue(word,
        columnName: WORD_COLUMN, tableName: tableName);
    Event? result;
    if (response.status == 200) {
      result = Event.fromJson(response.data);
      return result;
    }
    return null;
  }

  static Future<Response> addEvent(Event event) async {
    final json = event.toJson();
    final eventResponse = Response(didSucced: false, message: "Failed");
    try {
      final response =
          await DatabaseService.insertIntoTable(json, table: tableName);
      if (response.status == 201) {
        eventResponse.didSucced = true;
        eventResponse.message = 'Success';
        eventResponse.data = response.data;
      }
      eventResponse.status = response.status;
      eventResponse.message = 'Error';
    } catch (_) {
      _logger.e('Error adding event $_');
      eventResponse.didSucced = false;
      eventResponse.message = 'Error: $_';
    }
    return eventResponse;
  }

  /// ```Select * from words Where state = 'approved';```
  ///
  // Future<List<Word>> getAllApprovedWords({bool sort = true}) async {
  //   final response = await _supabase
  //       .from(tableName)
  //       .select("*")
  //       .eq('state', 'approved')
  //       .execute();
  //   List<Word> words = [];
  //   if (response.status == 200) {
  //     words = (response.data as List).map((e) => Word.fromJson(e)).toList();
  //     if (sort) {
  //       words.sort((a, b) => a.word.compareTo(b.word));
  //     }
  //   }
  //   return words;
  // }

  /// ```Select * from words```

  static Future<List<Event>> getAllEvents({bool sort = false}) async {
    final response = await DatabaseService.findAll(tableName: tableName);
    List<Event> words = [];
    if (response.status == 200) {
      words = (response.data as List).map((e) => Event.fromJson(e)).toList();
      // if (sort) {
      //   words.sort((a, b) => a.created_at.isBefore(b.created_at) ? 1 : -1);
      // }
    }
    return words;
  }

  static Future<List<Event>> exploreWords(String email, {int page = 0}) async {
    final response = await DatabaseService.findLimitedWords(page: page);
    final masteredWords = await getBookmarks(email, isBookmark: false);
    List<Event> words = [];
    List<Event> exploreWords = [];
    if (response.status == 200) {
      words = (response.data as List).map((e) => Event.fromJson(e)).toList();

      /// exclude words that are already bookmarked.
      for (var element in words) {
        if (!masteredWords.contains(element)) {
          exploreWords.add(element);
        }
      }
    }
    return exploreWords;
  }

  static Future<List<EventModel>> getBookmarks(String email,
      {bool isBookmark = true}) async {
    final response = await DatabaseService.findRowsByInnerJoinOn2ColumnValue(
      'email',
      email,
      'state',
      isBookmark ? 'unknown' : 'known',
      table1: EVENTS_TABLE_NAME,
      table2: WORD_STATE_TABLE_NAME,
    );
    List<EventModel> events = [];
    if (response.status == 200) {
      events =
          (response.data as List).map((e) => EventModel.fromJson(e)).toList();
    }
    return events;
  }

  static removeBookmark(String id, {bool isBookmark = true}) async {
    final response = await DatabaseService.updateColumn(
        searchColumn: 'word_id',
        searchValue: id,
        columnName: 'state',
        columnValue: isBookmark ? 'known' : 'unknown',
        tableName: WORD_STATE_TABLE_NAME);
    return response;
  }

  static Future<Event> getLastUpdatedRecord() async {
    final response = await DatabaseService.findRecentlyUpdatedRow(
        'created_at', '',
        table1: WORD_OF_THE_DAY_TABLE_NAME,
        table2: EVENTS_TABLE_NAME,
        ascending: false);
    if (response.status == 200) {
      Event lastWordOfTheDay =
          Event.fromJson(response.data[0][EVENTS_TABLE_NAME]);
      lastWordOfTheDay.createdAt =
          DateTime.parse(response.data[0]['created_at']);
      return lastWordOfTheDay;
    } else {
      throw "Failed to get last updated record";
    }
  }

  static Future<List<Event>> searchEvents(String query,
      {bool sort = false}) async {
    final response = await DatabaseService.findRowsContaining(query,
        columnName: WORD_COLUMN, tableName: tableName);
    List<Event> words = [];
    if (response.status == 200) {
      words = (response.data as List).map((e) => Event.fromJson(e)).toList();
      // if (sort) {
      //   words.sort((a, b) => a.word.compareTo(b.word));
      // }
    }
    return words;
  }

  Future<bool> downloadFile() async {
    try {
      final response = await _supabase.from(tableName).select("*").execute();
      if (response.status == 200) {
        platformOnly.fileSaver(json.encode(response.data), 'file.json');
        return true;
      }
      return false;
    } catch (x) {
      _logger.e(x.toString());
      throw 'x';
    }
  }

  static Future<PostgrestResponse> updateEvent({
    required String id,
    required Event event,
  }) async {
    final Map<String, dynamic> json = event.toJson();
    final response = await DatabaseService.updateRow(
        colValue: id, data: json, columnName: ID_COLUMN, tableName: tableName);
    return response;
  }

  Future<PostgrestResponse> updateDescription({
    required String id,
    required Event event,
  }) async {
    final response = await DatabaseService.updateColumn(
        searchColumn: ID_COLUMN,
        searchValue: id,
        columnValue: event.description,
        columnName: MEANING_COLUMN,
        tableName: tableName);
    return response;
  }

  static Future<PostgrestResponse> deleteById(String id) async {
    _logger.i(tableName);
    final response = await DatabaseService.deleteRow(id,
        tableName: tableName, columnName: ID_COLUMN);
    return response;
  }
}
