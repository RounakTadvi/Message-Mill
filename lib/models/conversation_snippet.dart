// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:message_mill/models/message.dart';

/// Conversation Snippet (Sub-collection in Users Collection)
class ConversationSnippet extends Equatable {
  // ignore: public_member_api_docs
  ConversationSnippet({
    required this.conversationID,
    required this.id,
    required this.unseenCount,
    required this.timestamp,
    required this.name,
    required this.type,
    this.image,
    this.lastMessage,
  });

  /// From Document to [ConversationSnippet]
  factory ConversationSnippet.fromFirestore(DocumentSnapshot _snapshot) {
    Map<String, dynamic>? _data = _snapshot.data();
    MessageType _messageType = MessageType.text;
    if (_data?['type'] != null) {
      switch (_data!['type']) {
        case 'text':
          break;
        case 'image':
          _messageType = MessageType.image;
          break;
        default:
      }
    }
    return ConversationSnippet(
      id: _snapshot.id,
      conversationID: _data?['conversationID'],
      lastMessage: _data?['lastMessage'] != null ? _data!['lastMessage'] : '',
      unseenCount: _data?['unseenCount'],
      timestamp: _data?['timestamp'] != null ? _data!['timestamp'] : null,
      name: _data?['name'],
      image: _data?['image'] as String?,
      type: _messageType,
    );
  }

  /// Unique Id
  final String id;

  /// Conversation Id
  final String conversationID;

  /// Last Message in the conversation
  final String? lastMessage;

  /// Name
  final String name;

  /// Image
  final String? image;

  /// Message Type
  final MessageType type;

  /// Unseen Message Count
  final int unseenCount;

  /// Timestamp
  final Timestamp? timestamp;

  @override
  List<Object?> get props => <Object?>[
        conversationID,
        id,
        lastMessage,
        unseenCount,
        timestamp,
        name,
        image,
        type,
      ];
}
