import 'package:dio/dio.dart';
import 'package:vocably/models/word_entry_dto.dart';

class DictionaryApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://fedora.taila978b4.ts.net:8800/dictionaryapi/v1',
      baseUrl: 'http://skull-fedora.taila978b4.ts.net:8800/dictionaryapi/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60),
      contentType: 'JSON',
    ),
  );

  Future<WordEntryDTO> getDefinition(String word) async {
    try {
      final response = await _dio.get('/definitions/en/$word');
      return WordEntryDTO.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      // throw Exception('Failed to fetch definition: ${e.message}');
      rethrow;
    }
  }

  Future<WordEntryDTO> getWordOfTheDay() async {
    return getDefinition('light');
  }

  Future<List<String>> getListWordsByFilter(String filter) async {
    try {
      final response = await _dio.get('/words/en?', queryParameters: {'filter': filter, 'size': '3'});
      // Assuming the API returns a JSON array of strings
      return (response.data as List<dynamic>).cast<String>();
    } on DioException catch (e) {
      throw Exception('Failed to fetch Filtered words: ${e.message}');
    }
  }
}
