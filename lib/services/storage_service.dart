import 'dart:io';

import 'package:rsvp/constants/const.dart';
import 'package:rsvp/services/auth/authentication.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  static final _supabase = AuthService.instance().supabaseClient;
  static const String _bucketName = 'event-covers';
  static const Logger _logger = Logger('StorageService');

  static Future<Response> uploadImage(File imageFile,
      {String tableName = Constants.EVENTS_TABLE_NAME}) async {
    Response response = Response.init();
    try {
      // final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toUtc().toIso8601String()}.$fileExt';
      await _supabase.storage.from(_bucketName).upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );
      final String imageUrlResponse =
          _supabase.storage.from(_bucketName).getPublicUrl(fileName);
      response.message = 'image uploaded successfully';
      response.data = imageUrlResponse;
    } on StorageException catch (error) {
      response.didSucced = false;
      response.message = 'Failed to upload image';
      response.data = 'error: ${error.message}';
    } catch (error) {
      response.didSucced = false;
      response.message = 'Failed to upload image';
      response.data = error;
    }
    return response;
  }

  static Future<Response> deleteImage(List<String> path) async {
    try {
      final resp = await _supabase.storage.from(_bucketName).remove(path);
      return Response(
          didSucced: true, message: 'image deleted successfully', data: resp);
    } on StorageException catch (error) {
      _logger.e(error.message);
      return Response(
          didSucced: false,
          message: 'Failed to delete image',
          data: 'error: ${error.message}');
    }
  }
}
