class Country {
  final String id;
  final String name;
  final String dialCode;
  final String emoji;
  final String code;
  final String dial_code;


  Country({ required this.id, required this.name, required this.dialCode, required this.emoji, required this.code, required this.dial_code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['code'].toString(),
      name: json['name'],
      dialCode: json['dial_code'],
      emoji: json['emoji'],
      code: json['code'],
      dial_code : json['dial_code'],
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dial_code': dialCode,
      'emoji': emoji,
      'code': code,
      // 'dial_code': dial_code,
    };
  }
}
