// ============================================================
// firebase_notification_service.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNotificationService {

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // =========================================================
  // SEND TO ALL USERS
  // =========================================================

  static Future<void> sendToAllUsers({
    required String title,
    required String body,
    String? imageUrl,
  }) async {

    await _firestore
        .collection('notifications')
        .add({

      "title": title,

      "body": body,

      "targetType":
          "all_users",

      "userId": null,

      "vendorId": null,

      "imageUrl":
          imageUrl ?? "",

      "isRead": false,

      "sentBy": "admin",

      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // SEND TO ALL VENDORS
  // =========================================================

  static Future<void> sendToAllVendors({
    required String title,
    required String body,
    String? imageUrl,
  }) async {

    await _firestore
        .collection('notifications')
        .add({

      "title": title,

      "body": body,

      "targetType":
          "all_vendors",

      "userId": null,

      "vendorId": null,

      "imageUrl":
          imageUrl ?? "",

      "isRead": false,

      "sentBy": "admin",

      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // SEND TO SINGLE USER
  // =========================================================

  static Future<void> sendToSingleUser({
    required String title,
    required String body,
    required String userId,
    String? imageUrl,
  }) async {

    await _firestore
        .collection('notifications')
        .add({

      "title": title,

      "body": body,

      "targetType":
          "single_user",

      "userId": userId,

      "vendorId": null,

      "imageUrl":
          imageUrl ?? "",

      "isRead": false,

      "sentBy": "admin",

      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // SEND TO SINGLE VENDOR
  // =========================================================

  static Future<void> sendToSingleVendor({
    required String title,
    required String body,
    required String vendorId,
    String? imageUrl,
  }) async {

    await _firestore
        .collection('notifications')
        .add({

      "title": title,

      "body": body,

      "targetType":
          "single_vendor",

      "userId": null,

      "vendorId": vendorId,

      "imageUrl":
          imageUrl ?? "",

      "isRead": false,

      "sentBy": "admin",

      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }
}