import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../services/api_service.dart';

class EditMessageModal extends StatefulWidget {
  final int messageId;
  final String initialContent;
  final Function(String) onSave;

  const EditMessageModal({
    Key? key,
    required this.messageId,
    required this.initialContent,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditMessageModalState createState() => _EditMessageModalState();
}

class _EditMessageModalState extends State<EditMessageModal> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final request = context.read<CookieRequest>();

    try {
      final success = await ApiService.editMessage(
        request,
        widget.messageId,
        _controller.text.trim(),
      );

      if (success && mounted) {
        widget.onSave(_controller.text.trim());
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error editing message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Message'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Edit your message',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC6AC8F),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
