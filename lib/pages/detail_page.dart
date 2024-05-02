import 'package:flutter/material.dart';
import 'package:tpm_kelompok/pages/travel_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/travel_data.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TravelItem travel =
      travelList.where((item) => item.id == widget.id).first;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            'Details',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: _bodyContent(),
      ),
    );
  }

  Widget _bodyContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _header(),
          _imageSlides(),
          _tagSlides(),
          _appDescription(),
          _minorInfoTable(),
          _listButton(),
          const SizedBox(height: 15)
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                travel.icon!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  travel.name!,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  travel.company!,
                  style: const TextStyle(
                      color: Color(0xFF00458B), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSlides() {
    List<Widget> images = [];
    images.add(const SizedBox(width: 15));
    for (int i = 0; i < travel.images.length; i++) {
      images.add(_imageItem(i));
      images.add(const SizedBox(width: 15));
    }
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: images,
        ),
      ),
    );
  }

  Widget _imageItem(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImagePage(
              images: travel.images,
              initialIndex: index,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            travel.images[index],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _appDescription() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this site',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(travel.desc!),
        ],
      ),
    );
  }

  Widget _tagSlides() {
    List<Widget> tags = [];
    tags.add(const SizedBox(width: 15));
    for (int i = 0; i < travel.tags.length; i++) {
      tags.add(_tagItem(i));
      if (i != travel.tags.length - 1) {
        tags.add(const SizedBox(width: 5));
      }
    }
    tags.add(const SizedBox(width: 15));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: tags,
        ),
      ),
    );
  }

  Widget _tagItem(int index) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TravelPage(filterTags: travel.tags[index]);
            },
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.grey.shade600,
        side: BorderSide(color: Colors.grey.shade600),
        padding: const EdgeInsets.all(10),
      ),
      child: Text(
        travel.tags[index],
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _minorInfoTable() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            children: [
              _minorTableItem('${travel.rating} ★', 'Rating'),
              _minorTableItem('${travel.size} MB', 'Size'),
            ],
          ),
        ],
      ),
    );
  }

  TableCell _minorTableItem(String content, String label) {
    return TableCell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _listButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          _button(
            text: 'View Google Play Store',
            image: 'playstore.png',
            url: travel.url['playstore'],
            fgColor: Colors.black,
            borderColor: Colors.black,
          ),
          const SizedBox(height: 10),
          _button(
            text: 'View Website',
            url: travel.url['web'],
            fgColor: Colors.grey.shade600,
            borderColor: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _button({
    String? text,
    String image = '',
    String? url,
    Color? fgColor,
    Color? borderColor,
  }) {
    Uri parsedUrl = Uri.parse(url!);
    dynamic childItem;
    if (image.isNotEmpty) {
      childItem = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/$image',
            width: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      childItem = Text(text!);
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        onPressed: () {
          _launchUrl(parsedUrl);
        },
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: fgColor,
          side: BorderSide(color: borderColor!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(15),
        ),
        child: childItem,
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class FullScreenImagePage extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImagePage(
      {super.key, required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: images.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return Image.network(
            images[index],
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
