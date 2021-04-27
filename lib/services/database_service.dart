// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:message_mill/models/contact.dart';
import 'package:message_mill/models/conversation.dart';
import 'package:message_mill/models/conversation_snippet.dart';
import 'package:message_mill/models/message.dart';

/// Data base Service
class DBService {
  // ignore: public_member_api_docs
  DBService() {
    _db = FirebaseFirestore.instance;
  }

  /// Singletion
  static DBService instance = DBService();

  late FirebaseFirestore _db;

  /// Users Collection
  final String _userCollection = 'Users';

  /// Conversation Collection
  final String _conversationsCollection = 'Conversations';

  /// Create a User In Database
  Future<void> createUserInDb({
    required String uid,
    required String name,
    required String email,
    required String imageUrl,
  }) async {
    try {
      final CollectionReference users = _db.collection(_userCollection);

      return await users.doc(uid).set(<String, dynamic>{
        'name': name,
        'email': email,
        'image': imageUrl,
        'lastSeen': DateTime.now().toUtc(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Get Contact
  Stream<Contact?> getUserData(String? userID) {
    final DocumentReference ref = _db.collection(_userCollection).doc(userID);
    return ref.get().asStream().map(
          (DocumentSnapshot snapshot) => Contact.fromFirestore(snapshot),
        );
  }

  /// Get Current User's Conversation
  Stream<List<ConversationSnippet>> getUserConversations(String? userID) {
    final CollectionReference ref = _db
        .collection(_userCollection)
        .doc(userID)
        .collection(_conversationsCollection);

    return ref.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map(
        (QueryDocumentSnapshot doc) {
          return ConversationSnippet.fromFirestore(doc);
        },
      ).toList();
    });
  }

  /// Search Users
  Stream<List<Contact>?> searchUsers(String query) {
    debugPrint('Query: $query');
    final Query ref = _db
        .collection(_userCollection)
        .where('name', isGreaterThanOrEqualTo: query)
        // ignore: prefer_interpolation_to_compose_strings
        .where('name', isLessThan: query + 'z');
    return ref.get().asStream().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((QueryDocumentSnapshot _doc) {
        return Contact.fromFirestore(_doc);
      }).toList();
    });
  }

  /// Update Last Seen
  Future<void> updateUserLastSeen(String? uid) {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);
    return ref.update(<String, dynamic>{
      'lastSeen': Timestamp.now(),
    });
  }

  /// Get User Conversation
  Stream<Conversation?> getConversation(String conversationID) {
    final DocumentReference ref =
        _db.collection(_conversationsCollection).doc(conversationID);
    return ref.snapshots().map(
      (DocumentSnapshot _snapshot) {
        return Conversation.fromFirestore(_snapshot);
      },
    );
  }

  /// Send a Message to another user
  Future<void> sendMessage(String chatID, Message message) async {
    final DocumentReference ref =
        _db.collection(_conversationsCollection).doc(chatID);
    String _messageType = '';
    switch (message.type) {
      case MessageType.text:
        _messageType = 'text';
        break;
      case MessageType.image:
        _messageType = 'image';
        break;
      default:
    }

    return ref.update(
      <String, dynamic>{
        'messages': FieldValue.arrayUnion(
          <dynamic>[
            <String, dynamic>{
              'message': message.content,
              'senderID': message.senderID,
              'timestamp': message.timestamp,
              'type': _messageType,
            }
          ],
        ),
      },
    );
  }

  /// Create Or Get Conversartion
  Future<void> createOrGetConversartion(String currentID, String recepientID,
      Future<void> Function(String _conversationID) _onSuccess) async {
    final CollectionReference _ref = _db.collection(_conversationsCollection);
    final CollectionReference _userConversationRef = _db
        .collection(_userCollection)
        .doc(currentID)
        .collection(_conversationsCollection);
    try {
      DocumentSnapshot conversation =
          await _userConversationRef.doc(recepientID).get();
      if (conversation.data() != null) {
        return _onSuccess(conversation.data()?['conversationID'] as String);
      } else {
        DocumentReference _conversationRef = _ref.doc();
        await _conversationRef.set(
          <String, dynamic>{
            'members': <String>[currentID, recepientID],
            'ownerID': currentID,
            'messages': <dynamic>[],
          },
        );
        return _onSuccess(_conversationRef.id);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Delete a User Conversation
  Future<void> deleteConversation(
      String chatId, String? currentUserID, String receipentUserId) async {
    debugPrint(
        // ignore: lines_longer_than_80_chars
        'Chat Id: $chatId, CurrentUserId: $currentUserID,receipentUserId: $receipentUserId');
    final CollectionReference _conversationsCollectionRef =
        _db.collection(_conversationsCollection);
    final CollectionReference _userCollectionRef =
        _db.collection(_userCollection);
    try {
      await _conversationsCollectionRef.doc(chatId).delete().then(
          (_) => debugPrint('$chatId in Conversations Collection deleted'));
      await _userCollectionRef
          .doc(currentUserID)
          .collection(_conversationsCollection)
          .doc(receipentUserId)
          .delete()
          .then((_) => debugPrint(
              '$chatId in User\'s Conversations Collection deleted'));
      await _userCollectionRef
          .doc(receipentUserId)
          .collection(_conversationsCollection)
          .doc(currentUserID)
          .delete()
          .then(
            (_) => debugPrint(
                '''$chatId in User\'s Conversations Collection deleted for receipednt'''),
          );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
