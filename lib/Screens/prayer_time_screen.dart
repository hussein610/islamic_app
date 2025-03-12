import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late Future<Map<String, String>> futurePrayerTimes;

  @override
  void initState() {
    super.initState();
    futurePrayerTimes = getPrayerTime();
  }

  Future<Map<String, String>> getPrayerTime() async {
    try {
      String todayDate = DateFormat(
        "dd-MM-yyyy",
      ).format(DateTime.now().toLocal());

      var prayerResponse = await Dio().get(
        "https://api.aladhan.com/v1/timingsByCity/$todayDate?city=cairo&country=egypt&method=8",
      );

      Map<String, dynamic> timings = prayerResponse.data["data"]["timings"];

      return {
        "Fajr": timings["Fajr"],
        "Dhuhr": timings["Dhuhr"],
        "Asr": timings["Asr"],
        "Maghrib": timings["Maghrib"],
        "Isha": timings["Isha"],
      };
    } catch (e) {
      print("Error fetching prayer times: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " ${DateFormat("dd MMM yyyy").format(DateTime.now().toLocal())}",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffE2BE7F),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/vertical-shot-hassan-ii-mosque-casablanca-morocco.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Map<String, String>>(
          future: futurePrayerTimes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xffE2BE7F)),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Failed to load prayer times.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            Map<String, String> prayerTimes = snapshot.data!;
            List<String> keys = prayerTimes.keys.toList();

            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                String prayer = keys[index];
                String time = prayerTimes[prayer]!;

                return Card(
                  color: Color(0xffE2BE7F),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.access_time, color: Colors.black87),
                    title: Text(
                      prayer,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      time,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
