import 'dart:convert';

import 'package:http/http.dart' as http;

class TelegramService {

  static const String _botToken =
      'YOUR_BOT_TOKEN';

  static const String _chatId =
      'YOUR_CHAT_ID';

  static Future<void> sendMessage(
    String message,
  ) async {

    try {

      final url =
          Uri.parse(
        'https://api.telegram.org/bot$_botToken/sendMessage',
      );

      await http.post(
        url,

        headers: {
          'Content-Type':
              'application/json',
        },

        body: jsonEncode({
          'chat_id': _chatId,
          'text': message,
          'parse_mode': 'HTML',
        }),
      );

    } catch (e) {
      print(
        'Telegram Error: $e',
      );
    }
  }
}