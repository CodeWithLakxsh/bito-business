// ============================================================
// send_notification_screen.dart
// ============================================================

import 'package:flutter/material.dart';

import 'firebase_notification_service.dart';

class SendNotificationScreen
    extends StatefulWidget {

  const SendNotificationScreen({
    super.key,
  });

  @override
  State<SendNotificationScreen>
      createState() =>
          _SendNotificationScreenState();
}

class _SendNotificationScreenState
    extends State<
        SendNotificationScreen> {

  final TextEditingController
      _titleController =
          TextEditingController();

  final TextEditingController
      _bodyController =
          TextEditingController();

  final TextEditingController
      _userIdController =
          TextEditingController();

  final TextEditingController
      _vendorIdController =
          TextEditingController();

  String _targetType =
      'all_users';

  bool _isSending = false;

  Future<void> _sendNotification() async {

    final title =
        _titleController.text.trim();

    final body =
        _bodyController.text.trim();

    if (title.isEmpty ||
        body.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {

      if (_targetType ==
          'all_users') {

        await FirebaseNotificationService
            .sendToAllUsers(
          title: title,
          body: body,
        );
      }

      else if (_targetType ==
          'all_vendors') {

        await FirebaseNotificationService
            .sendToAllVendors(
          title: title,
          body: body,
        );
      }

      else if (_targetType ==
          'single_user') {

        await FirebaseNotificationService
            .sendToSingleUser(
          title: title,
          body: body,
          userId:
              _userIdController
                  .text
                  .trim(),
        );
      }

      else if (_targetType ==
          'single_vendor') {

        await FirebaseNotificationService
            .sendToSingleVendor(
          title: title,
          body: body,
          vendorId:
              _vendorIdController
                  .text
                  .trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Notification Sent",
          ),
        ),
      );

      _titleController.clear();
      _bodyController.clear();
      _userIdController.clear();
      _vendorIdController.clear();
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      _isSending = false;
    });
  }

  @override
  void dispose() {

    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    _vendorIdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF111827),

        title: const Text(
          "Send Notification",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Notification Title",

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _titleController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
                  const InputDecoration(
                hintText:
                    "Enter title",
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Notification Body",

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller:
                  _bodyController,

              maxLines: 5,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
                  const InputDecoration(
                hintText:
                    "Enter message",
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Target Type",

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _targetType,

              dropdownColor:
                  const Color(
                0xFF111827,
              ),

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
                  const InputDecoration(),

              items: const [

                DropdownMenuItem(
                  value: 'all_users',
                  child: Text(
                    "All Users",
                  ),
                ),

                DropdownMenuItem(
                  value: 'all_vendors',
                  child: Text(
                    "All Vendors",
                  ),
                ),

                DropdownMenuItem(
                  value: 'single_user',
                  child: Text(
                    "Single User",
                  ),
                ),

                DropdownMenuItem(
                  value:
                      'single_vendor',
                  child: Text(
                    "Single Vendor",
                  ),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  _targetType =
                      value!;
                });
              },
            ),

            if (_targetType ==
                'single_user') ...[

              const SizedBox(height: 24),

              TextField(
                controller:
                    _userIdController,

                style:
                    const TextStyle(
                  color:
                      Colors.white,
                ),

                decoration:
                    const InputDecoration(
                  hintText:
                      "Enter User ID",
                ),
              ),
            ],

            if (_targetType ==
                'single_vendor') ...[

              const SizedBox(height: 24),

              TextField(
                controller:
                    _vendorIdController,

                style:
                    const TextStyle(
                  color:
                      Colors.white,
                ),

                decoration:
                    const InputDecoration(
                  hintText:
                      "Enter Vendor ID",
                ),
              ),
            ],

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed:
                    _isSending
                        ? null
                        : _sendNotification,

                child: _isSending
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Text(
                        "Send Notification",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}