import 'package:dio/dio.dart';
import 'package:vocably/models/translation_dto.dart';
import 'package:vocably/models/word_entry_dto.dart';

class DictionaryApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://fedora.taila978b4.ts.net:8800/dictionaryapi/v1',
      baseUrl: 'https://api.suvankar.cc/dictionaryapi/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 120),
      contentType: 'JSON',
    ),
  );

  Future<WordEntryDTO> getDefinition(String word) async {
    try {
      print("DEBUG: Getting definition for $word");
      final response = await _dio.get('/definitions/en/$word');
      if (response.statusCode == 200) {
        print("DEBUG: Successfully fetched definition for $word");
        print("RAW RESPONSE: ${response.data}");
        WordEntryDTO wdto = WordEntryDTO.fromJson(response.data as Map<String, dynamic>);
        print("DEBUG: Successfully parsed into WordEntryDTO");
        return wdto;
      }
      return WordEntryDTO();
    } on DioException {
      // throw Exception('Failed to fetch definition: ${e.message}');
      rethrow;
    } catch (e) {
      print("DEBUG: Failed to fetch/parse definition: $e");
      throw Exception('Failed to fetch/parse definition: $e');
    }
  }

  Future<WordEntryDTO> getWordOfTheDay() async {
    try {
      print("DEBUG: Getting word of the day");
      final response = await _dio.get('/wordoftheday');
      if (response.statusCode == 200) {
        print("DEBUG: Successfully fetched definition");
        WordEntryDTO wdto = WordEntryDTO.fromJson(response.data as Map<String, dynamic>);
        print("DEBUG: Successfully parsed into WordEntryDTO");
        return wdto;
      }
      return WordEntryDTO();
    } on DioException {
      // throw Exception('Failed to fetch definition: ${e.message}');
      rethrow;
    } catch (e) {
      print("DEBUG: Failed to fetch/parse definition: $e");
      throw Exception('Failed to fetch/parse definition: $e');
    }
  }

  Future<List<String>> getListWordsByFilter(String filter) async {
    try {
      final response = await _dio.get('/words/en/?', queryParameters: {'filter': filter, 'size': '5'});
      return (response.data as List<dynamic>).cast<String>();
    } on DioException catch (e) {
      throw Exception('Failed to fetch Filtered words: ${e.message}');
    }
  }

  Future<List<TranslationDTO>> getTranslations(String word, String pos) async {
    try {
      final response = await _dio.get('/translations/en/?', queryParameters: {'word': word, 'pos': pos});
      if (response.data == null) {
        throw Exception("Received null data from translations API.");
      }

      if (response.data is List) {
        // Dio has already parsed the JSON array into a List<dynamic>
        // where each element is likely a Map<String, dynamic>
        List<dynamic> rawList = response.data as List<dynamic>;

        if (rawList.isEmpty) {
          return []; // Return empty list if API gives empty list
        }

        // Explicitly map each item to TranslationDTO
        List<TranslationDTO> dtoList =
            rawList.map((item) {
              if (item is Map<String, dynamic>) {
                return TranslationDTO.fromJson(item);
              } else {
                // This case should ideally not happen if the API returns a valid JSON array of objects
                throw FormatException("Invalid item type in translation list: ${item.runtimeType}");
              }
            }).toList();
        print("DEBUG: Successfully parsed into List<TranslationDTO>");
        return dtoList;
      }
      throw Exception("Unexpected data type from translations API: ${response.data.runtimeType}");
    } on DioException catch (e) {
      throw Exception('Failed to fetch translations: ${e.message}');
    }
  }
}
