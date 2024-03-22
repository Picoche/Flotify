import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/albums_provider.dart';

/// The details screen
class AlbumDetailScreen extends StatefulWidget {
  final String albumID;

  const AlbumDetailScreen({Key? key, required this.albumID}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AlbumsProvider>(context, listen: false)
        .fetchAlbum(widget.albumID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AlbumsProvider>(context, listen: false)
          .fetchAlbum(widget.albumID),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.error != null) {
            // Error handling
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<AlbumsProvider>(
              builder: (ctx, albumsProvider, _) {
                final album = albumsProvider.album;
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      album.name ?? 'Unknown Album',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Add this line
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Change this line
                        children: [
                          Text(
                            album.name ?? 'Unknown Album',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          if (album.artists != null &&
                              album.artists!.isNotEmpty)
                            // Loop over the artists
                            for (var artist in album.artists!)
                              GestureDetector(
                                onTap: () => context
                                    .push('/a/artistedetails/${artist.id}'),
                                child: Text(
                                  artist.name ?? 'Unknown Artist',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                          const SizedBox(height: 16.0),
                          if (album.images != null && album.images!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: album.images![0].url ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded rectangle
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20), // Bigger size
                            ),
                            child: const Text('Go back'),
                          ),
                          const SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
