import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../data/team_data.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text(
              'Short Biodata',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          body: _profileCarrousel(context, memberList)),
    );
  }

  Widget _profileCarrousel(BuildContext context, List<Bio> profiles) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
            ),
            items: profiles.map((Bio member) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: const Color(0xfffffbff),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/profil.jpg"),
                      radius: 50,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      member.name!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    Text(member.nim!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )),
                    Text(member.kelas!),
                    Text(member.hobby!),
                    const SizedBox(height: 5),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
