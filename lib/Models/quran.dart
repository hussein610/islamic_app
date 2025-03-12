class Surahs {
  int? number;
  String? name;
  String? englishName;

  Surahs({required this.number, required this.name, required this.englishName});
}

class Ayahs {
  int? numberOfSurah;
  int? numberInSurah;
  String? text;
  bool? sajda;

  Ayahs({
    required this.numberOfSurah,
    required this.numberInSurah,
    required this.text,
    required this.sajda,
  });
}
