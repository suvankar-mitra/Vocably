class TranslationDTO {
  String? lang;
  String? code;
  List<TranslationSenses>? translationSenses;

  TranslationDTO({this.lang, this.code, this.translationSenses});

  TranslationDTO.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    code = json['code'];
    if (json['translationSenses'] != null) {
      translationSenses = <TranslationSenses>[];
      json['translationSenses'].forEach((v) {
        translationSenses!.add(new TranslationSenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lang'] = this.lang;
    data['code'] = this.code;
    if (this.translationSenses != null) {
      data['translationSenses'] = this.translationSenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TranslationSenses {
  String? sense;
  String? roman;
  String? word;

  TranslationSenses({this.sense, this.roman, this.word});

  TranslationSenses.fromJson(Map<String, dynamic> json) {
    sense = json['sense'];
    roman = json['roman'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sense'] = this.sense;
    data['roman'] = this.roman;
    data['word'] = this.word;
    return data;
  }
}
