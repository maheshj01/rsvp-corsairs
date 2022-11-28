import 'dart:convert';

import 'package:rsvp/constants/const.dart';
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

  static Future<EventModel?> findEventById(String eventId) async {
    if (eventId.isEmpty) {
      return null;
    }
    final response = await DatabaseService.findRowWithInnerjoinColumnValue(
        eventId,
        columnName: ID_COLUMN,
        table1: tableName,
        table2: USER_TABLE_NAME);
    EventModel? result;
    if (response.status == 200) {
      result = EventModel.fromAllSchema(response.data);
      return result;
    }
    return null;
  }

  static Future<Response> addEvent(EventModel event) async {
    final json = event.schematoJson();
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
    } on PostgrestException catch (_) {
      _logger.e('Error adding event ${_.details}');
      eventResponse.didSucced = false;
      eventResponse.message = 'Error: $_';
    }
    return eventResponse;
  }

  static Future<Response> updateEvent({
    required EventModel event,
  }) async {
    final eventResponse = Response(didSucced: false, message: "Failed");
    try {
      final Map<String, dynamic> json = event.schematoJson();
      // remove id key
      // json.remove(ID_COLUMN);
      final response = await DatabaseService.updateRow(
          colValue: event.id!,
          data: json,
          columnName: ID_COLUMN,
          tableName: tableName);
      if (response.status == 204) {
        return eventResponse.copyWith(
            didSucced: true,
            message: 'Updated Successfully',
            data: response.data);
      } else {
        return eventResponse.copyWith(
            didSucced: false, message: 'Failed to update', data: response.data);
      }
    } catch (_) {
      _logger.e('Error updating event $_');
      eventResponse.didSucced = false;
      eventResponse.message = 'Error: $_';
    }
    return eventResponse;
  }

  static Future<List<EventModel>> getAllEvents({bool sort = false}) async {
    final response = await DatabaseService.findRowsByInnerJoinOnColumn();
    List<EventModel> events = [];
    if (response.status == 200) {
      events = (response.data as List)
          .map((e) => EventModel.fromAllSchema(e))
          .toList();
      if (sort) {
        events.sort((a, b) => a.createdAt!.isBefore(b.createdAt!) ? 1 : -1);
      }
    }
    return events;
  }

  static Future<List<EventModel>> getAttendees(String eventId) async {
    final response = await DatabaseService.findRowsByInnerJoinOnColumn(
      table1: EVENTS_TABLE_NAME,
      table2: ATTENDEES_TABLE_NAME,
    );
    List<EventModel> events = [];
    if (response.status == 200) {
      events =
          (response.data as List).map((e) => EventModel.fromJson(e)).toList();
    }
    return events;
  }

  static rsvpEvent(String eventId, String userId, {bool going = true}) async {
    try {
      if (going) {
        final response = await DatabaseService.insertIntoTable({
          'event_id': eventId,
          'user_id': userId,
        }, table: ATTENDEES_TABLE_NAME);
        return response;
      } else {
        final response = await DatabaseService.deleteRowBy2ColumnValue(
          eventId,
          userId,
          column1Name: EVENT_ID_COLUMN,
          column2Name: EVENT_USER_ID_COLUMN,
          tableName: ATTENDEES_TABLE_NAME,
        );
        return response;
      }
    } catch (_) {
      _logger.e('Error rsvp event $_');
      rethrow;
    }
  }

  static Future<EventModel> getLastUpdatedRecord() async {
    final response = await DatabaseService.findRecentlyUpdatedRow(
        'created_at', '',
        table1: WORD_OF_THE_DAY_TABLE_NAME,
        table2: EVENTS_TABLE_NAME,
        ascending: false);
    if (response.status == 200) {
      EventModel lastWordOfTheDay =
          EventModel.fromJson(response.data[0][EVENTS_TABLE_NAME]);
      lastWordOfTheDay.createdAt =
          DateTime.parse(response.data[0]['created_at']);
      return lastWordOfTheDay;
    } else {
      throw "Failed to get last updated record";
    }
  }

  static Future<List<EventModel>> searchEvents(String query,
      {bool sort = false}) async {
    final response = await DatabaseService.findRowsContaining(query,
        columnName: EVENT_NAME_COLUMN, tableName: tableName);
    List<EventModel> words = [];
    if (response.status == 200) {
      words =
          (response.data as List).map((e) => EventModel.fromJson(e)).toList();
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

  Future<PostgrestResponse> updateDescription({
    required String id,
    required EventModel event,
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
