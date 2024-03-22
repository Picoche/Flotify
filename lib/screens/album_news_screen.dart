import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/albums_provider.dart';

class AlbumNewsScreen extends StatefulWidget {
  const AlbumNewsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AlbumNewsScreenState createState() => _AlbumNewsScreenState();
}

class _AlbumNewsScreenState extends State<AlbumNewsScreen> {
  int currentPage = 1;
  Future<void>? fetchAlbumsFuture;

  @override
  void initState() {
    super.initState();
    fetchAlbumsFuture = Provider.of<AlbumsProvider>(context, listen: false)
        .fetchAlbums(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final albumsProvider = Provider.of<AlbumsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Album News Screen')),
      body: StreamBuilder(
        stream: albumsProvider.fetchAlbumsStream,
        builder: (ctx, snapshot) {
          return FutureBuilder(
            future: fetchAlbumsFuture,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  // Error handling...
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: albumsProvider.albums.length,
                          itemBuilder: (ctx, i) => ListTile(
                            tileColor: i % 2 == 0
                                ? Colors.grey[200]
                                : Colors
                                    .white, // alternating colors for each tile
                            title: Text(
                              albumsProvider.albums[i].name ?? '',
                              style: const TextStyle(
                                color: Colors.black, // text color
                                fontWeight: FontWeight.bold, // text weight
                                fontSize: 18, // increase font size
                              ),
                            ),
                            subtitle: Text(
                              albumsProvider.albums[i].artists![0].name ?? '',
                              style: const TextStyle(
                                color: Colors.grey, // text color
                                fontStyle: FontStyle.italic, // text style
                                fontSize: 14, // increase font size
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  albumsProvider.albums[i].images![0].url!),
                              backgroundColor: Colors.blue,
                              radius: 30,
                            ),
                            onTap: () => context.go(
                                '/a/albumdetails/${albumsProvider.albums[i].id}'),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage--;
                              });
                              albumsProvider.fetchAlbums(currentPage);
                            },
                            child: const Text('Previous'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                currentPage++;
                              });
                              albumsProvider.fetchAlbums(currentPage);
                            },
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
