import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'telegram_service.dart';

class NotificationListenerService {

  static StreamSubscription?
      _supportTicketSubscription;

  static StreamSubscription?
      _aiChatSubscription;

  static StreamSubscription?
      _blockedUserSubscription;

  // ─────────────────────────────────────────
  // START ALL LISTENERS
  // ─────────────────────────────────────────

  static void start() {

    _listenSupportTickets();

    _listenAiRepresentativeRequests();

    _listenBlockedUsers();
  }

  // ─────────────────────────────────────────
  // SUPPORT TICKETS
  // ─────────────────────────────────────────

  static void _listenSupportTickets() {

    _supportTicketSubscription =
        FirebaseFirestore.instance
            .collection(
                'support_tickets')
            .snapshots()
            .listen((snapshot) async {

      for (final change
          in snapshot.docChanges) {

        if (change.type !=
            DocumentChangeType.added) {
          continue;
        }

        final data =
            change.doc.data();

        if (data == null) continue;

        await TelegramService.sendMessage(
          '''
🎫 NEW SUPPORT TICKET

👤 User:
${data['userName'] ?? 'Unknown'}

📧 Email:
${data['email'] ?? 'No Email'}

📝 Title:
${data['title'] ?? ''}

💬 Message:
${data['message'] ?? ''}

🆔 Ticket ID:
${change.doc.id}

''',
        );
      }
    });
  }

  // ─────────────────────────────────────────
  // AI REPRESENTATIVE REQUESTS
  // ─────────────────────────────────────────

  static void _listenAiRepresentativeRequests() {

    _aiChatSubscription =
        FirebaseFirestore.instance
            .collection('ai_chats')
            .snapshots()
            .listen((snapshot) async {

      for (final change
          in snapshot.docChanges) {

        if (change.type !=
            DocumentChangeType.modified) {
          continue;
        }

        final data =
            change.doc.data();

        if (data == null) continue;

        final requested =
            data[
                'representativeRequested'] ??
                false;

        if (requested != true) {
          continue;
        }

        await TelegramService.sendMessage(
          '''
🚨 AI REPRESENTATIVE REQUEST

👤 User:
${data['userName'] ?? 'Unknown'}

📧 Email:
${data['email'] ?? 'No Email'}

💬 Last Message:
${data['lastUserMessage'] ?? ''}

🆔 Chat ID:
${change.doc.id}

''',
        );
      }
    });
  }

  // ─────────────────────────────────────────
  // BLOCKED USERS
  // ─────────────────────────────────────────

  static void _listenBlockedUsers() {

    _blockedUserSubscription =
        FirebaseFirestore.instance
            .collection('users')
            .snapshots()
            .listen((snapshot) async {

      for (final change
          in snapshot.docChanges) {

        if (change.type !=
            DocumentChangeType.modified) {
          continue;
        }

        final data =
            change.doc.data();

        if (data == null) continue;

        final isBlocked =
            data['isBlocked'] ?? false;

        if (isBlocked != true) {
          continue;
        }

        await TelegramService.sendMessage(
          '''
⛔ USER BLOCKED

👤 Name:
${data['name'] ?? 'Unknown'}

📧 Email:
${data['email'] ?? 'No Email'}

📱 Phone:
${data['phone'] ?? 'No Phone'}

📝 Reason:
${data['blockedReason'] ?? 'No Reason'}

🆔 User ID:
${change.doc.id}

''',
        );
      }
    });
  }

  // ─────────────────────────────────────────
  // DISPOSE
  // ─────────────────────────────────────────

  static Future<void> dispose()
  async {

    await _supportTicketSubscription
        ?.cancel();

    await _aiChatSubscription
        ?.cancel();

    await _blockedUserSubscription
        ?.cancel();
  }
}