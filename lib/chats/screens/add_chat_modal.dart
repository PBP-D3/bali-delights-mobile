import 'package:flutter/material.dart';

class AddChatModal extends StatefulWidget {
  final Function(int storeId) onChatCreated;

  AddChatModal({required this.onChatCreated});

  @override
  _AddChatModalState createState() => _AddChatModalState();
}

class _AddChatModalState extends State<AddChatModal> {
  TextEditingController _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _stores = [
    {"id": 1, "name": "Store A"},
    {"id": 2, "name": "Store B"},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 400,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Start a Chat!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                  SizedBox(height: 16),
                  TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Search stores",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      // Implementasi pencarian store
                    },
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _stores.length,
                      itemBuilder: (context, index) {
                        final store = _stores[index];
                        return GestureDetector(
                          onTap: () {
                            // Buat chat dengan store ini
                            widget.onChatCreated(store["id"]);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(store["name"]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFFC6AC8F),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text("✕", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
