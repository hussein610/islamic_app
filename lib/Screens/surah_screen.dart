import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:islamic_app/Models/quran.dart';

import '../Network/api_service.dart';
import '../Widgets/ayah_item.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  late Future<List<Ayahs>> futureAyahs;

  @override
  void initState() {
    super.initState();
    futureAyahs = getAyahs();
  }

  Future<List<Ayahs>> getAyahs() async {
    ApiService ayahsApiService = ApiService();
    return await ayahsApiService.getQuranAyahs();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int number = data["number"];
    final String name = data["name"];

    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xffE2BE7F)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/taj-mahal-agra-india 1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Ayahs>>(
          future: futureAyahs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xffE2BE7F)),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("ERROR", style: TextStyle(color: Colors.white)),
              );
            }

            List<Ayahs> ayahs = snapshot.data!;
            List<Ayahs> ayahFilter =
                ayahs.where((i) => i.numberOfSurah == number).toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FlutterIslamicIcons.quran2,
                            color: Colors.white,
                            size: 35,
                          ),
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ayahFilter.isEmpty
                    ? SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "ERROR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                    : SliverList.builder(
                      itemCount: ayahFilter.length,
                      itemBuilder: (context, index) {
                        return AyahItem(Ayah: ayahFilter[index]);
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
