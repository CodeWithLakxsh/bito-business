// ============================================================
// notification_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {

  final String id;

  final String title;

  final String body;

  final String targetType;

  final String? userId;

  final String? vendorId;

  final String? imageUrl;

  final bool isRead;

  final String sentBy;

  final Timestamp? createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.targetType,
    this.userId,
    this.vendorId,
    this.imageUrl,
    required this.isRead,
    required this.sentBy,
    this.createdAt,
  });

  factory NotificationModel.fromFirestore(
    DocumentSnapshot doc,
  ) {

    final data =
        doc.data()
            as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,

      title:
          data['title'] ?? '',

      body:
          data['body'] ?? '',

      targetType:
          data['targetType'] ??
              'all_users',

      userId:
          data['userId'],

      vendorId:
          data['vendorId'],

      imageUrl:
          data['imageUrl'],

      isRead:
          data['isRead'] ?? false,

      sentBy:
          data['sentBy'] ??
              'admin',

      createdAt:
          data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {

    return {

      "title": title,

      "body": body,

      "targetType":
          targetType,

      "userId":
          userId,

      "vendorId":
          vendorId,

      "imageUrl":
          imageUrl,

      "isRead":
          isRead,

      "sentBy":
          sentBy,

      "createdAt":
          createdAt ??
              FieldValue.serverTimestamp(),
    };
  }
}