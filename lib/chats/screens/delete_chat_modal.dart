import 'package:flutter/material.dart';

class DeleteChatModal extends StatelessWidget {
  final int chatId;
  final VoidCallback onDeleteSuccess;

  DeleteChatModal({required this.chatId, required this.onDeleteSuccess});

  Future<void> _deleteChat() async {
    // Panggil endpoint delete_chat disini
    // Contoh sukses langsung:
    onDeleteSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Chat?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: Text("Are you sure you want to delete this chat?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.grey[800])),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteChat();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[500]),
          child: Text("Delete"),
        )
      ],
    );
  }
}
