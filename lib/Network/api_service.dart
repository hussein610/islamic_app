import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:islamic_app/Models/prayer.dart';
import 'package:islamic_app/Models/quran.dart';

class ApiService {
  Dio dio = Dio();

  Future<Prayer> getPrayerTime() async {
    try {
      String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());

      var prayerResponse = await dio.get(
        "https://api.aladhan.com/v1/timingsByCity/$todayDate?city=Cairo&country=Egypt&method=8",
      );

      Map<String, dynamic> prayerData = prayerResponse.data;
      Map<String, dynamic> timings = prayerData["data"]["timings"];

      return Prayer(
        Fajr: timings["Fajr"],
        Dhuhr: timings["Dhuhr"],
        Asr: timings["Asr"],
        Maghrib: timings["Maghrib"],
        Isha: timings["Isha"],
      );
    } catch (e) {
      print("Error fetching prayer times: $e");
      return Prayer(Fajr: "", Dhuhr: "", Asr: "", Maghrib: "", Isha: "");
    }
  }

  getQuranSurah() async {
    var quranSurahResponse = await dio.get(
      "https://api.alquran.cloud/v1/quran/quran-uthmani",
    );
    Map<String, dynamic> quranSurahData = quranSurahResponse.data;
    List<Surahs> surahs = [];
    for (var i in quranSurahData["data"]["surahs"]) {
      surahs.add(
        Surahs(
          number: i["number"],
          name: i["name"],
          englishName: i["englishName"],
        ),
      );
    }
    return surahs;
  }

  getQuranAyahs() async {
    var quranAyahsResponse = await dio.get(
      "https://api.alquran.cloud/v1/quran/quran-uthmani",
    );
    Map<String, dynamic> quranAyahsData = quranAyahsResponse.data;
    List<Ayahs> ayahs = [];

    for (var surah in quranAyahsData["data"]["surahs"]) {
      for (var i in surah["ayahs"]) {
        bool hasSajda = false;

        if (i["sajda"] is bool) {
          hasSajda = i["sajda"];
        } else if (i["sajda"] is Map) {
          hasSajda = true;
        }

        ayahs.add(
          Ayahs(
            numberOfSurah: surah["number"],
            numberInSurah: i["numberInSurah"],
            text: i["text"],
            sajda: hasSajda,
          ),
        );
      }
    }
    return ayahs;
  }
}
