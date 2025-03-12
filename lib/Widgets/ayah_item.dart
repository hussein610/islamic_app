import 'package:flutter/material.dart';
import 'package:islamic_app/Models/quran.dart';

class AyahItem extends StatelessWidget {
  final Ayahs Ayah;

  const AyahItem({super.key, required this.Ayah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xffE2BE7F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                Ayah.text!,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
            ),
            if (Ayah.sajda == true)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mosque, color: Colors.brown, size: 24),
                    SizedBox(width: 5),
                    Text(
                      "آية سجود",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${Ayah.numberInSurah}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
