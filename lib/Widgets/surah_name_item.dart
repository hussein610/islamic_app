import 'package:flutter/material.dart';

import '../Models/quran.dart';

class SurahNameItem extends StatelessWidget {
  final Surahs surahs;

  const SurahNameItem({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Container(
          height: 50,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    surahs.name!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    surahs.englishName!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " سوره رقم ${surahs.number!}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xffE2BE7F),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            "Surah",
            arguments: {"number": surahs.number, "name": surahs.name},
          );
        },
        splashColor: Colors.red,
      ),
    );
  }
}
