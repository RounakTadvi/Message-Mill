// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Messaget Type
/// 1. Text Message
/// 2. Image content
enum MessageType {
  /// Text Message
  text,

  /// Image
  image,

  /// We are using enum in case we need to add different types of message types
  /// in future version of app like voice message, gif etc
}

/// Message Model
class Message extends Equatable {
  // ignore: public_member_api_docs
  Message({
    required this.senderID,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  /// Message Sender Uuid
  final String senderID;

  /// Message Content
  final String content;

  /// Timestamp
  final Timestamp timestamp;

  /// Message Type
  final MessageType type;

  @override
  List<Object?> get props => <Object?>[
        senderID,
        content,
        timestamp,
        type,
      ];
}
