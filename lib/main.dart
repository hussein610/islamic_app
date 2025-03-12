import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:islamic_app/Screens/hole_quran_screen.dart';
import 'package:islamic_app/Screens/prayer_time_screen.dart';
import 'package:islamic_app/Screens/surah_screen.dart';
import 'package:islamic_app/Screens/tasks_list_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> bodyes = [QuranScreen(), PrayerTimesScreen(), TasksListScreen()];

  int current_nav_index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xffE2BE7F),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          currentIndex: current_nav_index,
          onTap: (int x) {
            setState(() {
              current_nav_index = x;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(FlutterIslamicIcons.quran),
              label: "القرآن الكريم",
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterIslamicIcons.prayingPerson),
              label: "مواقيت الصلاه",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "المهام"),
          ],
        ),
        body: bodyes[current_nav_index],
      ),
      routes: {"Surah": (context) => SurahScreen()},
    );
  }
}

main() {
  runApp(MyApp());
}
