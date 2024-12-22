import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bali_delights_mobile/constants.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class DeleteChatModal extends StatelessWidget {
  final int chatId;
  final VoidCallback onDeleteSuccess;

  const DeleteChatModal({
    required this.chatId,
    required this.onDeleteSuccess,
    Key? key,
  }) : super(key: key);

  Future<void> _deleteChat(BuildContext context) async {
    final request = context.watch<CookieRequest>();
    try {
      final response = await request
          .post('${Constants.baseUrl}/api/chats/$chatId/delete/', {});
      if (response['success']) {
        onDeleteSuccess();
        Navigator.pop(context); // Close modal after success
      } else {
        _showErrorDialog(context, "Failed to delete chat. Please try again.");
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred while deleting the chat.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Error",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Chat'),
      content: const Text('Are you sure you want to delete this chat?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _deleteChat(context),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
