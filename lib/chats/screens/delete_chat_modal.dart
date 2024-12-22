import 'package:flutter/material.dart';
import '../../api_service.dart'; // Pastikan path ke ApiService benar

class DeleteChatModal extends StatelessWidget {
  final int chatId;
  final VoidCallback onDeleteSuccess;

  const DeleteChatModal({
    required this.chatId,
    required this.onDeleteSuccess,
    Key? key,
  }) : super(key: key);

  Future<void> _deleteChat(BuildContext context) async {
    try {
      final success = await ApiService.deleteChat(chatId);
      if (success) {
        onDeleteSuccess();
        Navigator.pop(context); // Tutup modal setelah sukses
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
      title: const Text(
        "Delete Chat?",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure you want to delete this chat?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => _deleteChat(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
