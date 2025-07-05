import 'dart:convert';

// Helper function to decode the list from a JSON string
List<TranslationDTO> translationDTOListFromJson(String str) {
  if (str.isEmpty) return [];
  final decoded = json.decode(str);
  if (decoded is List) {
    return List<TranslationDTO>.from(
      decoded.map((x) {
        if (x is Map<String, dynamic>) {
          return TranslationDTO.fromJson(x);
        }
        throw FormatException("Invalid item type in JSON string list for TranslationDTO: ${x.runtimeType}");
      }),
    );
  }
  throw FormatException("Expected a JSON list for TranslationDTOs, got: ${decoded.runtimeType}");
}

// Helper function to encode the list to a JSON string
String translationDTOListToJson(List<TranslationDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TranslationDTO {
  final String? lang;
  final String? code;
  final String? sense;
  final String? roman;
  final String? word;

  TranslationDTO({this.lang, this.code, this.sense, this.roman, this.word});

  factory TranslationDTO.fromJson(Map<String, dynamic> jsonMap) {
    return TranslationDTO(
      lang: jsonMap["lang"] as String?,
      code: jsonMap["code"] as String?,
      sense: jsonMap["sense"] as String?,
      roman: jsonMap["roman"] as String?,
      word: jsonMap["word"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {"lang": lang, "code": code, "sense": sense, "roman": roman, "word": word};
}
