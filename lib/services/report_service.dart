import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/exports.dart';
import 'package:rsvp/models/report.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:supabase/supabase.dart';

class ReportService {
  static const String _tableName = Constants.FEEDBACK_TABLE_NAME;
  static const Logger _logger = Logger('ReportService');

  static Future<List<ReportModel>>? getReports() async {
    final resp = await DatabaseService.findRowsByInnerJoinOnColumn(
      table1: _tableName,
      table2: Constants.USER_TABLE_NAME,
    );
    if (resp.status == 200) {
      return (resp.data as List).map((e) => ReportModel.fromJson(e)).toList();
    } else {
      _logger.e('Error getting reports ${resp.data}');
      throw Exception('Error fetching reports');
    }
  }

  static Future<List<ReportModel>?>? getReportById(String id) async {
    try {
      final resp = await DatabaseService.findRowByColumnValue(
        id,
        columnName: Constants.ID_COLUMN,
        tableName: _tableName,
      );
      if (resp.status == 200) {
        return (resp.data as List).map((e) => ReportModel.fromJson(e)).toList();
      } else {
        throw Exception('Error fetching report');
      }
    } on PostgrestException catch (_) {
      _logger.e('Error adding report ${_.details}');
      throw Exception('Error adding report');
    }
  }

  static Future<PostgrestResponse> addReport(ReportModel report) async {
    try {
      final resp = await DatabaseService.insertIntoTable(
        report.toJsonSchema(),
        table: _tableName,
      );
      if (resp.status == 201) {
        _logger.i('Report added successfully');
      } else {
        _logger.e('Error adding report ${resp.data}');
      }
      return resp;
    } on PostgrestException catch (_) {
      _logger.e('Error adding report ${_.details}');
      throw Exception('Error adding report');
    }
  }
}
