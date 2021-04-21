// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

/// User Avatar Widget
class UserAvatarWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  const UserAvatarWidget({
    required this.imageUrl,
    Key? key,
  }) : super(
          key: key,
        );

  /// Image Url
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: CachedNetworkImageProvider(
          imageUrl!,
        ),
      );
    }

    return const CircleAvatar(
      backgroundColor: Color(0xFFd3d3d3),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
