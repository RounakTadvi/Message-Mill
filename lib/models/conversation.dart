// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Project imports:
import '../models/message.dart';

/// Conversation Model
class Conversation {
  // ignore: public_member_api_docs
  Conversation({
    required this.id,
    required this.members,
    required this.ownerID,
    this.messages,
  });

  /// From Document to Conversation
  factory Conversation.fromFirestore(DocumentSnapshot _snapshot) {
    Map<String, dynamic>? _data = _snapshot.data();
    debugPrint(_data.toString());
    // ignore: always_specify_types
    List _messages = _data?['messages'];
    // ignore: unnecessary_null_comparison
    if (_messages != null) {
      _messages = _messages.map(
        // ignore: always_specify_types
        (_m) {
          return Message(
            //ignore: avoid_dynamic_calls
            type: _m?['type'] == 'text' ? MessageType.text : MessageType.image,
            //ignore: avoid_dynamic_calls
            content: _m?['message'],
            //ignore: avoid_dynamic_calls
            timestamp: _m?['timestamp'],
            //ignore: avoid_dynamic_calls
            senderID: _m?['senderID'],
          );
        },
      ).toList();
    } else {
      _messages = <Message>[];
    }
    return Conversation(
      id: _snapshot.id,
      members: _data?['members'],
      ownerID: _data?['ownerID'],
      messages: _messages as List<Message>,
    );
  }

  /// Conversation ID
  final String id;

  /// Conversation participant's list
  // ignore: always_specify_types
  final List members;

  /// Messages in the particular Conversations
  final List<Message>? messages;

  /// Conversation Owner ID (User who initiated the Conversation)
  final String ownerID;
}
