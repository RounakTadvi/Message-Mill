// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:message_mill/features/conversation/widgets/user_avatar_widget.dart';
import 'package:message_mill/models/message.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Recent Conversation List Tile
class RecentConversationListTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const RecentConversationListTile({
    required this.onTap,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
    required this.lastSeen,
    required this.type,
    Key? key,
  }) : super(
          key: key,
        );

  /// Callback is fired when users taps on the list tile
  final VoidCallback onTap;

  /// User's display name
  final String name;

  /// User's Last Message
  final String lastMessage;

  /// User's avatar Url
  final String? avatarUrl;

  /// Last Seen Time
  final Timestamp? lastSeen;

  /// Message Type
  final MessageType type;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(name),
      subtitle: type == MessageType.text
          ? Text(lastMessage)
          : const Text(
              'Attachment: Image',
            ),
      leading: UserAvatarWidget(
        imageUrl: avatarUrl,
      ),
      trailing: _trailingWidget(),
    );
  }

  Widget _trailingWidget() {
    // late Duration timeDiff;
    // if (lastSeen != null) {
    //   timeDiff = lastSeen!.toDate().difference(DateTime.now());
    // }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (lastSeen != null)
          const Text(
            'Last Message',
          ),
        if (lastSeen != null)
          Text(
            timeago.format(lastSeen!.toDate().toLocal()),
          ),
        if (lastSeen == null) const Text(''),
      ],
    );
  }
}
