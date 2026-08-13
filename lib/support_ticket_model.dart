import 'package:cloud_firestore/cloud_firestore.dart';

class SupportTicketModel {
  final String id;
  final String userId;
  final String userName;
  final String email;
  final String title;
  final String lastMessage;
  final String status;
  final String type;

  final bool representativeRequested;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  SupportTicketModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.email,
    required this.title,
    required this.lastMessage,
    required this.status,
    required this.type,
    required this.representativeRequested,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicketModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;

    return SupportTicketModel(
      id: doc.id,

      userId: data['userId'] ?? '',

      userName:
          data['userName'] ?? '',

      email: data['email'] ?? '',

      title: data['title'] ?? '',

      lastMessage:
          data['lastMessage'] ?? '',

      status:
          data['status'] ?? 'open',

      type:
          data['type'] ?? 'user',

      representativeRequested:
          data['representativeRequested'] ??
              false,

      createdAt:
          data['createdAt'],

      updatedAt:
          data['updatedAt'],
    );
  }
}