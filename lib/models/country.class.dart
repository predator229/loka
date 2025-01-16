class Country {
  final String id;
  final String name;
  final String emoji;
  final String code;
  final String dialcode;


  Country({ required this.id, required this.name, required this.emoji, required this.code, required this.dialcode});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['code'].toString(),
      name: json['name'],
      emoji: json['emoji'],
      code: json['code'],
      dialcode : json['dial_code'],
    );
  }
    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dialcode': dialcode,
      'emoji': emoji,
      'code': code,
      // 'dialcode': dialcode,
    };
  }
}
