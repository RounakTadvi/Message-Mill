// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

/// Image Message Page
class ImageMessagePage extends StatelessWidget {
  // ignore: public_member_api_docs
  const ImageMessagePage({required this.imageUrl, Key? key})
      : super(
          key: key,
        );

  /// Image url
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
