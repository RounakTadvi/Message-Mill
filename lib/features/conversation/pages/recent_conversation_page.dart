// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/features/conversation/pages/conversation_page.dart';
import 'package:message_mill/features/conversation/widgets/recent_conversation_list_tile.dart';
import 'package:message_mill/models/conversation_snippet.dart';
import 'package:message_mill/services/database_service.dart';
import 'package:message_mill/services/firebase_auth_service.dart';

/// Recent Conversation Page
class RecentConversationPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const RecentConversationPage({
    required this.deviceHeight,
    required this.deviceWidth,
    Key? key,
  }) : super(
          key: key,
        );

  /// Device Height
  final double deviceHeight;

  /// Device Widgth
  final double deviceWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      child: _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final User? currentUser =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return StreamBuilder<List<ConversationSnippet>?>(
      stream: DBService.instance.getUserConversations(currentUser?.uid),
      builder: (BuildContext context,
          AsyncSnapshot<List<ConversationSnippet>?> snapshot) {
        final List<ConversationSnippet>? data = snapshot.data;
        //debugPrint(data?.toString());
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong '),
          );
        }
        if (data != null) {
          return data.isNotEmpty
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int i) {
                    //debugPrint(data.toString());
                    return RecentConversationListTile(
                      onLongPress: () {
                        DBService.instance.deleteConversation(
                          data[i].conversationID,
                          data[i].lastMessage != null ? currentUser?.uid : null,
                          data[i].id,
                        );
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ConversationPage(
                              chatID: data[i].conversationID,
                              receiverID: data[i].id,
                              receiverImage: data[i].image,
                              receiverName: data[i].name,
                            ),
                          ),
                        );
                      },
                      name: data[i].name,
                      lastMessage: data[i].lastMessage ?? '',
                      avatarUrl: data[i].image,
                      lastSeen: data[i].timestamp,
                      type: data[i].type,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No Conversations Yet!',
                    style: TextStyle(color: Colors.white30, fontSize: 15.0),
                  ),
                );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
