import 'package:flutter/material.dart';
import 'package:islamic_app/Models/quran.dart';
import 'package:islamic_app/Network/api_service.dart';
import 'package:islamic_app/Widgets/surah_name_item.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late Future<List<Surahs>> futureSurahs;

  @override
  void initState() {
    super.initState();
    futureSurahs = getSurahsNames();
  }

  Future<List<Surahs>> getSurahsNames() async {
    ApiService surahsApiService = ApiService();
    return await surahsApiService.getQuranSurah();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/taj-mahal-agra-india.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Surahs>>(
          future: futureSurahs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xffE2BE7F)),
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Text("ERROR", style: TextStyle(color: Colors.white)),
              );
            }

            List<Surahs> su = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: 150,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                          image: AssetImage("assets/images/Quran.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: su.length,
                  itemBuilder: (context, index) {
                    return SurahNameItem(surahs: su[index]);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
