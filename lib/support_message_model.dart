import 'package:cloud_firestore/cloud_firestore.dart';

class SupportMessageModel {
  final String id;

  final String senderId;
  final String senderName;

  final String senderType;

  final String message;

  final Timestamp? createdAt;

  SupportMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.createdAt,
  });

  factory SupportMessageModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;

    return SupportMessageModel(
      id: doc.id,

      senderId:
          data['senderId'] ?? '',

      senderName:
          data['senderName'] ?? '',

      senderType:
          data['senderType'] ?? '',

      message:
          data['message'] ?? '',

      createdAt:
          data['createdAt'],
    );
  }
}