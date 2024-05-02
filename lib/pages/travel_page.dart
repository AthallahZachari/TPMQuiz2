import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tpm_kelompok/pages/detail_page.dart';
import '../data/travel_data.dart';

class TravelPage extends StatefulWidget {
  final bool filterFav;
  final String filterTags;
  const TravelPage({
    super.key,
    this.filterFav = false,
    this.filterTags = '',
  });
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final checkLogin = GetStorage('checkLogin');
  final favorite = GetStorage('favorite');
  List<IconData> iconStyle = [
    Icons.bookmark_border_rounded,
    Icons.bookmark_rounded
  ]; //default, fav
  List<Color> iconColor = [
    Colors.grey.shade400,
    const Color(0xFF00458B)
  ]; //default, fav
  late String username = checkLogin.read('username');
  late var userFavorite = favorite.read(username);
  @override
  Widget build(BuildContext context) {
    String title = 'Travel Sites';
    if (widget.filterFav) {
      title = 'Favorites';
    } else if (widget.filterTags.isNotEmpty) {
      title = widget.filterTags;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: _siteList(),
      ),
    );
  }

  Widget _siteList() {
    List<TravelItem> filteredList = [];
    if (widget.filterFav) {
      for (int i = 0; i < userFavorite.length; i++) {
        filteredList
            .add(travelList.where((item) => item.id == userFavorite[i]).first);
      }
    } else if (widget.filterTags.isNotEmpty) {
      for (int i = 0; i < travelList.length; i++) {
        if (travelList[i].tags.contains(widget.filterTags)) {
          filteredList.add(travelList[i]);
        }
      }
    } else {
      filteredList = travelList;
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return _siteItem(filteredList[index]);
      },
      itemCount: filteredList.length,
    );
  }

  Widget _siteItem(TravelItem travel) {
    int stateIndex = userFavorite.contains(travel.id) ? 1 : 0;
    String tags = '';
    int tagCount = travel.tags.length >= 3 ? 3 : travel.tags.length;
    for (int i = 0; i < tagCount; i++) {
      tags = '$tags${travel.tags[i]}';
      if (i != tagCount - 1) {
        tags = '$tags, ';
      }
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailPage(id: travel.id!);
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          travel.name!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 15),
                      _favBtn(travel.id!, stateIndex),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${travel.company!} • $tags',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${travel.rating!} ★   ${travel.size!} MB',
                    style: TextStyle(color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favBtn(int id, int stateIndex) {
    return IconButton(
      onPressed: () {
        setState(() {
          if (stateIndex == 0) {
            userFavorite.add(id);
          } else {
            userFavorite.remove(id);
          }
          favorite.write(username, userFavorite);
        });
      },
      alignment: Alignment.center,
      icon: Icon(iconStyle[stateIndex]),
      color: iconColor[stateIndex],
      iconSize: 24,
      splashRadius: 24,
      constraints: const BoxConstraints.tightFor(height: 24, width: 24),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    );
  }
}
