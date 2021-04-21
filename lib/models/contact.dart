// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Contact Model
@immutable
class Contact extends Equatable {
  // ignore: public_member_api_docs
  Contact({
    this.id,
    this.email,
    this.name,
    this.image,
    this.lastseen,
  });

  /// From Document to Contact
  factory Contact.fromFirestore(DocumentSnapshot _snapshot) {
    final Map<String, dynamic>? _data = _snapshot.data();
    return Contact(
      id: _snapshot.id,
      lastseen: _data?['lastSeen'],
      email: _data?['email'],
      name: _data?['name'],
      image: _data?['image'],
    );
  }

  /// Contact ID
  final String? id;

  /// Contact's Email
  final String? email;

  /// Contact's Avatar Url
  final String? image;

  /// Last Seen Time
  final Timestamp? lastseen;

  /// Contact's name
  final String? name;

  @override
  List<Object?> get props => <Object?>[
        id,
        email,
        name,
        image,
        lastseen,
      ];
}
