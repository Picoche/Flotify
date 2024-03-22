import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import "../providers/query_provider.dart";

import "../models/albums_model.dart";
import "../models/artist_model.dart";
import "../models/tracks_model.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<bool> isSelected = [true, false, false];
  late TextEditingController controller;
  late bool isSearchButtonClicked;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    isSearchButtonClicked = false;
  }

  @override
  void dispose() {
    controller.dispose(); // Don't forget to dispose it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryProvider = Provider.of<QueryProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
        actions: [
          ToggleButtons(
            borderColor: Colors.blue,
            fillColor: Colors.blue,
            borderWidth: 2,
            selectedBorderColor: Colors.blue,
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(0),
            color: Colors.blue,
            constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
            renderBorder: false,
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = !isSelected[buttonIndex];
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                  isSearchButtonClicked = false;
                  controller.text = '';
                }
              });
            },
            isSelected: isSelected, // remove default border
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Albums'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Artistes'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Chansons'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearchButtonClicked = true;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: isSearchButtonClicked
                  ? FutureBuilder(
                      future: queryProvider.fetchQuery(
                          controller.text,
                          isSelected
                              .indexWhere((bool isSelected) => isSelected)),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No data available'));
                        } else {
                          final selectedIndex = isSelected
                              .indexWhere((bool isSelected) => isSelected);
                          switch (selectedIndex) {
                            case 0: // Albums
                              final albums = snapshot.data as List<Album>;
                              return ListView.builder(
                                itemCount: albums.length,
                                itemBuilder: (ctx, i) => ListTile(
                                  tileColor: i % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  title: Text(
                                    albums[i].name!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    albums[i].artists![0].name!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        albums[i].images![0].url!),
                                    backgroundColor: Colors.blue,
                                    radius: 30,
                                  ),
                                  onTap: () => context
                                      .push('/a/albumdetails/${albums[i].id}'),
                                ),
                              );
                            case 1: // Artists
                              final artists = snapshot.data as List<Artist>;
                              return ListView.builder(
                                itemCount: artists.length,
                                itemBuilder: (ctx, i) => ListTile(
                                  tileColor: i % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  title: Text(
                                    artists[i].name!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        artists[i].images![0].url!),
                                    backgroundColor: Colors.blue,
                                    radius: 30,
                                  ),
                                  onTap: () => context.go(
                                      '/a/artistedetails/${artists[i].id}'),
                                ),
                              );
                            case 2: // Tracks
                              final tracks = snapshot.data as List<Track>;
                              return ListView.builder(
                                itemCount: tracks.length,
                                itemBuilder: (ctx, i) => ListTile(
                                  tileColor: i % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  title: Text(
                                    tracks[i].name!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    tracks[i].artists![0].name!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        tracks[i].album!.images![0].url!),
                                    backgroundColor: Colors.blue,
                                    radius: 30,
                                  ),
                                  onTap: () => context.go('/a/albumdetails/${tracks[i].album!.id!}'),
                                ),
                              );
                            default:
                              return const Center(child: Text('No data'));
                          }
                        }
                      },
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
