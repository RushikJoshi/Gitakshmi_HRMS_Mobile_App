import 'package:dio/dio.dart';

class MultipartHelper {
  /// Converts a local file path to a Dio [MultipartFile]
  static Future<MultipartFile> fileToMultipart(
    String filePath, {
    String? filename,
  }) async {
    return await MultipartFile.fromFile(
      filePath,
      filename: filename,
    );
  }

  /// Converts multiple file paths to a list of [MultipartFile]
  static Future<List<MultipartFile>> filesToMultipart(
    List<String> filePaths,
  ) async {
    final List<MultipartFile> multipartFiles = [];
    for (final path in filePaths) {
      final file = await MultipartFile.fromFile(path);
      multipartFiles.add(file);
    }
    return multipartFiles;
  }

  /// Builds a [FormData] object from a map of fields and optional file fields
  static Future<FormData> buildFormData({
    required Map<String, dynamic> fields,
    Map<String, String>? filePaths,
  }) async {
    final Map<String, dynamic> formFields = {...fields};

    if (filePaths != null) {
      for (final entry in filePaths.entries) {
        formFields[entry.key] = await MultipartFile.fromFile(entry.value);
      }
    }

    return FormData.fromMap(formFields);
  }
}
