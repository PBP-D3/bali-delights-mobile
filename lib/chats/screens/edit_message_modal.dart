import 'package:flutter/material.dart';

class EditMessageModal extends StatefulWidget {
  final String initialContent;
  final Function(String updatedContent) onSave;

  EditMessageModal({required this.initialContent, required this.onSave});

  @override
  _EditMessageModalState createState() => _EditMessageModalState();
}

class _EditMessageModalState extends State<EditMessageModal> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialContent;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Message", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.grey[800])),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedContent = _controller.text.trim();
            if (updatedContent.isNotEmpty) {
              widget.onSave(updatedContent);
            }
          },
          child: Text("Save"),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFC6AC8F)),
        ),
      ],
    );
  }
}
