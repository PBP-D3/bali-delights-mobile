import 'package:flutter/material.dart';
import '../../api_service.dart'; // Pastikan path ke ApiService benar

class EditMessageModal extends StatefulWidget {
  final int messageId; // Tambahkan messageId untuk API
  final String initialContent;
  final Function(String updatedContent) onSave;

  const EditMessageModal({
    required this.messageId,
    required this.initialContent,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  _EditMessageModalState createState() => _EditMessageModalState();
}

class _EditMessageModalState extends State<EditMessageModal> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  Future<void> _saveMessage(BuildContext context) async {
    final updatedContent = _controller.text.trim();
    if (updatedContent.isEmpty) return;

    try {
      // Call API service to update the message
      final success = await ApiService.editMessage(widget.messageId, updatedContent);
      if (success) {
        widget.onSave(updatedContent);
        Navigator.pop(context); // Close the modal on success
      } else {
        _showErrorDialog(context, "Failed to save the message. Please try again.");
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred while saving the message.");
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
        "Edit Message",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => _saveMessage(context),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC6AC8F)),
          child: const Text("Save"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
