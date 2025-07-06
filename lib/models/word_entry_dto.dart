class WordEntryDTO {
  final String? word;
  final String? lang;
  final String? ipa;
  final String? audioUrl;
  final List<MeaningDTO>? meanings;
  final List<SoundDTO>? sounds;
  final AttributeDTO? attribute;

  WordEntryDTO({this.word, this.lang, this.ipa, this.audioUrl, this.meanings, this.sounds, this.attribute});

  factory WordEntryDTO.fromJson(Map<String, dynamic> json) => WordEntryDTO(
    word: json['word'] ?? '',
    lang: json['lang'] ?? '',
    ipa: json['ipa'] ?? '',
    audioUrl: json['audioUrl'] ?? '',
    meanings: json['meanings'] != null ? (json['meanings'] as List).map((e) => MeaningDTO.fromJson(e)).toList() : null,
    sounds: json['sounds'] != null ? (json['sounds'] as List).map((e) => SoundDTO.fromJson(e)).toList() : null,
    attribute: json['attribute'] != null ? AttributeDTO.fromJson(json['attribute']) : null,
  );

  Map<String, dynamic> toJson() => {
    if (word != null) 'word': word,
    if (lang != null) 'lang': lang,
    if (ipa != null) 'ipa': ipa,
    if (audioUrl != null) 'audioUrl': audioUrl,
    if (meanings != null) 'meanings': meanings!.map((e) => e.toJson()).toList(),
    if (sounds != null) 'sounds': sounds!.map((e) => e.toJson()).toList(),
    if (attribute != null) 'attribute': attribute!.toJson(),
  };
}

class MeaningDTO {
  final String? partOfSpeech;
  final List<SenseDTO>? senses;
  final List<String>? synonyms;
  final List<String>? antonyms;
  final String? etymologyText;

  MeaningDTO({this.partOfSpeech, this.senses, this.synonyms, this.antonyms, this.etymologyText});

  factory MeaningDTO.fromJson(Map<String, dynamic> json) => MeaningDTO(
    partOfSpeech: json['partOfSpeech'],
    senses: json['senses'] != null ? (json['senses'] as List).map((e) => SenseDTO.fromJson(e)).toList() : null,
    synonyms: json['synonyms'] != null ? safeStringList(json['synonyms']) : null,
    antonyms: json['antonyms'] != null ? safeStringList(json['antonyms']) : null,
    etymologyText: json['etymologyText'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    if (partOfSpeech != null) 'partOfSpeech': partOfSpeech,
    if (senses != null) 'senses': senses!.map((e) => e.toJson()).toList(),
    if (synonyms != null) 'synonyms': synonyms,
    if (antonyms != null) 'antonyms': antonyms,
    if (etymologyText != null) 'etymologyText': etymologyText,
  };
}

class SenseDTO {
  final List<String>? glosses;
  final List<String>? synonyms;
  final List<String>? antonyms;
  final List<String>? examples;
  final List<String>? tags;
  final List<String>? related;

  SenseDTO({this.glosses, this.synonyms, this.antonyms, this.examples, this.tags, this.related});

  factory SenseDTO.fromJson(Map<String, dynamic> json) => SenseDTO(
    glosses: json['glosses'] != null ? safeStringList(json['glosses']) : null,
    synonyms: json['synonyms'] != null ? safeStringList(json['synonyms']) : null,
    antonyms: json['antonyms'] != null ? safeStringList(json['antonyms']) : null,
    examples: json['examples'] != null ? safeStringList(json['examples']) : null,
    tags: json['tags'] != null ? safeStringList(json['tags']) : null,
    related: json['related'] != null ? safeStringList(json['related']) : null,
  );

  Map<String, dynamic> toJson() => {
    if (glosses != null) 'glosses': glosses,
    if (synonyms != null) 'synonyms': synonyms,
    if (antonyms != null) 'antonyms': antonyms,
    if (examples != null) 'examples': examples,
    if (tags != null) 'tags': tags,
    if (related != null) 'related': related,
  };
}

class SoundDTO {
  final String? ipa;
  final String? oggUrl;
  final String? mp3Url;
  final List<String>? tags;

  SoundDTO({this.ipa, this.oggUrl, this.mp3Url, this.tags});

  factory SoundDTO.fromJson(Map<String, dynamic> json) => SoundDTO(
    ipa: json['ipa'] ?? '',
    oggUrl: json['oggUrl'] ?? '',
    mp3Url: json['mp3Url'] ?? '',
    tags: json['tags'] != null ? safeStringList(json['tags']) : null,
  );

  Map<String, dynamic> toJson() => {
    if (ipa != null) 'ipa': ipa,
    if (oggUrl != null) 'oggUrl': oggUrl,
    if (mp3Url != null) 'mp3Url': mp3Url,
    if (tags != null) 'tags': tags,
  };
}

class AttributeDTO {
  final String? source;
  final String? sourceUrl;
  final String? sourceLicense;
  final String? note;
  final ApiDTO? api;

  AttributeDTO({this.source, this.sourceUrl, this.sourceLicense, this.note, this.api});

  factory AttributeDTO.fromJson(Map<String, dynamic> json) => AttributeDTO(
    source: json['source'] ?? '',
    sourceUrl: json['sourceUrl'] ?? '',
    sourceLicense: json['sourceLicense'] ?? '',
    note: json['note'] ?? '',
    api: json['api'] != null ? ApiDTO.fromJson(json['api']) : null,
  );

  Map<String, dynamic> toJson() => {
    if (source != null) 'source': source,
    if (sourceUrl != null) 'sourceUrl': sourceUrl,
    if (sourceLicense != null) 'sourceLicense': sourceLicense,
    if (note != null) 'note': note,
    if (api != null) 'api': api!.toJson(),
  };
}

class ApiDTO {
  final String? name;
  final String? url;
  final String? license;
  final bool? attributionRequired;
  final String? attributionText;

  ApiDTO({this.name, this.url, this.license, this.attributionRequired, this.attributionText});

  factory ApiDTO.fromJson(Map<String, dynamic> json) => ApiDTO(
    name: json['name'] ?? '',
    url: json['url'] ?? '',
    license: json['license'] ?? '',
    attributionRequired: json['attributionRequired'] == null ? null : json['attributionRequired'] as bool,
    attributionText: json['attributionText'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (url != null) 'url': url,
    if (license != null) 'license': license,
    if (attributionRequired != null) 'attributionRequired': attributionRequired,
    if (attributionText != null) 'attributionText': attributionText,
  };
}

List<String>? safeStringList(dynamic list) {
  if (list is List) {
    return list.whereType<String>().toList();
  }
  return null;
}
